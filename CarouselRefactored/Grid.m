//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <pop/POPAnimatableProperty.h>
#import "Grid.h"
#import "Rotator.h"
#import "GridHelper.h"
#import "RotationGestureRecognizer.h"
#import "Cell.h"


@interface Grid () <UIGestureRecognizerDelegate>
@property(nonatomic) CGFloat startOffset;

@property (strong, nonatomic) RotationGestureRecognizer *rotationRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end

@implementation Grid

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self calculateDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self calculateDefaults];
    }
    return self;
}

- (void)calculateDefaults {
    self.grid = [[GridHelper alloc] init];
    self.rotator = [[Rotator alloc] init];

    [self.grid setFrame:self.frame];

    CGFloat offsetMax = (CGFloat) (M_PI * 2);

    _maxCellsOffset = offsetMax;
    _cellsOffset = 0.f;

    [self setupTouches];
}

- (void)setupTouches {
    self.rotationRecognizer = [[RotationGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleRotationGesture:)];
    self.rotationRecognizer.delegate = self;

    self.tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.tapRecognizer setMinimumPressDuration:0.0001];
    self.tapRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapRecognizer];

    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleLongPressGesture:)];
    self.longPressRecognizer.delegate = self;

    [self addGestureRecognizer:self.longPressRecognizer];

    [self addGestureRecognizer:self.rotationRecognizer];
}

//handle Pan
- (void)handleRotationGesture:(RotationGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.rotator stopAnimationsOnGrid:self];
            self.startOffset = self.cellsOffset;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [recognizer locationInView:self];

            CGFloat currentAngle = [recognizer currentAngleInView:self];
            CGFloat startAngle = [recognizer startAngleInView:self];
            CGFloat deltaAngle = (CGFloat)((CGFloat)currentAngle - (CGFloat)startAngle);
            NSUInteger indexPath = [self.grid indexWithPoint:point];
            if (indexPath == 8) {
                return;
            }
            self.cellsOffset = self.startOffset + (CGFloat) (deltaAngle);
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self.rotator decayAnimationWithVelocity:[recognizer angleVelocityInView:self] onCarouselView:self];
        }
            break;
        default: {
            // Do nothing...
        }
            break;
    }
}

//handle Long Tap
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self.tapRecognizer setEnabled:NO];
            CGPoint point = [recognizer locationInView:self];
            NSUInteger index = [self.grid indexForCellWithPoint:point
                                                     withOffset:self.cellsOffset];
            [self.cells[index] longTapStarted];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self.tapRecognizer setEnabled:YES];
            CGPoint point = [recognizer locationInView:self];
            NSUInteger index = [self.grid indexForCellWithPoint:point
                                                     withOffset:self.cellsOffset];

            [self.cells[index] longTapEnded];
            if (![self.rotator isDecayAnimationActiveOnGrid:self]) {
                [self bounceCells];
            }
        }
            break;

        default:
            break;
    }
}

//Handle tap
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: { //touch down
            //stop animation
            [self.rotator stopAnimationsOnGrid:self];
        } break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateEnded: { //touch up
            //call delegate to tell him, that view were tapped
            CGPoint point = [recognizer locationInView:self];
            NSUInteger index = [self.grid indexForCellWithPoint:point
                                                     withOffset:self.cellsOffset];
            [self.cells[index] tapped];

            if (![self.rotator isDecayAnimationActiveOnGrid:self]) {
                [self bounceCells];
            }

        } break;
        default:
            break;
    }
}

-(void)layoutSubviews {
    [self.grid setFrame:self.frame];
}

- (void)placeCells {
    [self.rotator rotateCells:self.cells onAngle:self.cellsOffset withGrid:self.grid];
}

- (void)bounceCells {
    self.cellsOffset = self.cellsOffset;
    CGFloat angle = [Geometry nearestFixedPositionFrom:self.cellsOffset];
    [self.rotator bounceAnimationToAngle:angle onCarouselView:self];
}

- (void)setCellsOffset:(CGFloat)cellsOffset {
    _cellsOffset = cellsOffset;
    while (_cellsOffset > _maxCellsOffset) {
        _cellsOffset -= _maxCellsOffset;
    }
    while (_cellsOffset < 0) {
        _cellsOffset += _maxCellsOffset;
    }
    [self placeCells];
}

-(void) setCells:(NSArray *)cells {
    _cells = cells;
    for (Cell *cell in cells) {
        [self addSubview:cell];
    }
    [self.rotator stopAnimationsOnGrid:self];
    self.cellsOffset = 0.f;
}

#pragma mark - <POPAnimationDelegate>

- (void)pop_animationDidApply:(POPAnimation *)anim {
    [self.rotator stopDecayAnimationIfNeeded:anim onGrid:self];
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.longPressRecognizer]) {
        BOOL isCellsInPlace = fabs(self.cellsOffset - [Geometry nearestFixedPositionFrom:self.cellsOffset]) <= 0.001;
        return  isCellsInPlace;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    if (gestureRecognizer == self.longPressRecognizer && otherGestureRecognizer == self.rotationRecognizer) {
        return NO;
    } else {
        return !(gestureRecognizer == self.rotationRecognizer && otherGestureRecognizer == self.longPressRecognizer);
    }
}

@end
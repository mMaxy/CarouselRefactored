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
    UITapGestureRecognizer *rotationRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    rotationRecognizer.delegate = self;
    [self addGestureRecognizer:rotationRecognizer];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.delegate = self;

    [self addGestureRecognizer:longPressGestureRecognizer];

    RotationGestureRecognizer *panGestureRecognizer = [[RotationGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handlePanGesture:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
}

//handle Pan
- (void)handlePanGesture:(RotationGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self stopAnimations];
            self.startOffset = self.cellsOffset;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [recognizer locationInView:self];

            double deltaAngle = [recognizer currentAngleInView:self] - [recognizer startAngleInView:self];

            NSUInteger indexPath = [self.grid indexWithPoint:point];
            if (indexPath == 0) {
                return;
            }
            self.cellsOffset = self.startOffset + (CGFloat) (deltaAngle);
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self.rotator decayAnimationWithVelosity:[recognizer angleVelocityInView:self] onCarouselView:self];
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
            CGPoint point = [recognizer locationInView:self];
            NSUInteger index = [self.grid indexForCellWithPoint:point
                                                     withOffset:self.cellsOffset];
            [self.grid.cells[index] longTapStarted];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            CGPoint point = [recognizer locationInView:self];
            NSUInteger index = [self.grid indexForCellWithPoint:point
                                                     withOffset:self.cellsOffset];

            [self.grid.cells[index] longTapEnded];
        }
            break;

        default:
            break;
    }
}

//Handle tap
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    //stop animation
    [self stopAnimations];

    //call delegate to tell him, that view were tapped
    CGPoint point = [recognizer locationInView:self];
    NSUInteger index = [self.grid indexForCellWithPoint:point
                                                 withOffset:self.cellsOffset];
    [self.grid.cells[index] tapped];

//    [self bounceCells];
}

- (void)stopAnimations {
    [self.rotator stopBounceAnimationOnCarouselView:self];
    [self.rotator stopDecayAnimationOnCarouselView:self];
}

-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.grid setFrame:frame];
}

- (void)placeCells {
    [self.rotator rotateCells:self.grid.cells onAngle:self.cellsOffset withGrid:self.grid];
}

- (void)bounceCells {
    CGFloat angle = [Geometry nearestFixedPositionFrom:self.cellsOffset];
    [self.rotator bounceAnimationToAngle:angle onCarouselView:self];
}

- (void)setCellsOffset:(CGFloat)cellsOffset {
    _cellsOffset = cellsOffset;
    if (_cellsOffset > _maxCellsOffset) {
        _cellsOffset -= _maxCellsOffset;
    }
    if (_cellsOffset < 0) {
        _cellsOffset += _maxCellsOffset;
    }
    [self placeCells];
}

-(void) setCells:(NSArray *)cells {
    [self.grid setCells:cells];
    for (Cell *cell in cells) {
        [self addSubview:cell];
    }
    self.cellsOffset = 0.f;
}

- (POPAnimatableProperty *)cellsOffsetAnimatableProperty {
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.artolkov.carousel.cellsOffset"
                                                              initializer:^(POPMutableAnimatableProperty *local_prop) {
                                                                  // read value
                                                                  local_prop.readBlock = ^(id obj, CGFloat values[]) {
                                                                      values[0] = [obj cellsOffset];
                                                                  };
                                                                  // write value
                                                                  local_prop.writeBlock = ^(id obj, const CGFloat values[]) {
                                                                      [obj setCellsOffset:values[0]];
                                                                  };
                                                                  // dynamics threshold
                                                                  local_prop.threshold = 0.01;
                                                              }];

    return prop;
}

#pragma mark - <POPAnimationDelegate>

- (void)pop_animationDidStop:(POPAnimation *)popAnimation finished:(BOOL)finished {
    if ([popAnimation.name isEqualToString:self.rotator.decayAnimationName] && finished) {
        [self bounceCells];
    }
}

@end
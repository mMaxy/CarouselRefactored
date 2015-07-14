//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <pop/POPAnimatableProperty.h>
#import "CarouselView.h"
#import "Rotator.h"
#import "Grid.h"
#import "RotationGestureRecognizer.h"


@interface CarouselView () <UIGestureRecognizerDelegate>
@property(nonatomic) CGFloat startOffset;
@end

@implementation CarouselView

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
    self.grid = [[Grid alloc] init];
    self.rotator = [[Rotator alloc] init];

    [self.grid setFrame:self.frame];

    CGFloat offsetMax = (CGFloat) (M_PI * 2);

    _maxCellsOffset = offsetMax;
    _cellsOffset = 0.f;

    [self setupTouches];
}

- (void)setupTouches {
    RotationGestureRecognizer *rotationRecognizer = [[RotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    rotationRecognizer.delegate = self;
    [self addGestureRecognizer:rotationRecognizer];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.delegate = self;

    [self addGestureRecognizer:longPressGestureRecognizer];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
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
//            [self.delegate carouselView:self
//                 longpressOnCellAtIndex:index];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            CGPoint point = [recognizer locationInView:self];
            NSUInteger index = [self.grid indexForCellWithPoint:point
                                                     withOffset:self.cellsOffset];
//            [self.delegate carouselView:self
//                      liftOnCellAtIndex:index];
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
//    [self.delegate carouselView:self
//               tapOnCellAtIndex:index];

//    [self moveCellsToPlace];
}

- (void)stopAnimations {

}

-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.grid setFrame:frame];
}

- (void)placeCells {
    NSUInteger index = 0;
    for (UIView *cell in self.grid.cells) {
        CGRect frame = [self.grid frameForCellAtIndex:index withOffset:self.cellsOffset];
        [cell setFrame:frame];
        [self addSubview:cell];
        index++;
    }
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
    [self placeCells];
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
        CGFloat angle = [Geometry nearestFixedPositionFrom:self.cellsOffset];
        [self.rotator bounceAnimationToAngle:angle onCarouselView:self];
    }
}

@end
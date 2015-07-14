//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "RotationGestureRecognizer.h"
#import "Geometry.h"


@interface RotationGestureRecognizer ()

@end

@implementation RotationGestureRecognizer {

}
- (CGFloat)startAngleInView:(UIView *)view {
    CGPoint translation = [self translationInView:view];
    CGPoint point = [self locationInView:view];
    CGPoint centerBefore = CGPointMake(point.x - translation.x, point.y - translation.y);
    CGFloat res = [Geometry angleFromPoint:centerBefore onFrame:view.frame];
    return res;
}

- (CGFloat)currentAngleInView:(UIView *)view {
    CGPoint point = [self locationInView:view];
    CGFloat res = [Geometry angleFromPoint:point onFrame:view.frame];;
    return res;
}

- (SpinDirection)directionOfSpinInView:(UIView *) view {
    SpinDirection res = SpinNone;
    CGPoint velocity = [self velocityInView:view];
    CGPoint point = [self locationInView:view];
    CGFloat angle = [Geometry angleFromPoint:point onFrame:view.frame];

    if (angle >= 0.f && angle < M_PI_4) {
        if (velocity.y < 0) {
            res = SpinCounterClockwise;
        } else if (velocity.y > 0) {
            res = SpinClockwise;
        }
    }
    if (angle >= M_PI_4 && angle < 3 * M_PI_4) {
        if (velocity.x < 0) {
            res = SpinCounterClockwise;
        } else if (velocity.x > 0) {
            res = SpinClockwise;
        }
    }
    if (angle >= 3 * M_PI_4 && angle < 5 * M_PI_4) {
        if (velocity.y > 0) {
            res = SpinCounterClockwise;
        } else if (velocity.y < 0) {
            res = SpinClockwise;
        }
    }
    if (angle >= 5 * M_PI_4 && angle < 7 * M_PI_4) {
        if (velocity.x > 0) {
            res = SpinCounterClockwise;
        } else if (velocity.x < 0) {
            res = SpinClockwise;
        }
    }
    if (angle >= 7 * M_PI_4 && angle < 8 * M_PI_4) {
        if (velocity.y < 0) {
            res = SpinCounterClockwise;
        } else if (velocity.y > 0) {
            res = SpinClockwise;
        }
    }

    return res;
}

- (CGFloat)angleVelocityInView:(UIView *)view {
    CGPoint velocity = [self velocityInView:view];

    CGFloat angleVelocity = (CGFloat) sqrtf(velocity.x * velocity.x + velocity.y * velocity.y) / view.frame.size.width / 2;

    SpinDirection direction = [self directionOfSpinInView:view];
    if (direction == SpinClockwise) {
        angleVelocity *= -1;
    }

    return angleVelocity;
}

@end
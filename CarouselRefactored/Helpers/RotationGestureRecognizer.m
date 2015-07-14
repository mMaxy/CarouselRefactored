//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "RotationGestureRecognizer.h"


@interface RotationGestureRecognizer ()

@end

@implementation RotationGestureRecognizer {

}
- (CGFloat)startAngle {
    CGFloat res = 0.f;

    return res;
}

- (CGFloat)currentAngle {
    CGFloat res = 0.f;
    return res;
}

- (SpinDirection)directionOfSpin {
    SpinDirection res = SpinNone;
    return res;
}

- (CGFloat)angleVelocity {
    CGFloat res = 0.f;
    return res;
}

@end
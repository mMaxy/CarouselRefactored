//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "RotationGestureRecognizer.h"


@interface RotationGestureRecognizer ()

@property (assign, nonatomic, readwrite) CGFloat offset;
@property (assign, nonatomic, readwrite) SpinDirection direction;
@property (assign, nonatomic, readwrite) CGFloat angleVelocity;

@end

@implementation RotationGestureRecognizer {

}
- (CGFloat)offset {
    return _offset;
}

- (SpinDirection)direction {
    return _direction;
}

- (CGFloat)angleVelocity {
    return _angleVelocity;
}

@end
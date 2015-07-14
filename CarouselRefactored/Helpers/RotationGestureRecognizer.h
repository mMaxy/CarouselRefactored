//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "POPAnimation.h"
#import "POPAnimatableProperty.h"
#import "POPDecayAnimation.h"
#import "POPSpringAnimation.h"

typedef NS_ENUM(NSInteger, SpinDirection) {
    SpinNone = 0,
    SpinClockwise,
    SpinCounterClockwise
};

@interface RotationGestureRecognizer : UIPanGestureRecognizer

/**
* get angle from pan gesture started
*/
@property (assign, nonatomic, readonly) CGFloat startAngle;
/**
* get angle from current state of pan gesture
*/
@property (assign, nonatomic, readonly) CGFloat currentAngle;
/**
* get direction of spin
*/
@property (assign, nonatomic, readonly) SpinDirection directionOfSpin;
/**
* get angle velocity from linear velocity on pan
*/
@property (assign, nonatomic, readonly) CGFloat angleVelocity;

@end
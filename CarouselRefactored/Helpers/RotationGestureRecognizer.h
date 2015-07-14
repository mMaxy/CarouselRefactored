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
- (CGFloat)startAngleInView:(UIView *)view;

/**
* get angle from current state of pan gesture
*/
- (CGFloat)currentAngleInView:(UIView *)view;

/**
* get direction of spin
*/
- (SpinDirection)directionOfSpinInView:(UIView *) view;

/**
* get angle velocity from linear velocity on pan
*/
- (CGFloat)angleVelocityInView:(UIView *)view;

@end
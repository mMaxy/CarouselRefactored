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
    AVOSpinNone = 0,
    AVOSpinClockwise,
    AVOSpinCounterClockwise
};

@interface RotationGestureRecognizer : UIPanGestureRecognizer

@property (assign, nonatomic) CGFloat startOffset;
@property (assign, nonatomic, readonly) CGFloat offset;
@property (assign, nonatomic, readonly) SpinDirection direction;
@property (assign, nonatomic, readonly) CGFloat angleVelocity;



@end
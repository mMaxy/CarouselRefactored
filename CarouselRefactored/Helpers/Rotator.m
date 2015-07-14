//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <pop/POPDecayAnimation.h>
#import <pop/POPSpringAnimation.h>
#import "Rotator.h"
#import "CarouselView.h"
#import "Cell.h"


@interface Rotator ()

@property (assign, nonatomic, readonly) CGFloat decelerationValue;
@property (assign, nonatomic, readonly) CGFloat velocityOfBounce;

@end

@implementation Rotator

const float kCarouselDecelerationValue = 0.998f;
const float kCarouselBounceVelocityValue = 0.2f;
NSString *const kCarouselViewDecayAnimationName = @"CarouselViewDecay";
NSString *const kCarouselViewBounceAnimationName = @"CarouselViewDecay";


- (void)rotateCells:(NSArray *)cells onAngle:(CGFloat)angle {
    for (Cell *cell in cells) {
        //TODO:
        //rotate cell
    }
}

- (void)decayAnimationWithVelosity:(CGFloat)velocity onCarouselView:(CarouselView *)carouselView{
    CGFloat angleVelocity = velocity;

    POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
    decayAnimation.property = [carouselView cellsOffsetAnimatableProperty];
    decayAnimation.velocity = @(angleVelocity);
    decayAnimation.deceleration = self.decelerationValue;
    decayAnimation.name = self.decayAnimationName;
    decayAnimation.delegate = carouselView;
    [carouselView pop_addAnimation:decayAnimation forKey:@"decelerate"];
}

- (void)bounceAnimationToAngle:(CGFloat)angle onCarouselView:(CarouselView *)carouselView{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [carouselView cellsOffsetAnimatableProperty];
    springAnimation.velocity = @(self.velocityOfBounce);
    springAnimation.toValue = @(angle);
    [carouselView pop_addAnimation:springAnimation forKey:@"bounce"];
}

- (void)stopDecayAnimationOnCarouselView:(CarouselView *)carouselView {
    [self pop_removeAnimationForKey:@"decelerate"];
}

- (void)stopBounceAnimationOnCarouselView:(CarouselView *)carouselView {
    [carouselView pop_removeAnimationForKey:@"bounce"];
}

- (BOOL)isDecayAnimationActiveOnCarouselView:(CarouselView *)carouselView {
    return [carouselView pop_animationForKey:self.decayAnimationName] != nil;
}

- (BOOL)isBounceAnimationActiveOnCarouselView:(CarouselView *)carouselView {
    return [carouselView pop_animationForKey:self.bounceAnimationName] != nil;
}


- (NSString *)decayAnimationName {
    return kCarouselViewDecayAnimationName;
}

- (NSString *)bounceAnimationName {
    return kCarouselViewBounceAnimationName;
}


- (CGFloat)decelerationValue {
    return kCarouselDecelerationValue;
}

- (CGFloat)velocityOfBounce {
    return kCarouselBounceVelocityValue;
}


@end
//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <pop/POPDecayAnimation.h>
#import <pop/POPSpringAnimation.h>
#import "Rotator.h"
#import "Grid.h"
#import "GridHelper.h"


@interface Rotator ()

@property(assign, nonatomic, readonly) CGFloat decelerationValue;
@property(assign, nonatomic, readonly) CGFloat velocityOfBounce;

/**
* returns frame for cell after applying offset
*/
- (CGRect)frameForCellAtIndex:(NSUInteger)index withOffset:(CGFloat)offset withGrid:(GridHelper *)grid;
@end

@implementation Rotator

const float kCarouselDecelerationValue = 0.998f;
const float kCarouselBounceVelocityValue = 0.2f;
NSString *const kCarouselViewDecayAnimationName = @"CarouselViewDecay";
NSString *const kCarouselViewBounceAnimationName = @"CarouselViewDecay";


- (void)rotateCells:(NSArray *)cells onAngle:(CGFloat)angle withGrid:(GridHelper *)grid {
    NSUInteger index = 0;
    for (UIView *cell in cells) {
        CGRect frame = [self frameForCellAtIndex:index withOffset:angle withGrid:grid];
        [cell setFrame:frame];
        index++;
    }
}

- (void)decayAnimationWithVelosity:(CGFloat)velocity onCarouselView:(Grid *)carouselView {
    CGFloat angleVelocity = velocity;

    POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
    decayAnimation.property = [carouselView cellsOffsetAnimatableProperty];
    decayAnimation.velocity = @(angleVelocity);
    decayAnimation.deceleration = self.decelerationValue;
    decayAnimation.name = self.decayAnimationName;
    decayAnimation.delegate = carouselView;
    [carouselView pop_addAnimation:decayAnimation forKey:@"decelerate"];
}

- (void)bounceAnimationToAngle:(CGFloat)angle onCarouselView:(Grid *)carouselView {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [carouselView cellsOffsetAnimatableProperty];
    springAnimation.velocity = @(self.velocityOfBounce);
    springAnimation.toValue = @(angle);
    [carouselView pop_addAnimation:springAnimation forKey:@"bounce"];
}

- (void)stopDecayAnimationOnCarouselView:(Grid *)carouselView {
    [carouselView pop_removeAnimationForKey:@"decelerate"];
}

- (void)stopBounceAnimationOnCarouselView:(Grid *)carouselView {
    [carouselView pop_removeAnimationForKey:@"bounce"];
}

- (BOOL)isDecayAnimationActiveOnCarouselView:(Grid *)carouselView {
    return [carouselView pop_animationForKey:self.decayAnimationName] != nil;
}

- (BOOL)isBounceAnimationActiveOnCarouselView:(Grid *)carouselView {
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

#pragma mark - Private

- (CGRect)frameForCellAtIndex:(NSUInteger)index withOffset:(CGFloat)offset withGrid:(GridHelper *)grid {
    CGRect frame = CGRectZero;

    frame.size = [grid cellSize];
    CGPoint center = [grid centerForIndex:index];
    if (index != 8) {
        [grid moveCenter:&center byAngle:offset];
    }

    frame.origin = CGPointMake(center.x - frame.size.width / 2, center.y - frame.size.height / 2);

    return frame;
}


@end
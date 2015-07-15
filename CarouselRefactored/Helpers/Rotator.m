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

/**
* returns frame for cell after applying offset
*/
- (CGRect)frameForCellAtIndex:(NSUInteger)index withOffset:(CGFloat)offset withGrid:(GridHelper *)grid;
@end

@implementation Rotator

- (void)rotateCells:(NSArray *)cells onAngle:(CGFloat)angle withGrid:(GridHelper *)grid {
    NSUInteger index = 0;
    for (UIView *cell in cells) {
        CGRect frame = [self frameForCellAtIndex:index withOffset:angle withGrid:grid];
        [cell setFrame:frame];
        index++;
    }
}

- (void)decayAnimationWithVelocity:(CGFloat)velocity onCarouselView:(Grid *)carouselView {
    CGFloat angleVelocity = velocity;

    POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
    decayAnimation.property = [self animatableProperty];
    decayAnimation.velocity = @(angleVelocity);
    decayAnimation.deceleration = self.decelerationValue;
    decayAnimation.name = self.decayAnimationName;
    decayAnimation.delegate = carouselView;
    [carouselView pop_addAnimation:decayAnimation forKey:self.decayAnimationName];
}

- (void)bounceAnimationToAngle:(CGFloat)angle onCarouselView:(Grid *)carouselView {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [self animatableProperty];
    springAnimation.velocity = @(self.velocityOfBounce);
    springAnimation.toValue = @(angle);
    [carouselView pop_addAnimation:springAnimation forKey:self.bounceAnimationName];
}

- (void)stopDecayAnimationOnGrid:(Grid *)grid {
    [grid pop_removeAnimationForKey:self.decayAnimationName];
}

- (void)stopBounceAnimationOnGrid:(Grid *)grid {
    [grid pop_removeAnimationForKey:self.bounceAnimationName];
}

- (BOOL)isDecayAnimationActiveOnGrid:(Grid *)grid {
    return [grid pop_animationForKey:self.decayAnimationName] != nil;
}

- (BOOL)isBounceAnimationActiveOnGrid:(Grid *)grid {
    return [grid pop_animationForKey:self.bounceAnimationName] != nil;
}


- (NSString *)decayAnimationName {
    return @"CarouselViewDecay";
}

- (NSString *)bounceAnimationName {
    return @"CarouselViewBounce";
}


- (CGFloat)decelerationValue {
    return 0.998f;
}

- (CGFloat)velocityOfBounce {
    return 0.2f;
}

#pragma mark - Private

- (CGRect)frameForCellAtIndex:(NSUInteger)index withOffset:(CGFloat)offset withGrid:(GridHelper *)grid {
    CGRect frame = CGRectZero;

    frame.size = [grid cellSize];
    CGPoint center = [grid centerOfCellWithIndex:index];
    if (index != 8) {
        [grid moveCellCenter:&center byAngle:offset];
    }

    frame.origin = CGPointMake(center.x - frame.size.width / 2, center.y - frame.size.height / 2);

    return frame;
}

- (POPAnimatableProperty *)animatableProperty {
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

@end
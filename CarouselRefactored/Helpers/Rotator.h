//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class POPDecayAnimation;
@class CarouselView;
@class Grid;

FOUNDATION_EXPORT const float kCarouselDecelerationValue;
FOUNDATION_EXPORT const float kCarouselBounceVelocityValue;
FOUNDATION_EXPORT NSString *const kCarouselViewDecayAnimationName;
FOUNDATION_EXPORT NSString *const kCarouselViewBounceAnimationName;

/**
 Вращатель - вращать ячейки, на входе подается массив ячеек
_ответсвенность:_
- Рассчитать скорость, угасание и прочее
- Изменить нужным целам их позиции
- Запустить анимацию вращения
- Хранить признак анимация идет или нет (для отсечения срабатывания лонгтапа и тапа во время вращения)
*/
@interface Rotator : NSObject

/**
* rotating cells. For each cell recalculates frame and setting that frame to cell
*  @param cells Array of cells to spin
*  @param angle angle from initial position
*  @grid grid Grid to use
*/
- (void)rotateCells:(NSArray *)cells onAngle:(CGFloat)angle withGrid:(Grid *) grid;

/**
* animate inertial spinning on view
* @param velocity Initial angle velocity, with which animation will start
* @param carouselView View to animate
*/
-(void) decayAnimationWithVelosity:(CGFloat) velocity onCarouselView:(CarouselView *)carouselView;

/**
* decay animation name
*/
-(NSString *) decayAnimationName;

/**
* bounce animation name
*/
-(NSString *) bounceAnimationName;

/**
* animate bounce on view
* @param angle Angle to which bounce should be performed
* @param carouselView View to animate
*/
-(void) bounceAnimationToAngle:(CGFloat) angle onCarouselView:(CarouselView *)carouselView;

/**
* stopping decay animation
* @param carouselView Carousel view on which animation should be stopped
*/
-(void) stopDecayAnimationOnCarouselView:(CarouselView *)carouselView;

/**
* stopping bounce animation
* @param carouselView Carousel view on which animation should be stopped
*/
-(void) stopBounceAnimationOnCarouselView:(CarouselView *)carouselView;

/**
* check is decay animation active on carousel view
*/
-(BOOL) isDecayAnimationActiveOnCarouselView:(CarouselView *)carouselView;

/**
* check is bounce animation active on carousel view
*/
-(BOOL) isBounceAnimationActiveOnCarouselView:(CarouselView *)carouselView;

@end
//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class POPDecayAnimation;

/**
 Вращатель - вращать ячейки, на входе подается массив ячеек
_ответсвенность:_
- Рассчитать скорость, угасание и прочее
- Изменить нужным целам их позиции
- Запустить анимацию вращения
- Хранить признак анимация идет или нет (для отсечения срабатывания лонгтапа и тапа во время вращения)
*/
@interface Rotator : NSObject

-(void) rotateCells:(NSArray *)cells onAngle:(CGFloat) angle;
-(POPDecayAnimation *) decayAnimationWithVelosity:(CGFloat) velocity;
-(POPDecayAnimation *) bounceAnimationToAngle:(CGFloat) angle;

- (POPAnimatableProperty *)cellsOffsetAnimatableProperty;

@end
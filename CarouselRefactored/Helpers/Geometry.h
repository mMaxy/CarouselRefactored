//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
* Геометрия - расчет секторов, позиций, скоростей и прочего ответсвенность:
- Рассчитывать сложные математические расчеты основанные на геометрии (например синусУгла или угловаяСкорость)
*/
@interface Geometry : NSObject

+ (CGPoint)calculateRotatedPointFromPoint:(CGPoint)from byAngle:(double)angle inFrame:(CGRect)frame;

+ (CGFloat)calculateAngleFromPoint:(CGPoint)point onFrame:(CGRect)frame;

+ (CGPoint)calculatePointForAngle:(double)angle onFrame:(CGRect)frame;

//+ (AVOSpinDirection)spinDirectionForVector:(CGPoint)vector fromPoint:(CGPoint)point onFrame:(CGRect)frame;

+ (NSUInteger)quarterForPoint:(CGPoint)point inFrame:(CGRect)frame;

+ (NSUInteger)quarterOfAngle:(double)angle inFrame:(CGRect)frame;

@end
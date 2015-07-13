//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
- 1. Грид - сетка из 9 фреймов, 0 - центральный фрейм, и 8 тех что двигаются, ответсвенность:
- рассчитать сетку (массив фреймов корректных позиций)
- заполнить массив ячейками
- послать лонгтап и тап нужной ячейке
- определьть корректные позиции ячеек (из массива просто вернуть фрейм)
*/
@interface Grid : NSObject

@property (strong, nonatomic) NSArray *cells;
@property (assign, nonatomic) CGRect *frame;

-(void) setFrameToFit:(CGRect)rect;

-(void) longTapHeppendOnPoint:(CGPoint)point;
-(void) tapHeppendOnPoint:(CGPoint)point;
-(CGRect) frameForCellAtIndex:(NSUInteger)index;

@end
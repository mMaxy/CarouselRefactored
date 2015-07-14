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

/**
* cells to place (count of cells must be 9)
*/
@property (strong, nonatomic) NSArray *cells;

/**
* frame on which cells must be placed
*/
@property (assign, nonatomic) CGRect *frame;

-(void) setFrameToFit:(CGRect)rect;

/**
* Receive point on which long tap happened, sending it to cell. Point must be sent as if there were no offset
*/
-(void) longTapHeppendOnPoint:(CGPoint)point;

/**
* Receive point on which tap happened, sending it to cell. Point must be sent as if there were no offset
*/
-(void) tapHeppendOnPoint:(CGPoint)point;

/**
* calculating default position for cell at index
*/
-(CGRect) frameForCellAtIndex:(NSUInteger)index;

@end
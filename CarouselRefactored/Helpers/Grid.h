//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
* struct to pass borders on grid
*/
struct Borders {
    CGFloat xLeftCellLeftBorder;
    CGFloat xLeftCellRightBorder;
    CGFloat xCenterCellLeftBorder;
    CGFloat xCenterCellRightBorder;
    CGFloat xRightCellLeftBorder;
    CGFloat xRightCellRightBorder;

    CGFloat yTopCellTopBorder;
    CGFloat yTopCellBotBorder;
    CGFloat yCenterCellTopBorder;
    CGFloat yCenterCellBotBorder;
    CGFloat yBotCellTopBorder;
    CGFloat yBotCellBotBorder;
};

/**
- 1. Грид - сетка из 9 фреймов, 0 - центральный фрейм, и 8 тех что двигаются, ответсвенность:
- рассчитать сетку (массив фреймов корректных позиций)
- заполнить массив ячейками
- послать лонгтап и тап нужной ячейке
- определьть корректные позиции ячеек (из массива просто вернуть фрейм)
*/
@interface Grid : NSObject

/**
* size of a cell
*/
@property(assign, nonatomic, readonly) CGSize cellSize;

/**
* space between cells
*/
@property(assign, nonatomic) CGFloat spaceBetweenCells;

/**
* space between top border of frame and top cell
* equals to space between bottom border of frame and bottom cell
*/
@property(assign, nonatomic, readonly) CGFloat verticalInset;

/**
* space between left border of frame and left cell
* equals to space between right border of frame and right cell
*/
@property(assign, nonatomic, readonly) CGFloat horizontalInset;

/**
* borders of cell (see struct for info)
*/
@property(assign, nonatomic, readonly) struct Borders cellBorders;

/**
* cells to place (count of cells must be 9)
*/
@property (strong, nonatomic) NSArray *cells;

/**
* frame on which cells must be placed
*/
@property (assign, nonatomic) CGRect frame;

- (instancetype)initWithFrame:(CGRect)rect;

-(void)setFrame:(CGRect)rect;

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
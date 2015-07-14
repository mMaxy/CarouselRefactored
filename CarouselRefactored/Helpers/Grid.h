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
* frame to place cells
*/
@property (assign, nonatomic) CGRect frame;

/**
* init method
*/
- (instancetype)initWithFrame:(CGRect)rect;

/**
* frame on which cells must be placed
*/
-(void)setFrame:(CGRect)rect;

/**
* calculating default position for cell at index
*/
-(CGRect) frameForCellAtIndex:(NSUInteger)index;

/**
* center of cell in index
*/
- (CGPoint)centerForIndex:(NSUInteger)index;

/**
* moving center
*/
- (void)moveCenter:(CGPoint *)center byAngle:(double)angle;

/**
* index for cell, containing point, after applying offset
*/
- (NSUInteger)indexForCellWithPoint:(CGPoint)point withOffset:(CGFloat)offset;

/**
* index for cell, containing point, with zero offset
*/
- (NSUInteger)indexWithPoint:(CGPoint)point;

@end
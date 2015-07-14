//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "Grid.h"


@interface Grid ()
- (void)actualSetCellSize:(CGSize)size andVerticalInset:(CGFloat)vi andHorizontalInset:(CGFloat)hi;

- (void)countCellSizeAndInsets;
@end

@implementation Grid

- (instancetype)initWithFrame:(CGRect)rect {
    if (self = [super init]) {
        [self setFrame:rect];
        [self setSpaceBetweenCells:5.f];
    }
    return self;
}

- (void)setFrame:(CGRect)rect {
    _frame = rect;
    [self countCellSizeAndInsets];
}

- (void)longTapHeppendOnPoint:(CGPoint)point {

}

- (void)tapHeppendOnPoint:(CGPoint)point {

}

- (CGRect)frameForCellAtIndex:(NSUInteger)index {
    CGRect result;



    return result;
}

- (struct Borders)cellBorders {
    struct Borders res;

    res.xLeftCellLeftBorder = self.horizontalInset;
    res.xLeftCellRightBorder = res.xLeftCellLeftBorder + self.cellSize.width;
    res.xCenterCellLeftBorder = res.xLeftCellRightBorder + self.spaceBetweenCells;
    res.xCenterCellRightBorder = res.xCenterCellLeftBorder + self.cellSize.width;
    res.xRightCellLeftBorder = res.xCenterCellRightBorder + self.spaceBetweenCells;
    res.xRightCellRightBorder = res.xRightCellLeftBorder + self.cellSize.width;

    res.yTopCellTopBorder = self.verticalInset;
    res.yTopCellBotBorder = res.yTopCellTopBorder + self.cellSize.height;
    res.yCenterCellTopBorder = res.yTopCellBotBorder + self.spaceBetweenCells;
    res.yCenterCellBotBorder = res.yCenterCellTopBorder + self.cellSize.height;
    res.yBotCellTopBorder = res.yCenterCellBotBorder + self.spaceBetweenCells;
    res.yBotCellBotBorder = res.yBotCellTopBorder + self.cellSize.height;

    return res;
}

#pragma mark - Private

- (void)actualSetCellSize:(CGSize)size andVerticalInset:(CGFloat)vi andHorizontalInset:(CGFloat)hi {
    _cellSize = size;
    _verticalInset = vi;
    _horizontalInset = hi;
}

- (void)countCellSizeAndInsets {
    CGFloat screenWidth = CGRectGetWidth(self.frame);
    CGFloat screenHeight = CGRectGetHeight(self.frame);

    CGFloat lineSpace = self.spaceBetweenCells;
    CGFloat rowSpace = self.spaceBetweenCells;
    CGFloat horizontalSpace = rowSpace * 4;
    CGFloat verticalSpace = lineSpace * 4;

    CGFloat possibleWidth;
    CGFloat possibleHeight;
    CGFloat totalHeight;
    CGFloat totalWidth;

    CGFloat hi = 0.f;
    CGFloat vi = 0.f;
    CGSize size = CGSizeZero;

    if (!(screenHeight == 0.f || screenWidth == 0.f)) {
        if (screenWidth > screenHeight) {
            // Calculate width and height if additional space on left and right
            possibleHeight = (screenHeight - verticalSpace) / 3;
            possibleWidth = possibleHeight * 3 / 4;
            totalWidth = possibleWidth * 3 + horizontalSpace;

            vi = rowSpace;
            hi = (screenWidth + 2 * lineSpace - totalWidth) / 2;
            size = CGSizeMake(possibleWidth, possibleHeight);
        } else {
            // Calculate width and height if additional space on top and bottom
            possibleWidth = (screenWidth - horizontalSpace) / 3;
            possibleHeight = possibleWidth * 4 / 3;
            totalHeight = possibleHeight * 3 + verticalSpace;

            hi = lineSpace;
            vi = (screenHeight + 2 * rowSpace - totalHeight) / 2;
            size = CGSizeMake(possibleWidth, possibleHeight);
        }
    }

    [self actualSetCellSize:size andVerticalInset:vi andHorizontalInset:hi];
}



@end
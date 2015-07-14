//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "GridHelper.h"
#import "Geometry.h"


@interface GridHelper ()

@property(assign, nonatomic, readonly) CGRect rails;
@property(assign, nonatomic, readonly) CGFloat railsHeightToWidthRelation;
@property (strong, nonatomic) NSArray *cellFrames;

- (void)countCellSizeAndInsets;

@end

@implementation GridHelper

- (void)setFrame:(CGRect)rect {
    _frame = rect;
    _spaceBetweenCells = 5.f;
    [self countCellSizeAndInsets];

    [self calculateCellsFrames];

    CGFloat railYMin = [self centerForIndex:2].y;
    CGFloat railYMax = [self centerForIndex:4].y;
    CGFloat railXMin = [self centerForIndex:0].x;
    CGFloat railXMax = [self centerForIndex:2].x;
    _rails = CGRectMake(railXMin, railXMin, railXMax - railXMin, railXMax - railXMin);
    _railsHeightToWidthRelation = (railYMax - railYMin) / (railXMax - railXMin);
}

- (void)calculateCellsFrames {
    CGFloat x = self.horizontalInset;
    CGFloat y = self.verticalInset;
    NSMutableArray *cellsFrames = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        if (i == 1 || i == 2) {
            x += self.cellSize.width + self.spaceBetweenCells;
        } else if (i == 3 || i == 4) {
            y += self.cellSize.height + self.spaceBetweenCells;
        } else if (i == 5 || i == 6) {
            x -= self.cellSize.width + self.spaceBetweenCells;
        } else if (i == 7) {
            y -= self.cellSize.height + self.spaceBetweenCells;
        } else if (i == 8) {
            x += self.cellSize.width + self.spaceBetweenCells;
        }
        CGRect frame = CGRectMake(x, y, self.cellSize.width, self.cellSize.height);
        [cellsFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    self.cellFrames = [cellsFrames copy];
}

#pragma mark - Private

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

    _cellSize = size;
    _verticalInset = vi;
    _horizontalInset = hi;
}

- (CGPoint)centerForIndex:(NSUInteger)index {
    CGPoint result = CGPointZero;

    result.x = [self.cellFrames[index] CGRectValue].origin.x + self.cellSize.width/2;
    result.y = [self.cellFrames[index] CGRectValue].origin.y + self.cellSize.height/2;

    return result;
}

- (void)moveCenter:(CGPoint *)center byAngle:(double)angle {
        CGPoint p = (*center);
        double remain = angle;

        CGRect f = self.rails;

        p.x = p.x - self.horizontalInset - self.cellSize.width / 2;
        p.y = p.y - self.verticalInset - self.cellSize.height / 2;
        p.y *= 1 / self.railsHeightToWidthRelation;

        CGPoint rotated = [Geometry rotatedPointFromPoint:p byAngle:remain inFrame:f];

        rotated.y *= self.railsHeightToWidthRelation;
        rotated.x = rotated.x + self.horizontalInset + self.cellSize.width / 2;
        rotated.y = rotated.y + self.verticalInset + self.cellSize.height / 2;

        (*center) = CGPointMake(rotated.x, rotated.y);
}

- (NSUInteger)indexForCellWithPoint:(CGPoint)point withOffset:(CGFloat)offset {
    NSUInteger index = 0;

    CGPoint p = [Geometry rotatedPointFromPoint:point byAngle:(-offset) inFrame:self.frame];

    index = [self indexWithPoint:p];
    return index;
}

- (NSUInteger)indexWithPoint:(CGPoint)point {
    NSUInteger res = NAN;

    NSArray *results = @[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8)];

    NSUInteger index = 0;
    for (NSValue *boxedRect in self.cellFrames) {
        CGRect rect = [boxedRect CGRectValue];
        if (point.x > rect.origin.x && point.x < rect.origin.x + rect.size.width) {
            if (point.y > rect.origin.y && point.y < rect.origin.y + rect.size.height) {
                res = [results[index] unsignedIntegerValue];
                return res;
            }
        }
        index++;
    }
    return res;
}

@end
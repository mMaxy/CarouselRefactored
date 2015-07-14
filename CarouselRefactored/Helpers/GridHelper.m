//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "GridHelper.h"
#import "Geometry.h"


@interface GridHelper ()

@property(assign, nonatomic, readonly) CGRect rails;
@property(assign, nonatomic, readonly) CGFloat railsHeightToWidthRatio;
@property(strong, nonatomic) NSArray *cellFrames;

@end

@implementation GridHelper

- (void)setFrame:(CGRect)rect {
    _frame = rect;
    _spaceBetweenCells = 5.f;
    [self setCellSize];
    [self setVerticalInset];
    [self setHorizontalInset];

    [self layoutCells];

    [self setRails];
    [self setRailsHeightToWidthRatio];
}

- (void)layoutCells {
    CGFloat x = self.horizontalInset;
    CGFloat y = self.verticalInset;
    NSMutableArray *cellsFrames = [NSMutableArray new];
    for (int yIndex = 0; yIndex < 3; yIndex++) {
        for (int xIndex = 0; xIndex < 3; xIndex++) {
            CGFloat newX = x + xIndex*(self.cellSize.width + self.spaceBetweenCells);
            CGFloat newY = y + yIndex*(self.cellSize.height + self.spaceBetweenCells);
            CGRect frame = CGRectMake(newX, newY, self.cellSize.width, self.cellSize.height);
            [cellsFrames addObject:[NSValue valueWithCGRect:frame]];
        }
    }
    NSMutableArray *res = [cellsFrames mutableCopy];
    NSArray *transform;
    transform = [self cellMatrix];
    for (int index = 0; index < 9; index++) {
        res[index] = cellsFrames[[transform[index] unsignedIntegerValue]];
    }
    self.cellFrames = [res copy];
}

#pragma mark - Private

- (NSArray *)cellMatrix {
    NSArray *transform;
    transform = @[@(0), @(1), @(2), @(5), @(8), @(7), @(6), @(3), @(4)];
    return transform;
}

- (void)setCellSize {
    CGFloat screenWidth = CGRectGetWidth(self.frame);
    CGFloat screenHeight = CGRectGetHeight(self.frame);

    CGFloat lineSpace = self.spaceBetweenCells;
    CGFloat rowSpace = self.spaceBetweenCells;
    CGFloat horizontalSpace = rowSpace * 4;
    CGFloat verticalSpace = lineSpace * 4;

    CGFloat width;
    CGFloat height;
    CGSize size = CGSizeZero;

    if (!(screenHeight == 0.f || screenWidth == 0.f)) {
        if (screenWidth > screenHeight) {
            // Calculate width and height if additional space on left and right
            height = (screenHeight - verticalSpace) / 3;
            width = height * 3 / 4;

            size = CGSizeMake(width, height);
        } else {
            // Calculate width and height if additional space on top and bottom
            width = (screenWidth - horizontalSpace) / 3;
            height = width * 4 / 3;

            size = CGSizeMake(width, height);
        }
    }
    _cellSize = size;
}

- (void)setHorizontalInset {
    _horizontalInset = (self.frame.size.width - 3*self.cellSize.width - 2*self.spaceBetweenCells)/2;
}

- (void)setVerticalInset {
    _verticalInset = (self.frame.size.height - 3*self.cellSize.height - 2*self.spaceBetweenCells)/2;
}

-(void) setRails {
    CGFloat railXMin = [self centerOfCellWithIndex:0].x;
    CGFloat railXMax = [self centerOfCellWithIndex:2].x;
    _rails = CGRectMake(railXMin, railXMin, railXMax - railXMin, railXMax - railXMin);
}

-(void)setRailsHeightToWidthRatio {
    CGFloat railYMin = [self centerOfCellWithIndex:2].y;
    CGFloat railYMax = [self centerOfCellWithIndex:4].y;
    CGFloat railXMin = [self centerOfCellWithIndex:0].x;
    CGFloat railXMax = [self centerOfCellWithIndex:2].x;
    _railsHeightToWidthRatio = (railYMax - railYMin) / (railXMax - railXMin);
}

- (CGPoint)centerOfCellWithIndex:(NSUInteger)index {
    CGPoint result = CGPointZero;

    result.x = [self.cellFrames[index] CGRectValue].origin.x + self.cellSize.width / 2;
    result.y = [self.cellFrames[index] CGRectValue].origin.y + self.cellSize.height / 2;

    return result;
}

- (void)moveCellCenter:(CGPoint *)center byAngle:(double)angle {
    CGPoint p = (*center);
    double remain = angle;

    CGRect f = self.rails;

    p.x = p.x - self.horizontalInset - self.cellSize.width / 2;
    p.y = p.y - self.verticalInset - self.cellSize.height / 2;
    p.y *= 1 / self.railsHeightToWidthRatio;

    CGPoint rotated = [Geometry rotatedPointFromPoint:p byAngle:remain onFrame:f];

    rotated.y *= self.railsHeightToWidthRatio;
    rotated.x = rotated.x + self.horizontalInset + self.cellSize.width / 2;
    rotated.y = rotated.y + self.verticalInset + self.cellSize.height / 2;

    (*center) = CGPointMake(rotated.x, rotated.y);
}

- (NSUInteger)indexForCellWithPoint:(CGPoint)point withOffset:(CGFloat)offset {
    NSUInteger index = 0;

    CGPoint pointWithoutOffset = [Geometry rotatedPointFromPoint:point byAngle:(-offset) onFrame:self.frame];

    index = [self indexWithPoint:pointWithoutOffset];
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
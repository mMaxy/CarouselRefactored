//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "Grid.h"
#import "Geometry.h"


@interface Grid ()

@property(strong, nonatomic, readonly) NSArray *possibleOutcomes;

@property(assign, nonatomic, readonly) CGRect rails;
@property(assign, nonatomic, readonly) CGFloat railsHeightToWidthRelation;

- (void)actualSetCellSize:(CGSize)size andVerticalInset:(CGFloat)vi andHorizontalInset:(CGFloat)hi;

- (void)countCellSizeAndInsets;

- (NSArray *)findSectorHitWithPoint:(CGPoint)point borders:(struct Borders)borders;

- (NSUInteger)calculateIndexForArray:(NSArray *)result;

- (NSUInteger)findIndexForPoint:(CGPoint)point inGrid:(struct Borders)grid;

@end

@implementation Grid

@synthesize possibleOutcomes = _possibleOutcomes;

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

    CGFloat railYMin = [self centerForIndex:2].y;
    CGFloat railYMax = [self centerForIndex:4].y;
    CGFloat railXMin = [self centerForIndex:0].x;
    CGFloat railXMax = [self centerForIndex:2].x;
    _rails = CGRectMake(railXMin, railXMin, railXMax - railXMin, railXMax - railXMin);
    _railsHeightToWidthRelation = (railYMax - railYMin) / (railXMax - railXMin);
}

- (CGRect)frameForCellAtIndex:(NSUInteger)index {
    CGRect result;

    result.size = self.cellSize;
    CGPoint center = [self centerForIndex:index];
    result.origin = CGPointMake(center.x - result.size.width / 2, center.y - result.size.height / 2);

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

- (void)setCells:(NSArray *)cells {
    _cells = cells;
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

- (CGPoint)centerForIndex:(NSUInteger)index {
    CGPoint result;

    CGFloat leftColumn = self.cellSize.width * 1 / 2 + self.horizontalInset;
    CGFloat centerColumn = self.cellSize.width * 3 / 2 + self.horizontalInset + self.spaceBetweenCells;
    CGFloat rightColumn = self.cellSize.width * 5 / 2 + self.horizontalInset + self.spaceBetweenCells * 2;

    CGFloat topRow = self.cellSize.height * 1 / 2 + self.verticalInset;
    CGFloat centerRow = self.cellSize.height * 3 / 2 + self.verticalInset + self.spaceBetweenCells;
    CGFloat botRow = self.cellSize.height * 5 / 2 + self.verticalInset + self.spaceBetweenCells * 2;

    CGFloat x = 0.f;
    CGFloat y = 0.f;

    if ([@[@(0), @(6), @(7)] containsObject:@(index)]) {
        x = leftColumn;
    } else if ([@[@(1), @(5), @(8)] containsObject:@(index)]) {
        x = centerColumn;
    } else if ([@[@(2), @(3), @(4)] containsObject:@(index)]) {
        x = rightColumn;
    }

    if ([@[@(0), @(1), @(2)] containsObject:@(index)]) {
        y = topRow;
    } else if ([@[@(7), @(8), @(3)] containsObject:@(index)]) {
        y = centerRow;
    } else if ([@[@(6), @(5), @(4)] containsObject:@(index)]) {
        y = botRow;
    }

    result = CGPointMake(x, y);

    return result;
}

- (CGRect)frameForCellAtIndex:(NSUInteger)index withOffset:(CGFloat)offset {
    CGRect frame = CGRectZero;

    frame.size = [self cellSize];
    CGPoint center = [self centerForIndex:index];
    if (index != 8) {
        [self moveCenter:&center byAngle:offset];
    }

    frame.origin = CGPointMake(center.x - frame.size.width / 2, center.y - frame.size.height / 2);

    return frame;
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
    NSUInteger index = [self indexWithPoint:point];
    if (index != 8) {
        point = [self centerForIndex:index];

        [self moveCenter:&point byAngle:-offset];
    }
    index = [self indexWithPoint:point];
    return index;
}

- (NSUInteger)indexWithPoint:(CGPoint)point {
    NSUInteger res = 0;

    struct Borders frames = self.cellBorders;
    res = [self findIndexForPoint:point inGrid:frames];

    return res;
}

#pragma mark Private methods

- (NSArray *)possibleOutcomes {
    if (!_possibleOutcomes) {
        _possibleOutcomes = @[
                @[@(1), @(2), @(3)],
                @[@(8), @(0), @(4)],
                @[@(7), @(6), @(5)]
        ];
    }

    return _possibleOutcomes;
}

- (NSArray *)findSectorHitWithPoint:(CGPoint)point borders:(struct Borders)borders {
    BOOL pointInLeftColumn = point.x >= borders.xLeftCellLeftBorder && point.x <= borders.xLeftCellRightBorder;
    BOOL pointInCenterColumn = point.x >= borders.xCenterCellLeftBorder && point.x <= borders.xCenterCellRightBorder;
    BOOL pointInRightColumn = point.x >= borders.xRightCellLeftBorder && point.x <= borders.xRightCellRightBorder;

    BOOL pointInTopRow = point.y >= borders.yTopCellTopBorder && point.y <= borders.yTopCellBotBorder;
    BOOL pointInCenterRow = point.y >= borders.yCenterCellTopBorder && point.y <= borders.yCenterCellBotBorder;
    BOOL pointInBotRow = point.y >= borders.yBotCellTopBorder && point.y <= borders.yBotCellBotBorder;

    NSArray *result = @[
            @[
                    @(pointInTopRow && pointInLeftColumn),
                    @(pointInTopRow && pointInCenterColumn),
                    @(pointInTopRow && pointInRightColumn)
            ],
            @[
                    @(pointInCenterRow && pointInLeftColumn),
                    @(pointInCenterRow && pointInCenterColumn),
                    @(pointInCenterRow && pointInRightColumn)
            ],
            @[
                    @(pointInBotRow && pointInLeftColumn),
                    @(pointInBotRow && pointInCenterColumn),
                    @(pointInBotRow && pointInRightColumn)
            ]
    ];
    return result;
}

- (NSUInteger)calculateIndexForArray:(NSArray *)result {
    NSUInteger res = 0;
    for (NSUInteger i = 0; i < [[self possibleOutcomes] count]; i++) {
        for (NSUInteger y = 0; y < [[self possibleOutcomes][i] count]; y++) {
            if ([result[i][y] boolValue]) {
                res = [[self possibleOutcomes][i][y] unsignedIntegerValue];
            }
        }
    }
    return res;
}

- (NSUInteger)findIndexForPoint:(CGPoint)point inGrid:(struct Borders)grid {
    NSUInteger res = 0;
    NSArray *result = [self findSectorHitWithPoint:point borders:grid];
    res = [self calculateIndexForArray:result];
    return res;
}


@end
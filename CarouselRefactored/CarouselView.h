//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/POPAnimation.h>


@class Rotator;
@class Grid;
@class RotationGestureRecognizer;
@class POPAnimatableProperty;


@interface CarouselView : UIView <POPAnimationDelegate>

@property (strong, nonatomic) Rotator *rotator;
@property (strong, nonatomic) Grid *grid;

/**
* Angle, with current offset from initial position
*/
@property (assign, nonatomic) CGFloat cellsOffset;

/**
* Maximum offset value
*/
@property (assign, nonatomic) CGFloat maxCellsOffset;

/**
* animatable property
*/
- (POPAnimatableProperty *)cellsOffsetAnimatableProperty;

/**
* Set cells to be shown on view
*/
-(void) setCells:(NSArray *)cells;

@end
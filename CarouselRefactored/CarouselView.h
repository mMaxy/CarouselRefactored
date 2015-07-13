//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rotator;
@class Grid;
@class RotationGestureRecognizer;


@interface CarouselView : NSObject

@property (strong, nonatomic) Rotator *rotator;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) RotationGestureRecognizer *rotationRecognizer;

@end
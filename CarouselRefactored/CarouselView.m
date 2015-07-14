//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import <pop/POPAnimatableProperty.h>
#import "CarouselView.h"
#import "Rotator.h"
#import "Grid.h"
#import "RotationGestureRecognizer.h"


@implementation CarouselView

-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.grid setFrame:frame];
}

-(void) setCells:(NSArray *)cells {
    [self.grid setCells:cells];
}

- (POPAnimatableProperty *)cellsOffsetAnimatableProperty {
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.artolkov.carousel.cellsOffset"
                                                              initializer:^(POPMutableAnimatableProperty *local_prop) {
                                                                  // read value
                                                                  local_prop.readBlock = ^(id obj, CGFloat values[]) {
                                                                      values[0] = [obj cellsOffset];
                                                                  };
                                                                  // write value
                                                                  local_prop.writeBlock = ^(id obj, const CGFloat values[]) {
                                                                      [obj setCellsOffset:values[0]];
                                                                  };
                                                                  // dynamics threshold
                                                                  local_prop.threshold = 0.01;
                                                              }];

    return prop;
}

#pragma mark - <POPAnimationDelegate>

- (void)pop_animationDidStop:(POPAnimation *)popAnimation finished:(BOOL)finished {
    if ([popAnimation.name isEqualToString:self.rotator.decayAnimationName] && finished) {
//        get nearest fixed angle for cells
//        start bounce animation to that angle
    }
}

@end
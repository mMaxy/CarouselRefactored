//
// Created by Artem Olkov on 13/07/15.
// Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "Cell.h"


@implementation Cell {

}
- (void)tapped {
    NSLog(@"Tapped, %i", self.tag);
}

- (void)longTapStarted {
    NSLog(@"Long Tap Started");
}

- (void)longTapEnded {
    NSLog(@"Long Tap Ended");
}

@end
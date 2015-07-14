//
//  ViewController.m
//  CarouselRefactored
//
//  Created by Artem Olkov on 13/07/15.
//  Copyright (c) 2015 Artem Olkov. All rights reserved.
//

#import "ViewController.h"
#import "Grid.h"
#import "Cell.h"

@interface ViewController ()
@property (strong, nonatomic) Grid *carousel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.carousel = [[Grid alloc] initWithFrame:self.view.frame];
    NSMutableArray *cells = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        Cell *cell = [[Cell alloc] init];
        if (i == 8) {
            [cell setBackgroundColor:[UIColor blueColor]];
        } else {
            [cell setBackgroundColor:[UIColor redColor]];
        }
        [cells addObject:cell];
    }
    [self.carousel setCells:cells];
    [self.view addSubview:self.carousel];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

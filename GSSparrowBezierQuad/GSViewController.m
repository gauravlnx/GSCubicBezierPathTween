//
//  GSViewController.m
//  GSSparrowBezierQuad
//
//  Created by Gaurav on 10/3/13.
//  Copyright (c) 2013 Gaurav. All rights reserved.
//

#import "GSViewController.h"
#import "Sparrow.h"
#import "Game.h"

@interface GSViewController ()

@end

@implementation GSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    SPViewController *spVC = [[SPViewController alloc] init];
    spVC.view.frame = self.view.bounds;
    
    [spVC startWithRoot:[Game class] supportHighResolutions:YES];
    [spVC setShowStats:YES];
    SPRootCreatedBlock block = ^(id root){
        [root performSelector:@selector(setup)];
    };
    [spVC setOnRootCreated:block];
    
    [self addChildViewController:spVC];
    [spVC didMoveToParentViewController:self];
    [self.view addSubview:spVC.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

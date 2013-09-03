//
//  IntroController.m
//  RiskMap
//
//  Created by Steven on 13-9-4.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroController.h"

@interface IntroController ()

@end

@implementation IntroController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) gotoFilePageButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoFilePage] ;
}

@end

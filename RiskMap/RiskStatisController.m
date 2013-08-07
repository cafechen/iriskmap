//
//  RiskStatisController.m
//  RiskMap
//
//  Created by steven on 7/18/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "DBUtils.h"
#import "AppDelegate.h"
#import "RiskStatisController.h"
#import "Risk.h"

@interface RiskStatisController ()

@end

@implementation RiskStatisController

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    self.riskArray = [DBUtils getRisk:appDelegate.currProjectMap] ;
    self.riskTitleArray = [DBUtils getRiskType:appDelegate.currProjectMap] ;
    self.maxHeight = 0 ;
    self.maxWidth = 0 ;
    for(int i = 0; i < self.riskTitleArray.count; i++){
        Risk *risk1 = [self.riskTitleArray objectAtIndex:i] ;
        risk1.statis = 0 ;
        for(int j = 0; j < self.riskArray.count; j++){
            Risk *risk2 = [self.riskArray objectAtIndex:j] ;
            if([risk2.riskTypeId isEqualToString:risk1.riskTypeId]){
                risk1.statis++ ;
            }
        }
        if(self.maxHeight < risk1.statis){
            self.maxHeight = risk1.statis ;
        }
        if(risk1.statis > 0){
            self.maxWidth++ ;
        }
    }
    
    //绘制矩阵
    //计算矩阵的宽度
    int cellw = (ScreenWidth - 40)/self.maxWidth ;
    int cellh = (ScreenHeight - 60 - 44)/self.maxHeight ;
    
    int index = 0 ;
    for(int i = 0; i < self.riskTitleArray.count; i++){
        Risk *risk = [self.riskTitleArray objectAtIndex:i] ;
        if(risk.statis == 0){
            continue ;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSLog(@"WIDTH [%f] HEIGHT [%f]", ScreenWidth, ScreenHeight) ;
        button.frame = CGRectMake(20 + cellw*index + cellw/4, ScreenHeight - 20 - 20, cellw/2, -cellh*risk.statis) ;
        [button setBackgroundColor:[UIColor blueColor]] ;
        [button setEnabled:NO] ;
        [self.view addSubview:button] ;
        //加上UILabel
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 + cellw*index + cellw/4, ScreenHeight - 20, cellw/2, -20)] ;
        label.text = risk.riskTitle ;
        [self.view addSubview:label] ;
        label.textAlignment = UITextAlignmentCenter;
        if(isIpad){
            [label setFont:[UIFont fontWithName:@"Arial" size:14]] ;
        }else{
            [label setFont:[UIFont fontWithName:@"Arial" size:8]] ;
        }
        [label setNumberOfLines:0];  
        index++ ;
    }
    
    //绘制纵坐标
    for(int i = 0; i < self.maxHeight; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, ScreenHeight - 50 - (i + 1)*cellh, 20, 20)] ;
        label.text = [NSString stringWithFormat:@"%d", i + 1] ;
        [label setBackgroundColor:[UIColor clearColor]] ;
        [self.view addSubview:label] ;
        [label setFont:[UIFont fontWithName:@"Arial" size:8]] ;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) gotoLastPageButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoLastPage] ;
}

@end

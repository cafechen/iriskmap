//
//  RiskSortController.m
//  RiskMap
//
//  Created by steven on 7/18/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "Define.h"
#import "AppDelegate.h"
#import "RiskSortController.h"
#import "DBUtils.h"
#import "Matrix.h"
#import "VectorDetail.h"
#import "Score.h"
#import "Risk.h"

@interface RiskSortController ()

@end

@implementation RiskSortController

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    self.currMatrix = appDelegate.currMatrix;
    self.isManage = appDelegate.isManage;
    self.matrixArray = [DBUtils getProjectMatrix:appDelegate.currProjectMap] ;
    self.matrixTitleArray = [DBUtils getProjectMatrixTitle:appDelegate.currProjectMap] ;
    self.riskArray = [DBUtils getRisk:appDelegate.currProjectMap] ;
    [self showSortMap] ;
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

- (void)showSortMap
{
    NSString *title = [self.matrixTitleArray objectAtIndex:self.currMatrix] ;
    NSLog(@"################ %@", title) ;
    //开始绘制点
    Matrix *matrix = [self.matrixArray objectAtIndex:0] ;
    NSMutableArray *xArray = [DBUtils getRiskScore:matrix.matrix_x] ;
    NSMutableArray *yArray = [DBUtils getRiskScore:matrix.matrix_y] ;
    
    //首先计算button的高度
    int height = self.heightImageView.frame.size.height/(xArray.count + 1) ;
    
    NSLog(@"#### heigth %d", height) ;
    
    double score = 0.0 ;
    for(int i = 0; i < xArray.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.frame = CGRectMake(20 + cellw*index + cellw/4, ScreenHeight - 20 - 20, cellw/2, -cellh*risk.statis) ;
        [button setBackgroundColor:[UIColor greenColor]] ;
        [button setEnabled:NO] ;
        
        Score *xScore = [xArray objectAtIndex:i] ;
        Score *yScore = [yArray objectAtIndex:i] ;
        
        int left = 41 ;
        if(isIpad){
            left = 61 ;
        }
        
        int top = 64 ;
        if(isIpad){
            top = 84 ;
        }
        
        if(self.isManage){
            for(int i = 0; i < self.riskArray.count; i++){
                Risk *risk = [self.riskArray objectAtIndex:i] ;
                if([risk.riskId isEqualToString:xScore.riskid]){
                    score = xScore.scoreEnd*yScore.scoreEnd ;
                    NSLog(@"#### score %d", i) ;
                    button.frame = CGRectMake(left, top + (i)*height + height/2, self.widthImageView.frame.size.width*score, height/2) ;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width + 5, button.frame.origin.y, self.widthImageView.frame.size.width - button.frame.size.width, height/2)] ;
                    label.text = [NSString stringWithFormat:@"%@ %@", risk.riskCode, risk.riskTitle] ;
                    [self.view addSubview:label] ;
                    label.textAlignment = UITextAlignmentLeft;
                    if(isIpad){
                        [label setFont:[UIFont fontWithName:@"Arial" size:14]] ;
                    }else{
                        [label setFont:[UIFont fontWithName:@"Arial" size:8]] ;
                    }
                    [self.view addSubview:label] ;
                }
            }
        }else{
            for(int i = 0; i < self.riskArray.count; i++){
                Risk *risk = [self.riskArray objectAtIndex:i] ;
                if([risk.riskId isEqualToString:xScore.riskid]){
                    score = xScore.scoreBefore*yScore.scoreBefore ;
                    NSLog(@"#### score %d", i) ;
                    score = xScore.scoreEnd*yScore.scoreEnd ;
                    button.frame = CGRectMake(left, top + (i)*height + height/2, self.widthImageView.frame.size.width*score, height/2) ;
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width + 5, button.frame.origin.y, self.widthImageView.frame.size.width - button.frame.size.width, height/2)] ;
                    label.text = [NSString stringWithFormat:@"%@ %@", risk.riskCode, risk.riskTitle] ;
                    [self.view addSubview:label] ;
                    label.textAlignment = UITextAlignmentLeft;
                    if(isIpad){
                        [label setFont:[UIFont fontWithName:@"Arial" size:14]] ;
                    }else{
                        [label setFont:[UIFont fontWithName:@"Arial" size:8]] ;
                    }
                    [self.view addSubview:label] ;
                }
            }
        }
        NSLog(@"#### [%f][%f][%f][%f]", button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height) ;
        [self.view addSubview:button] ;
    }
}


@end

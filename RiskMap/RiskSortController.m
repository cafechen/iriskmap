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

int IPHONE_HEIGHT = 25 ;
int IPAD_HEIGHT = 50 ;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
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
    Matrix *matrix = [self.matrixArray objectAtIndex:self.currMatrix] ;
    NSMutableArray *xArray = [DBUtils getRiskScore:matrix.matrix_x] ;
    NSMutableArray *yArray = [DBUtils getRiskScore:matrix.matrix_y] ;
    
    //首先计算button的高度
    //float height = self.heightImageView.frame.size.height/(xArray.count) ;
    float height = IPHONE_HEIGHT ;
    if(isIpad){
        height = IPAD_HEIGHT ;
    }
    
    //设置heightImageView高度
    self.heightImageView.frame = CGRectMake(self.heightImageView.frame.origin.x, self.heightImageView.frame.origin.y, self.heightImageView.frame.size.width, xArray.count*height) ;
    
    float screenHeight = self.heightImageView.frame.size.height + 64 + 20 ;
    if(isIpad){
        screenHeight = screenHeight + 20 ;
    }
    if(screenHeight > ScreenHeight){
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, screenHeight) ;
    }
    
    NSLog(@"#### heigth %f %d %d", height, xArray.count, yArray.count) ;
    
    double score = 0.0 ;
    
    int left = 151 ;
    if(isIpad){
        left = 201 ;
    }
    
    int top = 20 ;
    if(isIpad){
        top = 40 ;
    }
    
    float buttonheight = height/2 ;
    if(buttonheight > 40){
        buttonheight = 40 ;
    }
    
    NSMutableArray *buttons = [[[NSMutableArray alloc] init] autorelease] ;
    
    NSMutableArray *labels = [[[NSMutableArray alloc] init] autorelease] ;
    
    for(int i = 0; i < xArray.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.frame = CGRectMake(20 + cellw*index + cellw/4, ScreenHeight - 20 - 20, cellw/2, -cellh*risk.statis) ;
        [button setBackgroundColor:[UIColor greenColor]] ;
        [button setEnabled:NO] ;
        
        Score *xScore = [xArray objectAtIndex:i] ;
        Score *yScore = [yArray objectAtIndex:i] ;
        
        if(self.isManage){
            for(int j = 0; j < self.riskArray.count; j++){
                Risk *risk = [self.riskArray objectAtIndex:j] ;
                if([risk.riskId isEqualToString:xScore.riskid]){
                    score = xScore.scoreEnd*yScore.scoreEnd ;
                    NSLog(@"#### score %f %d %d", score, i , j) ;
                    button.frame = CGRectMake(left, top + (i)*height + height/2 - buttonheight/2, self.widthImageView.frame.size.width*score, buttonheight) ;
                    [labels addObject:[NSString stringWithFormat:@"%.3f %@ %@", score, risk.riskCode, risk.riskTitle]] ;
                }
            }
        }else{
            for(int j = 0; j < self.riskArray.count; j++){
                Risk *risk = [self.riskArray objectAtIndex:j] ;
                if([risk.riskId isEqualToString:xScore.riskid]){
                    score = xScore.scoreBefore*yScore.scoreBefore ;
                    NSLog(@"#### score %f %d %d", score, i, j) ;
                    button.frame = CGRectMake(left, top + (i)*height + height/2 - buttonheight/2, self.widthImageView.frame.size.width*score, buttonheight) ;
                    [labels addObject:[NSString stringWithFormat:@"%.3f %@ %@", score, risk.riskCode, risk.riskTitle]] ;
                }
            }
        }
        
        NSLog(@"#### [%f][%f][%f][%f]", button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height) ;
        button.tag = 100 + i ;
        [buttons addObject:button] ;
    }
    
    for(int i = 0; i < buttons.count; i++){
        UIButton *b = (UIButton *)[buttons objectAtIndex:i] ;
        NSLog(@"#### a [%f][%f][%f][%f]", b.frame.origin.x, b.frame.origin.y, b.frame.size.width, b.frame.size.height) ;
        //[self.view addSubview:b] ;
    }
    
    for(int i = 0; i < buttons.count; i++){
        UIButton *b1 = (UIButton *)[buttons objectAtIndex:i] ;
        for(int j = i; j < buttons.count; j++){
            UIButton *b2 = (UIButton *)[buttons objectAtIndex:j] ;
            if(b2.frame.size.width > b1.frame.size.width){
                //对调
                CGRect temp = b2.frame ;
                b2.frame = b1.frame ;
                b1.frame = temp ;
            }
        }
    }
    
    [labels sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for(int i = 0; i < buttons.count; i++){
        UIButton *b = (UIButton *)[buttons objectAtIndex:i] ;
        b.frame = CGRectMake(left, top + (i)*height + height/2 - buttonheight/2, b.frame.size.width, b.frame.size.height) ;
        NSLog(@"#### b [%f][%f][%f][%f]", b.frame.origin.x, b.frame.origin.y, b.frame.size.width, b.frame.size.height) ;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(b.frame.origin.x + b.frame.size.width + 5, b.frame.origin.y, self.widthImageView.frame.size.width - b.frame.size.width, buttonheight)] ;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, b.frame.origin.y, left - 5, buttonheight)] ;
        title = [labels objectAtIndex:(buttons.count - i - 1)] ;
        label1.text = [title substringToIndex:5];
        label1.textAlignment = UITextAlignmentLeft;
        label2.text = [title substringFromIndex:5];
        label2.textAlignment = UITextAlignmentRight;
        if(isIpad){
            [label1 setFont:[UIFont fontWithName:@"Arial" size:12]] ;
            [label2 setFont:[UIFont fontWithName:@"Arial" size:12]] ;
        }else{
            [label1 setFont:[UIFont fontWithName:@"Arial" size:8]] ;
            [label2 setFont:[UIFont fontWithName:@"Arial" size:8]] ;
        }
        [self.scrollView addSubview:label1] ;
        [self.scrollView addSubview:label2] ;
        [self.scrollView addSubview:b] ;
    }
}


@end

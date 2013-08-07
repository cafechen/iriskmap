//
//  RiskHotController.m
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "AppDelegate.h"
#import "RiskHotController.h"
#import "DBUtils.h"
#import "Matrix.h"
#import "VectorDetail.h"
#import "Score.h"

#define MAX_SIZE 40

@interface RiskHotController ()

@end

@implementation RiskHotController

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
    self.matrixArray = [DBUtils getProjectMatrix:appDelegate.currProjectMap] ;
    self.matrixTitleArray = [DBUtils getProjectMatrixTitle:appDelegate.currProjectMap] ;
    self.currMatrix = 0 ;
    self.isManage = NO ;
    [self showMatrixMap] ;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMatrixMap
{
    
    //清空
    NSArray *subViews = [self.scrollView subviews] ;
    for(int i = 0; i < subViews.count; i++){
        UIView *view = [subViews objectAtIndex:i] ;
        [view removeFromSuperview] ;
    }
    
    NSString *title = [self.matrixTitleArray objectAtIndex:self.currMatrix] ;
    self.maxX = 0 ;
    self.maxY = 0 ;
    
    for(int i = 0; i < self.matrixArray.count; i++){
        Matrix *matrix = [self.matrixArray objectAtIndex:i] ;
        if([title isEqualToString:matrix.matrix_title]){
            if(self.maxX < [matrix.xIndex intValue]){
                self.maxX = [matrix.xIndex intValue] ;
            }
            if(self.maxY < [matrix.yIndex intValue]){
                self.maxY = [matrix.yIndex intValue] ;
            }
        }
    }
    
    self.maxX++ ;
    self.maxY++ ;
    
    //绘制矩阵 先计算矩阵的大小
    self.mSize = 280/self.maxY ;
    if(self.mSize > MAX_SIZE){
        self.mSize = MAX_SIZE ;
    }
    
    //开始绘制矩形
    for(int i = 0; i < self.matrixArray.count; i++){
        Matrix *matrix = [self.matrixArray objectAtIndex:i] ;
        if([title isEqualToString:matrix.matrix_title]){
            int xIndex = [matrix.xIndex intValue] ;
            int yIndex = [matrix.yIndex intValue] ;
            int x = 50 + self.mSize*xIndex + xIndex;
            int y = (ScreenHeight - 135)/2.0 + self.mSize*self.maxY/2.0 - yIndex*self.mSize - yIndex - self.mSize;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, y, self.mSize, self.mSize) ;
            [button setEnabled:NO] ;
            //NSLog(@"#### %@", matrix.levelType) ;
            if(matrix.Color == -65536){
                [button setBackgroundColor:[UIColor greenColor]] ;
            }else if(matrix.Color == -256){
                [button setBackgroundColor:[UIColor yellowColor]] ;
            }else if(matrix.Color == -16744448){
                [button setBackgroundColor:[UIColor redColor]] ;
            }else {
                [button setBackgroundColor:[UIColor grayColor]] ;
            }
            //[button setTitle:matrix.levelType forState:UIControlStateNormal] ;
            [self.scrollView addSubview:button] ;
            
            if(xIndex == 0){
                //最左边的矩阵
                NSMutableArray *yVector = [DBUtils getProjectVectorDetail:matrix.matrix_y] ;
                VectorDetail *yv = [yVector objectAtIndex:yIndex] ;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y + self.mSize/2 - 10, 40, 20)];
                [label setText:yv.score] ;
                [label setFont:[UIFont fontWithName:@"Arial" size:10]] ;
                label.textAlignment = UITextAlignmentLeft ;
                [label setBackgroundColor:[UIColor clearColor]] ;
                [self.scrollView addSubview:label] ;
            }
            if(yIndex == 0){
                //最下边的矩阵
                NSMutableArray *xVector = [DBUtils getProjectVectorDetail:matrix.matrix_x] ;
                VectorDetail *xv = [xVector objectAtIndex:xIndex] ;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y + self.mSize + 5, self.mSize, 20)];
                [label setText:xv.score] ;
                [label setFont:[UIFont fontWithName:@"Arial" size:10]] ;
                label.textAlignment = UITextAlignmentCenter;
                [label setBackgroundColor:[UIColor clearColor]] ;
                [self.scrollView addSubview:label] ;
            }
        }
    }
    
    //开始绘制点
    Matrix *matrix = [self.matrixArray objectAtIndex:0] ;
    NSMutableArray *xArray = [DBUtils getRiskScore:matrix.matrix_x] ;
    NSLog(@"#### [%d][%@]", xArray.count, matrix.matrix_x) ;
    NSMutableArray *yArray = [DBUtils getRiskScore:matrix.matrix_y] ;
    NSLog(@"#### [%d][%@]", yArray.count, matrix.matrix_y) ;
    for(int i = 0; i < xArray.count; i++){
        Score *xScore = [xArray objectAtIndex:i] ;
        Score *yScore = [yArray objectAtIndex:i] ;
        double x = 0 ;
        double y = 0 ;
        if(self.isManage){
            x = 50 + self.maxX*self.mSize*xScore.scoreEnd ;
            y = (ScreenHeight - 135)/2.0 + self.mSize*self.maxY/2.0 - self.maxY*self.mSize*yScore.scoreEnd ;
        }else{
            x = self.maxX*self.mSize*xScore.scoreBefore ;
            y = (ScreenHeight - 135)/2.0 + self.mSize*self.maxY/2.0 - self.maxY*self.mSize*yScore.scoreBefore ;
        }
        //绘制Y
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x - 5, y - 5, 10, 10) ;
        [button setBackgroundColor:[UIColor whiteColor]] ;
        [button setEnabled:NO] ;
        [self.scrollView addSubview:button] ;
    }
}

- (IBAction) gotoLastPageButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoLastPage] ;
}

- (IBAction) switchButtonAction:(id)sender
{
    self.isManage = !self.isManage ;
    if(self.isManage){
        [self.switchButton setTitle:@"管理后" forState:UIControlStateNormal] ;
    }else{
        [self.switchButton setTitle:@"管理前" forState:UIControlStateNormal] ;
    }
}

- (IBAction) selectHotButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"风险矩阵列表"
                                  delegate:self
                                  cancelButtonTitle:@"返回"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    actionSheet.delegate = self ;
    for(int i = 0; i < self.matrixTitleArray.count; i++){
        [actionSheet addButtonWithTitle:[self.matrixTitleArray objectAtIndex:i]] ;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //actionSheet.cancelButtonIndex = actionSheet.numberOfButtons;
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"#### actionSheet") ;
    NSLog(@"#### actionSheet [%d]", buttonIndex) ;
    if(buttonIndex < self.matrixTitleArray.count){
        self.currMatrix = buttonIndex ;
        [self showMatrixMap] ;
    }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    NSLog(@"#### actionSheetCancel") ;
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"#### didDismissWithButtonIndex") ;
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"#### willDismissWithButtonIndex") ;
}

@end

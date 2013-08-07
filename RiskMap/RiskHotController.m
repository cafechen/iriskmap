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

int MAX_SIZE = 40 ;

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
    if(isIpad){
        MAX_SIZE = 100 ;
    }
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
    
    NSLog(@"################ %@", title) ;
    
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
    if(isIpad){
        self.mSize = 600/self.maxY ;
    }else{
        self.mSize = 280/self.maxY ;
    }
    if(self.mSize > MAX_SIZE){
        self.mSize = MAX_SIZE ;
    }
    
    //开始绘制矩形
    for(int i = 0; i < self.matrixArray.count; i++){
        Matrix *matrix = [self.matrixArray objectAtIndex:i] ;
        if([title isEqualToString:matrix.matrix_title]){
            int xIndex = [matrix.xIndex intValue] ;
            int yIndex = [matrix.yIndex intValue] ;
            yIndex = self.maxY - yIndex  - 1;
            int x = 50 + self.mSize*xIndex + xIndex;
            int y = (ScreenHeight - 135)/2.0 + self.mSize*self.maxY/2.0 - yIndex*self.mSize - yIndex - self.mSize;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, y, self.mSize, self.mSize) ;
            [button setEnabled:NO] ;
            //NSLog(@"#### %@", matrix.levelType) ;
            if(matrix.Color == -65536){
                [button setBackgroundColor:[UIColor redColor]] ;
            }else if(matrix.Color == -256){
                [button setBackgroundColor:[UIColor yellowColor]] ;
            }else if(matrix.Color == -16744448){
                [button setBackgroundColor:[UIColor greenColor]] ;
            }else {
                [button setBackgroundColor:[UIColor grayColor]] ;
            }
            //[button setTitle:matrix.levelType forState:UIControlStateNormal] ;
            [self.scrollView addSubview:button] ;
            
            if(xIndex == 0){
                //最左边的矩阵
                NSMutableArray *yVector = [DBUtils getProjectVectorDetail:matrix.matrix_y] ;
                VectorDetail *yv = [yVector objectAtIndex:yIndex] ;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y + self.mSize/2 - 20, 40, 40)];
                label.numberOfLines = 2;
                label.textAlignment = UITextAlignmentCenter;
                [label setText:[NSString stringWithFormat:@"%@\n%@", yv.score, yv.levelTitle]] ;
                [label setFont:[UIFont fontWithName:@"Arial" size:10]] ;
                [label setBackgroundColor:[UIColor clearColor]] ;
                [self.scrollView addSubview:label] ;
            }
            if(yIndex == 0){
                //最下边的矩阵
                NSMutableArray *xVector = [DBUtils getProjectVectorDetail:matrix.matrix_x] ;
                VectorDetail *xv = [xVector objectAtIndex:xIndex] ;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y + self.mSize + 5 - 10, self.mSize, 40)];
                label.numberOfLines = 2;
                label.textAlignment = UITextAlignmentCenter;
                [label setText:[NSString stringWithFormat:@"%@\n%@", xv.score, xv.levelTitle]] ;
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
            //遍历找该属于的点
            NSMutableArray *xVector = [DBUtils getProjectVectorDetail:matrix.matrix_x] ;
            NSMutableArray *yVector = [DBUtils getProjectVectorDetail:matrix.matrix_y] ;
            for(int i = 0; i < xVector.count; i++){
                VectorDetail *xv = [xVector objectAtIndex:i] ;
                NSArray *scores = [xv.score componentsSeparatedByString:@"-"] ;
                double begin = [[scores objectAtIndex:0] doubleValue] ;
                double end = [[scores objectAtIndex:1] doubleValue] ;
                if(xScore.scoreEnd < end && xScore.scoreEnd >= begin){
                    x = 50 + self.mSize*([xv.sort intValue] - 1) + [xv.sort intValue] - 1 + self.mSize*((xScore.scoreEnd - begin)/(end - begin));
                    NSLog(@"####SCORE x [%d][%d][%f]", [xv.sort intValue], self.mSize, (xScore.scoreEnd - begin)/(end - begin)) ;
                    NSLog(@"####SCORE x [%f][%f][%f][%@][%f]", xScore.scoreEnd, begin, end, xv.sort, x) ;
                }
            }
            for(int i = 0; i < yVector.count; i++){
                VectorDetail *yv = [yVector objectAtIndex:i] ;
                NSArray *scores = [yv.score componentsSeparatedByString:@"-"] ;
                double begin = [[scores objectAtIndex:0] doubleValue] ;
                double end = [[scores objectAtIndex:1] doubleValue] ;
                if(yScore.scoreEnd < end && yScore.scoreEnd >= begin){
                    y = (ScreenHeight - 135)/2.0 + self.mSize*self.maxY/2.0 - (self.mSize*([yv.sort intValue] - 1) + [yv.sort intValue] - 1 + self.mSize*((yScore.scoreEnd - begin)/(end - begin))) ;
                    NSLog(@"####SCORE y [%d][%d][%f]", [yv.sort intValue], self.mSize, (yScore.scoreEnd - begin)/(end - begin)) ;
                    NSLog(@"####SCORE y [%f][%f][%f][%@][%f]", yScore.scoreEnd, begin, end, yv.sort, y) ;
                }
            }
        }else{
            //遍历找该属于的点
            NSMutableArray *xVector = [DBUtils getProjectVectorDetail:matrix.matrix_x] ;
            NSMutableArray *yVector = [DBUtils getProjectVectorDetail:matrix.matrix_y] ;
            for(int i = 0; i < xVector.count; i++){
                VectorDetail *xv = [xVector objectAtIndex:i] ;
                NSArray *scores = [xv.score componentsSeparatedByString:@"-"] ;
                double begin = [[scores objectAtIndex:0] doubleValue] ;
                double end = [[scores objectAtIndex:1] doubleValue] ;
                if(xScore.scoreBefore < end && xScore.scoreBefore >= begin){
                    x = 50 + self.mSize*([xv.sort intValue] - 1) + [xv.sort intValue] - 1 + self.mSize*((xScore.scoreBefore - begin)/(end - begin));
                    NSLog(@"####SCORE x [%d][%d][%f]", [xv.sort intValue], self.mSize, (xScore.scoreBefore - begin)/(end - begin)) ;
                    NSLog(@"####SCORE x [%f][%f][%f][%@][%f]", xScore.scoreBefore, begin, end, xv.sort, x) ;
                }
            }
            for(int i = 0; i < yVector.count; i++){
                VectorDetail *yv = [yVector objectAtIndex:i] ;
                NSArray *scores = [yv.score componentsSeparatedByString:@"-"] ;
                double begin = [[scores objectAtIndex:0] doubleValue] ;
                double end = [[scores objectAtIndex:1] doubleValue] ;
                if(yScore.scoreBefore < end && yScore.scoreBefore >= begin){
                    y = (ScreenHeight - 135)/2.0 + self.mSize*self.maxY/2.0 - (self.mSize*([yv.sort intValue] - 1) + [yv.sort intValue] - 1 + self.mSize*((yScore.scoreBefore - begin)/(end - begin))) ;
                    NSLog(@"####SCORE y [%d][%d][%f]", [yv.sort intValue], self.mSize, (yScore.scoreBefore - begin)/(end - begin)) ;
                    NSLog(@"####SCORE y [%f][%f][%f][%@][%f]", yScore.scoreBefore, begin, end, yv.sort, y) ;
                }
            }
        }
        //绘制Y
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x - 5, y - 5, 10, 10) ;
        [button setBackgroundImage:[UIImage imageNamed:@"redball.png"] forState:UIControlStateNormal] ;
        [button setEnabled:NO] ;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal] ;
        [self.scrollView addSubview:button] ;
    }
}

- (IBAction) gotoLastPageButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoLastPage] ;
}

- (IBAction) gotoRiskSortButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    appDelegate.currMatrix = self.currMatrix ;
    appDelegate.isManage = self.isManage ;
    [appDelegate gotoRiskSortPage] ;
}

- (IBAction) switchButtonAction:(id)sender
{
    self.isManage = !self.isManage ;
    if(self.isManage){
        [self.switchButton setTitle:@"管理后" forState:UIControlStateNormal] ;
    }else{
        [self.switchButton setTitle:@"管理前" forState:UIControlStateNormal] ;
    }
    [self showMatrixMap] ;
}

- (IBAction) selectHotButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"风险矩阵列表"
                                  delegate:self
                                  cancelButtonTitle:nil
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

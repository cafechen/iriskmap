//
//  MapController.m
//  RiskMap
//
//  Created by Steven on 13-6-26.
//  Copyright (c) 2013年 laka. All rights reserved.
//
#import "Define.h"
#import "AppDelegate.h"
#import "MapController.h"
#import "ASDepthModalViewController.h"
#import "DBUtils.h"
#import "ProjectMap.h"
#import "MyLongPressGestureRecognizer.h"

@interface MapController ()

@end

@implementation MapController

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
    //NSLog(@"######## %@", appDelegate.currProjectMap) ;
    self.objectArray = [DBUtils getProjectMap:appDelegate.currProjectMap] ;
    //绘制地图
    if(isIpad){
        self.mSize = 25 ;
    }else{
        self.mSize = 15 ;
    }
    [self initMap] ;
    // Do any additional setup after loading the view from its nib.
}

- (void) initMap
{
    self.imageView.hidden = YES ;
    self.scrollView.hidden = NO ;
    self.maxX = 0 ;
    self.maxY = 0 ;
    //先绘制线
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            //是线
            UIImage *image1 = [UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.picEmz]] ;
            UIImage *image2 = [self whiteToTranparent:image1] ;
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:image2] autorelease] ;
            imageView.frame = CGRectMake(pm.positionX*self.mSize - pm.width*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - pm.height*self.mSize/2, pm.width*self.mSize, pm.height*self.mSize) ;
            if(self.maxX < imageView.frame.origin.x + imageView.frame.size.width){
                self.maxX = imageView.frame.origin.x + imageView.frame.size.width ;
            }
            if(self.maxY < imageView.frame.origin.y + imageView.frame.size.height){
                self.maxY = imageView.frame.origin.y + imageView.frame.size.height ;
            }
            [self.mapView addSubview:imageView] ;
        }
        if([@"目标" isEqualToString:pm.Obj_maptype]){
            self.target = i ;
        }
    }
    //后绘制风险
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline == NO){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(pm.positionX*self.mSize - pm.width*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - pm.height*self.mSize/2, pm.width*self.mSize, pm.height*self.mSize) ;
            UIImage *image1 = [UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.picEmz]] ;
            UIImage *image2 = [self whiteToTranparent:image1] ;
            [button setBackgroundImage:image2 forState:UIControlStateNormal] ;
            //button.backgroundColor = [UIColor redColor] ;
            
            //添加长按事件
            if(![@"" isEqualToString:pm.linkPics]){
                MyLongPressGestureRecognizer *gr =  [[MyLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:) context:pm.linkPics];
                [button addGestureRecognizer:gr];
                button.tag = 3 ;
                gr.context = [pm.linkPics copy] ;
                [gr release];
            }
            
            if(self.maxX < button.frame.origin.x + button.frame.size.width){
                self.maxX = button.frame.origin.x + button.frame.size.width ;
            }
            if(self.maxY < button.frame.origin.y + button.frame.size.height){
                self.maxY = button.frame.origin.y + button.frame.size.height ;
            }
            
            //添加风险卡片
            if(pm.cardPic != nil && ![@"" isEqualToString:pm.cardPic]){
                NSLog(@"添加风险卡片 %@", pm.cardPic) ;
                [button addTarget:self action:@selector(showCardPic:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i ;
            }else{
                if(i != self.target){
                    NSLog(@"添加风险卡片 %@", pm.cardPic) ;
                    [button addTarget:self action:@selector(showMapPic:) forControlEvents:UIControlEventTouchUpInside];
                }
                button.tag = i ;
            }
            
            [self.mapView addSubview:button] ;
        }
    }
    
    int width = ScreenWidth ;
    
    if(self.maxX > width){
        width = self.maxX + 20;
    }
    
    int height = ScreenHeight - 44 ;
    
    if(self.maxY > height){
        height = self.maxY + 20;
    }
    
    self.scrollView.contentSize = CGSizeMake(width, height) ;
    self.mapView.frame = CGRectMake(0, 0, width, height) ;
}

- (void)handleLongPress:(MyLongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.currLinked = [gestureRecognizer.context componentsSeparatedByString:@"|"] ;
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[self.currLinked objectAtIndex:0], nil];
        for(int i = 1; i < self.currLinked.count; i++){
            [alert addButtonWithTitle:[self.currLinked objectAtIndex:i]] ;
        }
        [alert show];
    }
}

- (void)showCardPic:(id)sender
{
    ProjectMap *pm = [self.objectArray objectAtIndex:[sender tag]] ;
    NSLog(@"showCardPic [%d][%@]", [sender tag], pm.cardPic) ;
    [self.imageView setImage:[UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.cardPic]]] ;
    self.scrollView.hidden = YES ;
    self.imageView.hidden = NO ;
    
}

- (void)showMapPic:(id)sender
{
    ProjectMap *pm = [self.objectArray objectAtIndex:[sender tag]] ;
    NSLog(@"showMapPic [%d][%@]", [sender tag], pm.projectId) ;
    //删除所有的线
    NSArray *views = [self.mapView subviews] ;
    for(int i = 0; i < views.count; i++){
        UIView *v = (UIView *)[views objectAtIndex:i] ;
        if([v isKindOfClass:[UIImageView class]]){
            [v removeFromSuperview] ;
        }
    }
    
    pm.isShow = !pm.isShow ;
    
    //将所有的线重置
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            pm.willShow = NO ;
        }
    }
    
    [self findLine] ;
}

- (void) findLine
{
    //首先计算哪些线需要显示
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isShow){
            [self markLine:pm] ;
        }
    }
}

- (void) markLine:(ProjectMap *)thePM
{
    ProjectMap *targetPM = [self.objectArray objectAtIndex:self.target];
    NSLog(@"targetPM[%@]", targetPM.objectId) ;
    //先找离这个pm最近的两条线
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            if([thePM.objectId isEqualToString:pm.fromWho]){
                pm.willShow = YES ;
                NSLog(@"--------------after [%@]", pm.projectId) ;
                [self markAfterLine:pm] ;
            }
            if([thePM.objectId isEqualToString:pm.toWho]){
                pm.willShow = YES ;
                NSLog(@"--------------before [%@]", pm.projectId) ;
                [self markBeforeLine:pm] ;
            }
        }
    }
    [self drawLine];
}

- (void) markBeforeLine:(ProjectMap *)thePM
{
    NSString *beforeObjectId = [thePM.fromWho copy];
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            if([beforeObjectId isEqualToString:pm.toWho]){
                pm.willShow = YES ;
                NSLog(@"--------------before22 [%@]", pm.fromWho) ;
                for(int j = 0; j < self.objectArray.count; j++){
                    ProjectMap *pm2 = [self.objectArray objectAtIndex:j];
                    if([pm.fromWho isEqualToString:pm2.toWho]){
                        pm2.willShow = YES ;
                        [self markBeforeLine:pm2] ;
                    }
                }
            }
        }
    };
}

- (void) markAfterLine:(ProjectMap *)thePM
{
    ProjectMap *targetPM = [self.objectArray objectAtIndex:self.target];
    NSString *afterObjectId = [thePM.toWho copy];
    NSLog(@"markAfterLine [%@][%@]", afterObjectId, targetPM.objectId) ;
    if([afterObjectId isEqualToString:targetPM.objectId]){
        NSLog(@"--------------RETUEN") ;
        return ;
    }
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            if([afterObjectId isEqualToString:pm.fromWho]){
                pm.willShow = YES ;
                NSLog(@"--------------after22 [%@]", pm.toWho) ;
                for(int j = 0; j < self.objectArray.count; j++){
                    ProjectMap *pm2 = [self.objectArray objectAtIndex:j];
                    if([pm.toWho isEqualToString:pm2.fromWho]){
                        pm2.willShow = YES ;
                        [self markAfterLine:pm2] ;
                    }
                }
            }
        }
    };
}

- (void) drawLine
{
    //绘制线
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline && pm.willShow){
            //是线
            UIImage *image1 = [UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.picEmz]] ;
            UIImage *image2 = [self whiteToTranparent:image1] ;
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:image2] autorelease] ;
            imageView.frame = CGRectMake(pm.positionX*self.mSize - pm.width*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - pm.height*self.mSize/2, pm.width*self.mSize, pm.height*self.mSize) ;
            [self.mapView insertSubview:imageView atIndex:0] ;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > 0){
        NSString *linkedPage = [self.currLinked objectAtIndex:(buttonIndex - 1)] ;
        NSLog(@"alertView %@", linkedPage) ;
        [self.imageView setImage:[UIImage imageWithContentsOfFile:[DBUtils findFilePath:linkedPage]]] ;
        self.scrollView.hidden = YES ;
        self.imageView.hidden = NO ;
        //self.imageView.contentMode= UIViewContentModeScaleAspectFit ;
    }
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

- (IBAction)draw01:(id)sender
{
    //删除所有的对象
    NSArray *views = [self.mapView subviews] ;
    for(int i = 0; i < views.count; i++){
        UIView *v = (UIView *)[views objectAtIndex:i] ;
        [v removeFromSuperview] ;
    }
    
    //将所有的线重置
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            pm.willShow = NO ;
        }else{
            pm.isShow = NO ;
        }
    }
    
    [self initMap] ;
    [self closeToolViewAction:nil];
}

- (IBAction)draw02:(id)sender
{
    [self closeToolViewAction:nil];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskHotPage] ;
}

- (IBAction)gotoRiskSort:(id)sender
{
    [self closeToolViewAction:nil];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskSortPage] ;
}

- (IBAction)gotoRiskStatis:(id)sender
{
    [self closeToolViewAction:nil];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskStatisPage] ;
}

- (IBAction)gotoRiskList:(id)sender
{
    [self closeToolViewAction:nil];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskListPage] ;
}

- (IBAction)gotoRiskCost:(id)sender
{
    [self closeToolViewAction:nil];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskCostPage] ;
}

- (IBAction)showToolViewAction:(id)sender
{
    [ASDepthModalViewController presentView:self.toolView withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationGrow];
}

- (IBAction)closeToolViewAction:(id)sender
{
    [ASDepthModalViewController dismiss];
}

- (UIImage *)whiteToTranparent:(UIImage *)viewImage
{
    //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 1.0);
    //[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef rawImageRef = viewImage.CGImage;
    const float colorMasking[6] = {255, 255, 255, 255, 255, 255};
    UIGraphicsBeginImageContext(viewImage.size);
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, viewImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, viewImage.size.width, viewImage.size.height), maskedImageRef);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return newImage ;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapView;
}

@end

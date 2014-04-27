//
//  MapController.m
//  RiskMap
//
//  Created by Steven on 13-6-26.
//  Copyright (c) 2013年 laka. All rights reserved.
//
#import "Define.h"
#import "Project.h"
#import "AppDelegate.h"
#import "MapController.h"
#import "ASDepthModalViewController.h"
#import "DBUtils.h"
#import "Layer.h"
#import "ProjectMap.h"
#import "MyLongPressGestureRecognizer.h"
#import "DrawLine.h"
#import "RiskRelation.h"

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    //NSLog(@"######## %@", appDelegate.currProjectMap) ;
    self.objectArray = [DBUtils getProjectMap:appDelegate.currProjectMap] ;
    //绘制地图
    if(isIpad){
        self.mSize = 25 ;
    }else{
        self.mSize = 15 ;
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self initLayers] ;
    [self initTools] ;
    [self initMap] ;
    //DrawLine *lineView = [[DrawLine alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    //[self.view addSubview:lineView];
    // Do any additional setup after loading the view from its nib.
}

- (void) initLayers
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    self.layers = [DBUtils getProjectMapPageLayer:appDelegate.currProjectMap];
    self.entries = [[[NSMutableArray alloc] init] autorelease];
    self.entriesSelected = [[[NSMutableArray alloc] init] autorelease];
    self.selectionStates = [[[NSMutableDictionary alloc] init] autorelease];
    for (Layer *layer in self.layers){
        [self.entries addObject:layer.pageIndex];
        [self.entriesSelected addObject:layer.pageIndex];
        [self.selectionStates setObject:[NSNumber numberWithBool:layer.selected] forKey:layer.pageIndex];
    }

}

- (void) initTools
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    self.toolsArray = [[[NSMutableArray alloc] init] autorelease] ;
    Project *project = [DBUtils getProjectInfo:appDelegate.currProjectMap] ;
    
    [self.toolsArray addObject:@"返回地图"] ;
    [self.toolsArray addObject:@"地图信息"] ;
    
    NSLog(@"####SHOW HOT %d", project.show_hot) ;
    
    if(project.show_hot){
        [self.toolsArray addObject:@"风险热图"];
    }
    if(project.show_static){
        [self.toolsArray addObject:@"分类统计"];
    }
    if(project.show_chengben){
        [self.toolsArray addObject:@"风险成本"];
    }
    
    //[self.toolsArray addObject:@"过滤器"] ;
    
    NSMutableArray *relations = [DBUtils getRiskRelation:appDelegate.currProjectMap] ;
    
    if(relations.count > 0){
        [self.toolsArray addObject:@"相关性"] ;
    }
    
    [self.toolsArray addObject:@"选择图层"] ;
}

- (void) initMap
{
    [NSThread detachNewThreadSelector:@selector(showLoading) toTarget:self withObject:nil];
    [self.scrollView setZoomScale:1.0 animated:NO] ;
    [self.scrollView2 setZoomScale:1.0 animated:NO] ;
    self.scrollView2.hidden = YES ;
    self.scrollView.hidden = NO ;
    self.maxX = 0 ;
    self.maxY = 0 ;
    self.minX = 0 ;
    self.minY = 0 ;
    //先绘制线
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            //是线
            UIImage *image1 = [UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.picEmz]] ;
            UIImage *image2 = [self whiteToTranparent:image1] ;
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:image2] autorelease] ;
            //imageView.frame = CGRectMake(pm.positionX*self.mSize - pm.width*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - pm.height*self.mSize/2, pm.width*self.mSize, pm.height*self.mSize) ;
            
            imageView.frame = CGRectMake(pm.positionX*self.mSize - (image2.size.width/38.286)*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - (image2.size.height/38.286)*self.mSize/2, (image2.size.width/38.286)*self.mSize, (image2.size.height/38.286)*self.mSize) ;
            
            if(self.maxX < imageView.frame.origin.x + imageView.frame.size.width){
                self.maxX = imageView.frame.origin.x + imageView.frame.size.width ;
            }
            if(self.maxY < imageView.frame.origin.y + imageView.frame.size.height){
                self.maxY = imageView.frame.origin.y + imageView.frame.size.height ;
            }
            if(self.minX > imageView.frame.origin.x + imageView.frame.size.width || i == 0){
                self.minX = imageView.frame.origin.x + imageView.frame.size.width ;
            }
            if(self.minY > imageView.frame.origin.y + imageView.frame.size.height || i == 0){
                self.minY = imageView.frame.origin.y + imageView.frame.size.height ;
            }
            
            if([@"相关性" isEqualToString:pm.Obj_maptype]){
                NSLog(@"######## 相关性 %@", pm.picEmz) ;
                [imageView setBackgroundColor:[UIColor redColor]] ;
            }
            
            imageView.tag = i + 100 ;
            
            [self.mapView addSubview:imageView] ;
        }
        if([@"目标" isEqualToString:pm.Obj_maptype]){
            self.target = i ;
        }
    }
    
    //后绘制风险
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline == NO && (pm.cardPic == nil || [@"" isEqualToString:pm.cardPic])){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //button.frame = CGRectMake(pm.positionX*self.mSize - pm.width*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - pm.height*self.mSize/2, pm.width*self.mSize, pm.height*self.mSize) ;
            UIImage *image1 = [UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.picEmz]] ;
            UIImage *image2 = [self whiteToTranparent:image1] ;
            button.frame = CGRectMake(pm.positionX*self.mSize - (image2.size.width/38.286)*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - (image2.size.height/38.286)*self.mSize/2, (image2.size.width/38.286)*self.mSize, (image2.size.height/38.286)*self.mSize) ;
            [button setBackgroundImage:image2 forState:UIControlStateNormal] ;
            [button setBackgroundImage:image2 forState:UIControlStateDisabled] ;
            //button.backgroundColor = [UIColor redColor] ;
            
            button.tag = i + 100;
            
            //添加长按事件
            //if(![@"" isEqualToString:pm.linkPics]){
                MyLongPressGestureRecognizer *gr =  [[MyLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:) context:pm.linkPics];
                [button addGestureRecognizer:gr];
                gr.context = [pm.linkPics copy] ;
                [gr release];
            //}
            
            if(self.maxX < button.frame.origin.x + button.frame.size.width){
                self.maxX = button.frame.origin.x + button.frame.size.width ;
            }
            if(self.maxY < button.frame.origin.y + button.frame.size.height){
                self.maxY = button.frame.origin.y + button.frame.size.height ;
            }
            if(self.minX > button.frame.origin.x + button.frame.size.width || i == 0){
                self.minX = button.frame.origin.x + button.frame.size.width ;
            }
            if(self.minY > button.frame.origin.y + button.frame.size.height || i == 0){
                self.minY = button.frame.origin.y + button.frame.size.height ;
            }
            
            //添加风险卡片
            if(pm.cardPic != nil && ![@"" isEqualToString:pm.cardPic]){
                NSLog(@"添加风险卡片 %@", pm.cardPic) ;
                MyLongPressGestureRecognizer *gr =  [[MyLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showCardPic:) context:[NSString stringWithFormat:@"%d", button.tag]];
                [button addGestureRecognizer:gr];
                gr.context = [NSString stringWithFormat:@"%d", button.tag] ;
                [gr release];
                
                [button addTarget:self action:@selector(showMapPic:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                if(i != self.target){
                    NSLog(@"添加风险卡片 %@", pm.cardPic) ;
                    [button addTarget:self action:@selector(showMapPic:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            [self.mapView addSubview:button] ;
        }
    }
    
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline == NO && !(pm.cardPic == nil || [@"" isEqualToString:pm.cardPic])){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //button.frame = CGRectMake(pm.positionX*self.mSize - pm.width*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - pm.height*self.mSize/2, pm.width*self.mSize, pm.height*self.mSize) ;
            UIImage *image1 = [UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.picEmz]] ;
            UIImage *image2 = [self whiteToTranparent:image1] ;
            button.frame = CGRectMake(pm.positionX*self.mSize - (image2.size.width/38.286)*self.mSize/2, ScreenHeight - pm.positionY*self.mSize - (image2.size.height/38.286)*self.mSize/2, (image2.size.width/38.286)*self.mSize, (image2.size.height/38.286)*self.mSize) ;
            [button setBackgroundImage:image2 forState:UIControlStateNormal] ;
            [button setBackgroundImage:image2 forState:UIControlStateDisabled] ;
            //button.backgroundColor = [UIColor redColor] ;
            
            button.tag = i + 100;
            
            //添加长按事件
            if(![@"" isEqualToString:pm.linkPics]){
                MyLongPressGestureRecognizer *gr =  [[MyLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:) context:pm.linkPics];
                [button addGestureRecognizer:gr];
                gr.context = [pm.linkPics copy] ;
                [gr release];
            }
            
            if(self.maxX < button.frame.origin.x + button.frame.size.width){
                self.maxX = button.frame.origin.x + button.frame.size.width ;
            }
            if(self.maxY < button.frame.origin.y + button.frame.size.height){
                self.maxY = button.frame.origin.y + button.frame.size.height ;
            }
            if(self.minX > button.frame.origin.x + button.frame.size.width || i == 0){
                self.minX = button.frame.origin.x + button.frame.size.width ;
            }
            if(self.minY > button.frame.origin.y + button.frame.size.height || i == 0){
                self.minY = button.frame.origin.y + button.frame.size.height ;
            }
            
            //添加风险卡片
            if(pm.cardPic != nil && ![@"" isEqualToString:pm.cardPic]){
                NSLog(@"添加风险卡片 %@", pm.cardPic) ;
                MyLongPressGestureRecognizer *gr =  [[MyLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showCardPic:) context:[NSString stringWithFormat:@"%d", button.tag]];
                [button addGestureRecognizer:gr];
                gr.context = [NSString stringWithFormat:@"%d", button.tag] ;
                [gr release];
                [button addTarget:self action:@selector(showMapPic:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                if(i != self.target){
                    NSLog(@"添加风险卡片 %@", pm.cardPic) ;
                    [button addTarget:self action:@selector(showMapPic:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            [self.mapView addSubview:button] ;
        }
    }
    
    int width = ScreenWidth ;
    
    if(self.maxX - self.minX > width){
        width = self.maxX - self.minX  + 20;
    }
    
    int height = ScreenHeight - 44 - StateBarHeight + 20;
    
    if(self.maxY - self.minY > height){
        height = self.maxY - self.minY + 20 ;
    }
    
    NSLog(@"#### %d %d %d %d", self.maxX, self.minX, self.maxY, self.minY) ;
    
    self.offsetX = width/2 - (self.maxX + self.minX)/2 + 5;
    self.offsetY = height/2 - (self.maxY + self.minY)/2 + 5;
    
    NSLog(@"#### %d %d", self.offsetX, self.offsetY) ;
    
    //偏移
    NSArray *views = [self.mapView subviews] ;
    for(int i = 0; i < views.count; i++){
        UIView *v = (UIView *)[views objectAtIndex:i] ;
        v.frame = CGRectOffset(v.frame, self.offsetX, self.offsetY) ;
    }
    
    self.scrollView.contentSize = CGSizeMake(width, height) ;
    self.mapView.frame = CGRectMake(0, 0, width, height) ;
    [self hideLoading] ;
}

- (void)handleLongPress:(MyLongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        if([@"" isEqualToString:gestureRecognizer.context]){
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"没有外链文件" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            self.currLinked = [gestureRecognizer.context componentsSeparatedByString:@"|"] ;
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            for(int i = 0; i < self.currLinked.count; i++){
                [alert addButtonWithTitle:[[self.currLinked objectAtIndex:i] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
            }
            [alert show];
        }
    }
}

- (void)handleLongPressCard:(MyLongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.currLinked = [gestureRecognizer.context componentsSeparatedByString:@"|"] ;
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        for(int i = 0; i < self.currLinked.count; i++){
            [alert addButtonWithTitle:[[self.currLinked objectAtIndex:i] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
        }
        [alert show];
    }
}

- (void)showCardPic:(MyLongPressGestureRecognizer *)gestureRecognizer
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    Project *project = [DBUtils getProjectInfo:appDelegate.currProjectMap] ;
    if(project.show_cart){
        ProjectMap *pm = [self.objectArray objectAtIndex:([gestureRecognizer.context intValue] - 100)] ;
        [self.imageView setImage:[UIImage imageWithContentsOfFile:[DBUtils findFilePath:pm.cardPic]]] ;
        self.scrollView.hidden = YES ;
        self.scrollView2.hidden = NO ;
        [self.backItem setTitle:@"返回地图"] ;
    }else{
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"导出文件中不包含风险卡片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show] ;
    }
}

- (void)showMapPic:(id)sender
{
    [self.backItem setTitle:@"返回地图"] ;
    
    ProjectMap *pm = [self.objectArray objectAtIndex:([sender tag] - 100)] ;
    
    //非风险地图不显示
    NSRange foundObj = [pm.belongLayers rangeOfString:@"风险地图" options:NSCaseInsensitiveSearch];
    if(!foundObj.length>0) {
        return ;
    }
    
    if(![@"" isEqualToString: pm.cardPic]){
        //这说明是五角星
        for(int i = 0; i < self.objectArray.count; i++){
            ProjectMap *p = [self.objectArray objectAtIndex:i] ;
            if([p.Obj_db_id isEqualToString:pm.Obj_other1]){
                pm = p ;
                break ;
            }
        }
    }
    
    //所有风险地图层显示，其它层隐藏
    NSArray *views = [self.mapView subviews] ;
    for(int i = 0; i < views.count; i++){
        UIView *v = (UIView *)[views objectAtIndex:i] ;
        if(v.tag >= 100){
            ProjectMap *pm = [self.objectArray objectAtIndex:([v tag] - 100)] ;
            NSRange foundObj = [pm.belongLayers rangeOfString:@"风险地图" options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
                v.hidden = NO ;
            }else{
                v.hidden = YES ;
            }
        }
    }
    
    //所有试图变透明
    views = [self.mapView subviews] ;
    for(int i = 0; i < views.count; i++){
        UIView *v = (UIView *)[views objectAtIndex:i] ;
        [v setAlpha:0.1] ;
        if([v isKindOfClass:[UIButton class]]){
            UIButton *b = (UIButton *)v ;
            b.enabled = NO ;
        }
    }
    
    //UIButton *v = (UIButton *)[self.mapView viewWithTag:(self.target + 100)] ;
    //[v setAlpha:1.0] ;
    
    pm.isShow = YES ;//!pm.isShow ;
    
    //将所有的线重置
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            pm.willShow = NO ;
        }
    }
    
    [self findLine] ;
}

- (void) showRiskStar: (ProjectMap *)proj
{
    NSLog(@"####222 obj_other1 [%@]", proj.Obj_db_id) ;
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if([proj.Obj_db_id isEqualToString:pm.Obj_other1]){
            NSLog(@"#### obj_other1 [%@]", pm.Obj_other1) ;
            UIButton *v = (UIButton *)[self.mapView viewWithTag:(i+100)] ;
            [v setAlpha:1.0] ;
        }
    }
}

- (void) findLine
{
    //首先计算哪些线需要显示
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isShow){
            UIButton *v = (UIButton *)[self.mapView viewWithTag:(i+100)] ;
            [v setAlpha:1.0] ;
            [self showRiskStar:pm] ;
            [self markLine:pm] ;
        }
    }
}

- (void) markLine:(ProjectMap *)thePM
{
    //ProjectMap *targetPM = [self.objectArray objectAtIndex:self.target];
    //NSLog(@"targetPM[%@]", targetPM.objectId) ;
    //先找离这个pm最近的线
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            if([thePM.objectId isEqualToString:pm.fromWho]){
                //后面的线
                BOOL isContinue = YES ;
                for(int j = 0; j < self.objectArray.count; j++){
                    ProjectMap *pp = [self.objectArray objectAtIndex:j] ;
                    if([pp.objectId isEqualToString:pm.toWho]){
                        //下一个风险
                        NSRange foundObj = [pp.belongLayers rangeOfString:@"风险地图" options:NSCaseInsensitiveSearch];
                        if(!foundObj.length>0) {
                            isContinue = NO ;
                        }
                    }
                }
                if(isContinue){
                    pm.willShow = YES ;
                    NSLog(@"--------------after [%@]", pm.objectId) ;
                    [self markAfterLine:pm] ;
                    [self markBeforeLine:pm] ;
                }
            }
            if([thePM.objectId isEqualToString:pm.toWho]){
                //前面的线
                BOOL isContinue = YES ;
                for(int j = 0; j < self.objectArray.count; j++){
                    ProjectMap *pp = [self.objectArray objectAtIndex:j] ;
                    if([pp.objectId isEqualToString:pm.fromWho]){
                        //上一个风险
                        NSRange foundObj = [pp.belongLayers rangeOfString:@"风险地图" options:NSCaseInsensitiveSearch];
                        if(!foundObj.length>0) {
                            isContinue = NO ;
                        }
                    }
                }
                if(isContinue){
                    pm.willShow = YES ;
                    NSLog(@"--------------before [%@]", pm.objectId) ;
                    [self markBeforeLine:pm] ;
                    [self markAfterLine:pm] ;
                }
            }
        }
    }
    [self drawLine];
}

- (void) markBeforeLine:(ProjectMap *)thePM
{
    NSString *afterObjectId = [thePM.toWho copy];
    NSString *beforeObjectId = [thePM.fromWho copy];
    NSLog(@"####5555 [%@][%@]", afterObjectId, beforeObjectId) ;
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if([afterObjectId isEqualToString:pm.objectId] || [beforeObjectId isEqualToString:pm.objectId]){
            UIButton *v = (UIButton *)[self.mapView viewWithTag:(i+100)] ;
            NSLog(@"####4321 [%@][%@]", pm.objectId, thePM.objectId) ;
            [v setAlpha:1.0] ;
            [self showRiskStar:pm] ;
        }
    }
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            if([beforeObjectId isEqualToString:pm.toWho]){
                //前面的线
                BOOL isContinue = YES ;
                for(int j = 0; j < self.objectArray.count; j++){
                    ProjectMap *pp = [self.objectArray objectAtIndex:j] ;
                    if([pp.objectId isEqualToString:pm.fromWho]){
                        //上一个风险
                        NSLog(@"#### AAABBB %@", pp.title);
                        NSRange foundObj = [pp.belongLayers rangeOfString:@"风险地图" options:NSCaseInsensitiveSearch];
                        if(!foundObj.length>0) {
                            isContinue = NO ;
                        }
                    }
                }
                if(isContinue){
                    pm.willShow = YES ;
                    [self markBeforeLine:pm] ;
                    /*
                    for(int j = 0; j < self.objectArray.count; j++){
                        ProjectMap *pm2 = [self.objectArray objectAtIndex:j];
                        if([pm.fromWho isEqualToString:pm2.toWho]){
                            pm2.willShow = YES ;
                            [self markBeforeLine:pm2] ;
                        }
                    }
                     */
                }
            }
        }
    };
}

- (void) markAfterLine:(ProjectMap *)thePM
{
    ProjectMap *targetPM = [self.objectArray objectAtIndex:self.target];
    NSString *afterObjectId = [thePM.toWho copy];
    NSString *beforeObjectId = [thePM.fromWho copy];
    NSLog(@"####5555 [%@][%@]", afterObjectId, beforeObjectId) ;
    NSLog(@"markAfterLine [%@][%@]", afterObjectId, targetPM.objectId) ;
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if([afterObjectId isEqualToString:pm.objectId] || [beforeObjectId isEqualToString:pm.objectId]){
            UIButton *v = (UIButton *)[self.mapView viewWithTag:(i+100)] ;
            NSLog(@"####4321 [%@][%@]", pm.objectId, thePM.objectId) ;
            [v setAlpha:1.0] ;
            [self showRiskStar:pm] ;
        }
    }
    if([afterObjectId isEqualToString:targetPM.objectId]){
        NSLog(@"--------------RETUEN") ;
        return ;
    }
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if(pm.isline){
            if([afterObjectId isEqualToString:pm.fromWho]){
                BOOL isContinue = YES ;
                for(int j = 0; j < self.objectArray.count; j++){
                    ProjectMap *pp = [self.objectArray objectAtIndex:j] ;
                    if([pp.objectId isEqualToString:pm.toWho]){
                        //下一个风险
                        NSRange foundObj = [pp.belongLayers rangeOfString:@"风险地图" options:NSCaseInsensitiveSearch];
                        if(!foundObj.length>0) {
                            isContinue = NO ;
                        }
                    }
                }
                if(isContinue){
                    pm.willShow = YES ;
                    [self markAfterLine:pm] ;
                    /*
                    NSLog(@"--------------after22 [%@]", pm.toWho) ;
                    for(int j = 0; j < self.objectArray.count; j++){
                        ProjectMap *pm2 = [self.objectArray objectAtIndex:j];
                        if([pm.toWho isEqualToString:pm2.fromWho]){
                            pm2.willShow = YES ;
                            [self markAfterLine:pm2] ;
                        }
                    }
                     */
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
            //imageView.frame = CGRectMake(pm.positionX*self.mSize - pm.width*self.mSize/2 + self.offsetX, ScreenHeight - pm.positionY*self.mSize - pm.height*self.mSize/2 + self.offsetY, pm.width*self.mSize, pm.height*self.mSize) ;
            imageView.frame = CGRectMake(pm.positionX*self.mSize - (image2.size.width/38.286)*self.mSize/2 + self.offsetX, ScreenHeight - pm.positionY*self.mSize - (image2.size.height/38.286)*self.mSize/2 + self.offsetY, (image2.size.width/38.286)*self.mSize, (image2.size.height/38.286)*self.mSize) ;
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
        self.scrollView2.hidden = NO ;
        [self.backItem setTitle:@"返回地图"] ;
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
    if([self.backItem.title isEqualToString:@"返回地图"]){
        [self draw01:Nil];
        [self repeatMap];
        [self.backItem setTitle:@"返回地图列表"] ;
    }else{
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
        [appDelegate gotoLastPage] ;
    }
}

- (IBAction)draw01:(id)sender
{
    
    self.scrollView.hidden = NO ;
    self.scrollView2.hidden = YES ;
    
    //删除所有的对象
    NSArray *views = [self.mapView subviews] ;
    for(int i = 0; i < views.count; i++){
        UIView *v = (UIView *)[views objectAtIndex:i] ;
        if(v.tag < 100){
            [v removeFromSuperview];
        }else{
            v.hidden = NO ;
            if([v isKindOfClass:[UIButton class]]){
                UIButton *b = (UIButton *)v ;
                b.enabled = YES ;
            }
            [v setAlpha:1.0] ;
        }
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
    
    //[self initMap] ;
    [self closeToolViewAction:nil];
    
    [self.backItem setTitle:@"返回地图列表"] ;
}

- (IBAction)draw02:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskHotPage] ;
}

- (IBAction)drawRelation:(id)sender
{
    for(int i = 0; i < self.mapView.subviews.count; i++){
        UIView *v = [self.mapView.subviews objectAtIndex:i] ;
        [v setAlpha:0.1] ;
        if([v isKindOfClass:[UIButton class]]){
            UIButton *b = (UIButton *)v ;
            b.enabled = NO ;
        }
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    NSMutableArray *relations = [DBUtils getRiskRelation:appDelegate.currProjectMap] ;
    for(int i = 0; i < relations.count; i++){
        RiskRelation *relation = [relations objectAtIndex:i] ;
        NSLog(@"#### relation.relationRemark %@", relation.relationRemark) ;
        UIButton *fromButton = nil ;
        UIButton *toButton = nil ;
        for(int j = 0; j < self.objectArray.count; j++){
            ProjectMap *pm = [self.objectArray objectAtIndex:j] ;
            if([pm.Obj_data3 isEqualToString:relation.riskFrom]){
                NSLog(@"#### relation.riskFrom %@", relation.riskFrom) ;
                fromButton = (UIButton *)[self.mapView viewWithTag:(j+100)] ;
                fromButton.enabled = NO ;
                [fromButton setAlpha:1.0] ;
            }
            if([pm.Obj_data3 isEqualToString:relation.riskTo]){
                NSLog(@"#### relation.riskTo %@", relation.riskTo) ;
                toButton = (UIButton *)[self.mapView viewWithTag:(j+100)] ;
                toButton.enabled = NO ;
                [toButton setAlpha:1.0] ;
            }
        }
        
        DrawLine *lineView = [[DrawLine alloc] initWithFrame:CGRectMake(fromButton.frame.origin.x + fromButton.frame.size.width/2, fromButton.frame.origin.y + fromButton.frame.size.height/2, toButton.frame.origin.x + toButton.frame.size.width/2 - (fromButton.frame.origin.x + fromButton.frame.size.width/2), toButton.frame.origin.y + toButton.frame.size.height/2 - (fromButton.frame.origin.y + fromButton.frame.size.height/2)) From:CGPointMake(fromButton.frame.origin.x + fromButton.frame.size.width/2, fromButton.frame.origin.y + fromButton.frame.size.height/2) To:CGPointMake(toButton.frame.origin.x + toButton.frame.size.width/2, toButton.frame.origin.y + toButton.frame.size.height/2)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lineView.frame.origin.x + lineView.frame.size.width/2, lineView.frame.origin.y + lineView.frame.size.height/2, 200, 20)];
        
        int fontSize = 10 ;
        if(isIpad){
            fontSize = 12 ;
        }
        
        [label setBackgroundColor:[UIColor clearColor]] ;
        [label setText:[NSString stringWithFormat:@"%@", relation.relationRemark]] ;
        [label setFont:[UIFont fontWithName:@"Arial" size:fontSize]] ;
        
        [self.mapView addSubview:lineView];
        [self.mapView addSubview:label];
    }
    
    [self.backItem setTitle:@"返回地图"] ;
}

- (IBAction) selectLayers:(id)sender
{
    //点击后删除之前的PickerView
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[CYCustomMultiSelectPickerView class]]) {
            [view removeFromSuperview];
        }
    }
    
    multiPickerView = [[CYCustomMultiSelectPickerView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 160,[UIScreen mainScreen].bounds.size.width - 260-20, 320, 260+44)];
    
    //  multiPickerView.backgroundColor = [UIColor redColor];
    multiPickerView.entriesArray = self.entries;
    multiPickerView.entriesSelectedArray = self.entriesSelected;
    multiPickerView.multiPickerDelegate = self;
    
    [self.view addSubview:multiPickerView];
    
    [multiPickerView pickerShow];

    NSLog(@"#### selectLayers");
    
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskCostPage] ;
}

- (IBAction)gotoRiskSearch:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoRiskSearchPage] ;
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
    if(scrollView == self.scrollView2){
        return self.imageView ;
    }
    return self.mapView;
}

- (IBAction) showToolViewAction:(id)sender
{
    //获取权限列表
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"功能列表"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: nil] ;
    actionSheet.delegate = self ;
    for(int i = 0; i < self.toolsArray.count; i++){
        [actionSheet addButtonWithTitle:[self.toolsArray objectAtIndex:i]] ;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 0)
        return ;
    NSLog(@"#### %d", buttonIndex) ;
    NSString *toolName = [self.toolsArray objectAtIndex:buttonIndex] ;
    
    if([@"返回地图" isEqualToString: toolName]){
        [self draw01:nil];
    }
    if([@"风险热图" isEqualToString: toolName]){
        [self draw02:nil];
    }
    if([@"地图信息" isEqualToString: toolName]){
        [self gotoRiskList:nil];
    }
    if([@"分类统计" isEqualToString: toolName]){
        [self gotoRiskStatis:nil];
    }
    if([@"风险成本" isEqualToString: toolName]){
        [self gotoRiskCost:nil];
    }
    if([@"过滤器" isEqualToString: toolName]){
        [self gotoRiskSearch:nil];
    }
    if([@"相关性" isEqualToString: toolName]){
        [self drawRelation:nil];
    }
    if([@"选择图层" isEqualToString: toolName]){
        [self selectLayers:nil];
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

- (void) showObject
{
    self.scrollView.hidden = NO ;
    self.scrollView2.hidden = YES ;
    [self.backItem setTitle:@"返回地图"] ;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    NSLog(@"#### %@", appDelegate.currDBID) ;
    for(int i = 0; i < self.mapView.subviews.count; i++){
        UIView *v = [self.mapView.subviews objectAtIndex:i] ;
        [v setAlpha:0.1] ;
        if([v isKindOfClass:[UIButton class]]){
            UIButton *b = (UIButton *)v ;
            b.enabled = NO ;
        }
    }
    for(int i = 0 ; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if([pm.Obj_db_id isEqualToString:appDelegate.currDBID]){
            UIButton *button = (UIButton *)[self.mapView viewWithTag:(i+100)] ;
            button.enabled = NO ;
            [button setAlpha:1.0] ;
        }
    }
}

#pragma mark - Delegate
//获取到选中的数据
-(void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr
{
    self.entriesSelected = [selectedEntriesArr retain];
    //根据图层重绘
    [self draw01:Nil];
    [self repeatMap];
}

-(void) repeatMap
{
    NSArray *views = [self.mapView subviews] ;
    for(int i = 0; i < views.count; i++){
        UIView *v = (UIView *)[views objectAtIndex:i] ;
        if(v.tag >= 100){
            ProjectMap *pm = [self.objectArray objectAtIndex: (v.tag - 100)] ;
            v.hidden = YES ;
            for(int i = 0; i < self.layers.count; i++){
                Layer *layer = (Layer *)[self.layers objectAtIndex:i] ;
                layer.selected = NO ;
                for(int j = 0; j < self.entriesSelected.count; j++){
                    NSString *pageIndex = [self.entriesSelected objectAtIndex:j];
                    if([layer.pageIndex isEqualToString:pageIndex]){
                        //这个图层需要显示
                        layer.selected = YES ;
                        break ;
                    }
                }
                if(layer.selected){
                    NSRange foundObj=[pm.belongLayers rangeOfString:layer.layerName options:NSCaseInsensitiveSearch];
                    if(foundObj.length > 0) {
                        v.hidden = NO ;
                    }
                }
            }
        }
    }
}

-(void) showLoading
{
    [self.view addSubview:self.loadingView] ;
}

-(void) hideLoading
{
    NSLog(@"#### hideLoading") ;
    [self.loadingView removeFromSuperview] ;
}

@end

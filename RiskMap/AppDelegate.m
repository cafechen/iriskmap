//
//  AppDelegate.m
//  RiskMap
//
//  Created by Steven on 13-6-26.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#include "Define.h"
#import "AppDelegate.h"
#import "MainController.h"
#import "MapController.h"
#import "DBUtils.h"
#import "RiskListController.h"
#import "RiskHotController.h"
#import "RiskCostController.h"
#import "RiskSortController.h"
#import "RiskStatisController.h"
#import "FileController.h"
#import "InputController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIViewController *mainController = nil ;
    
    if(isIpad){
        mainController = [[[FileController alloc] initWithNibName:@"FileController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        mainController = [[[FileController alloc] initWithNibName:@"FileController_iphone5" bundle:nil] autorelease];
    }else{
        mainController = [[[FileController alloc] initWithNibName:@"FileController" bundle:nil] autorelease];
    }
    
    self.navController = [[[UINavigationController alloc] init] autorelease];
    
    [self.navController setNavigationBarHidden:YES animated:NO];
    
    [self.navController pushViewController:mainController animated:YES] ;
    
    self.window.rootViewController = self.navController;
    
    //初始化数据库
    //[self loadData] ;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) loadData
{
    //初始化数据库
    [DBUtils initDB] ;
    //更新目录结构
    [DBUtils updateDirectory] ;
    [DBUtils updateProject] ;
    [DBUtils updateProjectMap];
    [DBUtils updateRisk] ;
    [DBUtils updateProjectMatrix] ;
    [DBUtils updateProjectVectorDetail] ;
    [DBUtils updateRiskScore] ;
    [DBUtils updateRiskCost] ;
    [DBUtils updateDictType] ;
}

- (void) gotoMainPage
{
    NSLog(@"Goto Main Page Start") ;
    MainController *mainController = nil;
    
    if(isIpad){
        mainController = [[[MainController alloc] initWithNibName:@"MainController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        mainController = [[[MainController alloc] initWithNibName:@"MainController_iphone5" bundle:nil] autorelease];
    }else{
        mainController = [[[MainController alloc] initWithNibName:@"MainController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:mainController animated:YES] ;
    NSLog(@"Goto Main Page End") ;
}

- (void) gotoMapPage
{
    NSLog(@"Goto Map Page Start") ;
    MapController *mapController = nil;
    
    if(isIpad){
        mapController = [[[MapController alloc] initWithNibName:@"MapController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        mapController = [[[MapController alloc] initWithNibName:@"MapController_iphone5" bundle:nil] autorelease];
    }else{
        mapController = [[[MapController alloc] initWithNibName:@"MapController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:mapController animated:YES] ;
    NSLog(@"Goto Map Page End") ;
}

- (void) gotoLastPage
{
    NSLog(@"Goto Last Page Start") ;
    [self.navController popViewControllerAnimated:YES];
    NSLog(@"Goto Login Page End") ;
}

- (void) gotoLastFilePage
{
    NSLog(@"Goto Last Page Start") ;
    [self.navController popViewControllerAnimated:YES];
    UIViewController *fileController = [self.navController.childViewControllers objectAtIndex:0] ;
    if([fileController isKindOfClass:[FileController class]]){
        [(FileController *)fileController reloadFile] ;
    }
    NSLog(@"Goto Login Page End") ;
}

- (void) gotoRiskListPage
{
    NSLog(@"Goto Risk List Page Start") ;
    RiskListController *riskListController = nil;
    
    if(isIpad){
        riskListController = [[[RiskListController alloc] initWithNibName:@"RiskListController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        riskListController = [[[RiskListController alloc] initWithNibName:@"RiskListController_iphone5" bundle:nil] autorelease];
    }else{
        riskListController = [[[RiskListController alloc] initWithNibName:@"RiskListController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:riskListController animated:YES] ;
    NSLog(@"Goto Risk List Page End") ;
}

- (void) gotoRiskHotPage
{
    NSLog(@"Goto Risk Hot Page Start") ;
    RiskHotController *riskHotController = [[[RiskHotController alloc] initWithNibName:@"RiskHotController" bundle:nil] autorelease];
    
    if(isIpad){
        riskHotController = [[[RiskHotController alloc] initWithNibName:@"RiskHotController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        riskHotController = [[[RiskHotController alloc] initWithNibName:@"RiskHotController_iphone5" bundle:nil] autorelease];
    }else{
        riskHotController = [[[RiskHotController alloc] initWithNibName:@"RiskHotController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:riskHotController animated:YES] ;
    NSLog(@"Goto Risk Hot Page End") ;
}

- (void) gotoRiskCostPage
{
    NSLog(@"Goto Risk Cost Page Start") ;
    RiskCostController *riskCostController = nil;
    
    if(isIpad){
        riskCostController = [[[RiskCostController alloc] initWithNibName:@"RiskCostController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        riskCostController = [[[RiskCostController alloc] initWithNibName:@"RiskCostController_iphone5" bundle:nil] autorelease];
    }else{
        riskCostController = [[[RiskCostController alloc] initWithNibName:@"RiskCostController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:riskCostController animated:YES] ;
    NSLog(@"Goto Risk Cost Page End") ;
}

- (void) gotoRiskSortPage
{
    NSLog(@"Goto Risk Sort Page Start") ;
    RiskSortController *riskSortController = nil;
    
    if(isIpad){
        riskSortController = [[[RiskSortController alloc] initWithNibName:@"RiskSortController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        riskSortController = [[[RiskSortController alloc] initWithNibName:@"RiskSortController_iphone5" bundle:nil] autorelease];
    }else{
        riskSortController = [[[RiskSortController alloc] initWithNibName:@"RiskSortController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:riskSortController animated:YES] ;
    NSLog(@"Goto Risk Sort Page End") ;
}

- (void) gotoRiskStatisPage
{
    NSLog(@"Goto Risk Statis Page Start") ;
    RiskStatisController *riskStatisController = nil ;
    
    if(isIpad){
        riskStatisController = [[[RiskStatisController alloc] initWithNibName:@"RiskStatisController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        riskStatisController = [[[RiskStatisController alloc] initWithNibName:@"RiskStatisController_iphone5" bundle:nil] autorelease];
    }else{
        riskStatisController = [[[RiskStatisController alloc] initWithNibName:@"RiskStatisController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:riskStatisController animated:YES] ;
    NSLog(@"Goto Risk Statis Page End") ;
}

- (void) gotoInputPage
{
    NSLog(@"Goto Risk Input Page Start") ;
    InputController *inputController = nil ;
    
    if(isIpad){
        inputController = [[[InputController alloc] initWithNibName:@"InputController_ipad" bundle:nil] autorelease];
    }else if(isIPhone5){
        inputController = [[[InputController alloc] initWithNibName:@"InputController_iphone5" bundle:nil] autorelease];
    }else{
        inputController = [[[InputController alloc] initWithNibName:@"InputController" bundle:nil] autorelease];
    }
    
    [self.navController pushViewController:inputController animated:YES] ;
    NSLog(@"Goto Risk Input Page End") ;
}

@end

//
//  AppDelegate.h
//  RiskMap
//
//  Created by Steven on 13-6-26.
//  Copyright (c) 2013年 laka. All rights reserved.
//
#import "Define.h"
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;

@property (nonatomic, retain) NSString *currProjectMap;

- (void) gotoMainPage ;
- (void) gotoMapPage ;
- (void) gotoLastPage ;
- (void) gotoLastFilePage ;
- (void) gotoRiskListPage ;
- (void) gotoRiskHotPage ;
- (void) gotoRiskCostPage ;
- (void) gotoRiskSortPage ;
- (void) gotoRiskStatisPage ;
- (void) gotoInputPage ;

@end

//
//  MainController.h
//  RiskMap
//
//  Created by Steven on 13-6-26.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *dirArray;

@property (nonatomic, retain) IBOutlet UITableView *dirTableView;

@property (nonatomic, retain) IBOutlet UIView *loadingView ;

@end

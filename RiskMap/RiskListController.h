//
//  RiskListController.h
//  RiskMap
//
//  Created by Steven on 13-7-9.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskListController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *riskArray;
@property (nonatomic, retain) NSMutableArray *riskTitleArray;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end

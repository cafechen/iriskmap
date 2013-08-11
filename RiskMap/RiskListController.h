//
//  RiskListController.h
//  RiskMap
//
//  Created by Steven on 13-7-9.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskListController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, retain) NSMutableArray *riskArray;
@property (nonatomic, retain) NSMutableArray *searchArray;
@property (nonatomic, retain) NSMutableArray *riskTitleArray;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end

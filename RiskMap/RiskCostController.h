//
//  RiskCostController.h
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskCostController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (nonatomic, retain) NSMutableArray *riskArray;
@property (nonatomic, retain) NSMutableArray *tableArray;
@property (nonatomic, retain) NSMutableArray *vectorArray;
@property (nonatomic, retain) NSMutableArray *leftArray;
@property (nonatomic, retain) NSMutableArray *rightArray;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *leftLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightLabel;
@property (nonatomic, readwrite) int whichChange;
@property (nonatomic, readwrite) int currLeft;
@property (nonatomic, readwrite) int currRight;

@end

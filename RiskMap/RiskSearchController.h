//
//  RiskSearchController.h
//  RiskMap
//
//  Created by steven on 8/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskSearchController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate>
@property (nonatomic, retain) NSMutableArray *dictArray;
@property (nonatomic, retain) NSMutableArray *riskArray;
@property (nonatomic, retain) NSMutableArray *riskScoreArray;
@property (nonatomic, retain) NSMutableArray *searchRiskArray;
@property (nonatomic, retain) NSMutableArray *riskTitleArray;
@property (nonatomic, retain) NSMutableArray *matrixArray;
@property (nonatomic, retain) NSMutableArray *vectorArray;
@property (nonatomic, readwrite) int currButton;
@property (nonatomic, readwrite) int currRiskType;
@property (nonatomic, readwrite) int currVector;
@property (nonatomic, readwrite) int currManage;
@property (nonatomic, readwrite) int currRange;
@property (nonatomic, readwrite) float currScore;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *riskTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *riskVectorLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UIButton *manageButton;
@property (nonatomic, retain) IBOutlet UIButton *rangeButton;
@property (nonatomic, retain) IBOutlet UITextField *rangeFieldSmail;
@property (nonatomic, retain) IBOutlet UITextField *rangeFieldBig;
@end

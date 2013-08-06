//
//  RiskCostController.h
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskCostController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *riskArray;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end

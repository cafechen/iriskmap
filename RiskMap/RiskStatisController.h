//
//  RiskStatisController.h
//  RiskMap
//
//  Created by steven on 7/18/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskStatisController : UIViewController

@property (nonatomic, retain) NSMutableArray *riskArray;
@property (nonatomic, retain) NSMutableArray *riskTitleArray;
@property (nonatomic, readwrite) int maxWidth;
@property (nonatomic, readwrite) int maxHeight;
@end

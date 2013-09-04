//
//  RiskSortController.h
//  RiskMap
//
//  Created by steven on 7/18/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskSortController : UIViewController

@property (nonatomic, readwrite) int currMatrix;
@property (nonatomic, readwrite) BOOL isManage;
@property (nonatomic, retain) NSMutableArray *riskArray;
@property (nonatomic, retain) NSMutableArray *matrixArray;
@property (nonatomic, retain) NSMutableArray *matrixTitleArray;
@property (nonatomic, retain) IBOutlet UIImageView *heightImageView;
@property (nonatomic, retain) IBOutlet UIImageView *widthImageView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end

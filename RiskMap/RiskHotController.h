//
//  RiskHotController.h
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskHotController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *hotView;
@property (nonatomic, retain) IBOutlet UIButton *switchButton;
@property (nonatomic, retain) NSMutableArray *matrixArray;
@property (nonatomic, retain) NSMutableArray *vectorArray;
@property (nonatomic, retain) NSMutableArray *matrixTitleArray;
@property (nonatomic, readwrite) int maxX;
@property (nonatomic, readwrite) int maxY;
@property (nonatomic, readwrite) int mSize;
@property (nonatomic, readwrite) int currMatrix;
@property (nonatomic, readwrite) BOOL isManage;
@property (nonatomic, retain) UIImage *redImage;
@property (nonatomic, retain) UIImage *blueImage;

@end

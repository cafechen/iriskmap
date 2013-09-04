//
//  FileController.h
//  RiskMap
//
//  Created by steven on 13-8-5.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UIAlertView *alertView;

@property (nonatomic, retain) NSMutableArray *dirArray;

@property (nonatomic, retain) IBOutlet UITableView *dirTableView;

@property (nonatomic, retain) IBOutlet UIButton *logoButton;

@property (nonatomic, retain) IBOutlet UIView *loadingView ;

- (void) reloadFile;

@end

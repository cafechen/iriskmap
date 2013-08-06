//
//  FileController.h
//  RiskMap
//
//  Created by steven on 13-8-5.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *dirArray;

@property (nonatomic, retain) IBOutlet UITableView *dirTableView;

- (void) reloadFile;

@end

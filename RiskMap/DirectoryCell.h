//
//  DirectoryCell.h
//  RiskMap
//
//  Created by steven on 6/20/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryCell : UITableViewCell

@property (copy, nonatomic) NSString *directory;

@property (nonatomic, readwrite) int level;

@property (nonatomic, readwrite) BOOL isOpen;

@property (nonatomic, readwrite) BOOL isFile;

@property (nonatomic, retain) IBOutlet UILabel *directoryLabel;

@property (nonatomic, retain) IBOutlet UIImageView *dirImageView;

@end

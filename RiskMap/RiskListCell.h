//
//  RiskListCell.h
//  RiskMap
//
//  Created by Steven on 13-7-9.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskListCell : UITableViewCell

@property (nonatomic, retain) NSString *riskTitle ;
@property (nonatomic, retain) NSString *riskCode ;
@property (nonatomic, retain) NSString *riskType ;
@property (nonatomic, retain) NSString *riskTypeStr ;


@property (nonatomic, retain) IBOutlet UILabel *riskTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *riskCodeLabel;
@property (nonatomic, retain) IBOutlet UILabel *riskTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *riskTypeStrLabel;

@end

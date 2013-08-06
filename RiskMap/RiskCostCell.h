//
//  RiskCostCell.h
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskCostCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *costIdLabel;
@property (nonatomic, retain) IBOutlet UILabel *riskNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *riskCodeLabel;
@property (nonatomic, retain) IBOutlet UILabel *riskTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *beforeGailvLabel;
@property (nonatomic, retain) IBOutlet UILabel *beforeAffectLabel;
@property (nonatomic, retain) IBOutlet UILabel *beforeAffectQiLabel;
@property (nonatomic, retain) IBOutlet UILabel *manaChengbenLabel;
@property (nonatomic, retain) IBOutlet UILabel *afterGailvLabel;
@property (nonatomic, retain) IBOutlet UILabel *afterAffectLabel;
@property (nonatomic, retain) IBOutlet UILabel *afterQiLabel;
@property (nonatomic, retain) IBOutlet UILabel *affectQiLabel;
@property (nonatomic, retain) IBOutlet UILabel *shouyiLabel;
@property (nonatomic, retain) IBOutlet UILabel *jingshouyiLabel;
@property (nonatomic, retain) IBOutlet UILabel *bilvLabel;

@end

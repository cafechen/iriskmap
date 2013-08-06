//
//  RiskListCell.m
//  RiskMap
//
//  Created by Steven on 13-7-9.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import "RiskListCell.h"

@implementation RiskListCell

@synthesize riskTypeStr;
@synthesize riskType;
@synthesize riskTitle;
@synthesize riskCode;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRiskTitle:(NSString *)title{
    if (![title isEqualToString:riskTitle]) {
        riskTitle = [title copy];
        self.riskTitleLabel.text = riskTitle;
    }
}

-(void)setRiskCode:(NSString *)code{
    if (![code isEqualToString:riskCode]) {
        riskCode = [code copy];
        self.riskCodeLabel.text = riskCode;
    }
}

-(void)setRiskType:(NSString *)type{
    if (![type isEqualToString:riskType]) {
        riskType = [type copy];
        self.riskTypeLabel.text = riskType;
    }
}

-(void)setRiskTypeStr:(NSString *)typeStr{
    if (![typeStr isEqualToString:riskTypeStr]) {
        riskTypeStr = [typeStr copy];
        self.riskTypeStrLabel.text = riskTypeStr;
    }
}

@end

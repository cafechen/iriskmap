//
//  RiskFactorCell.m
//  RiskMap
//
//  Created by steven on 8/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "RiskFactorCell.h"

@implementation RiskFactorCell

@synthesize title;
@synthesize remark;
@synthesize type;

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

-(void)setTitle:(NSString *)t{
    if (![t isEqualToString:title]) {
        title = [t copy];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment =  NSTextAlignmentLeft ;
    }
}

-(void)setType:(NSString *)t{
    if (![t isEqualToString:type]) {
        type = [t copy];
        self.typeLabel.text = type;
        self.titleLabel.textAlignment =  NSTextAlignmentLeft ;
    }
}

-(void)setRemark:(NSString *)r{
    if (![r isEqualToString:remark]) {
        remark = [r copy];
        self.remarkLabel.text = remark;
    }
}

@end

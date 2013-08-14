//
//  RiskFactorCell.h
//  RiskMap
//
//  Created by steven on 8/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskFactorCell : UITableViewCell

@property (nonatomic, retain) NSString *title ;
@property (nonatomic, retain) NSString *type ;
@property (nonatomic, retain) NSString *remark ;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *remarkLabel;

@end

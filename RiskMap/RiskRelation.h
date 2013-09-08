//
//  RiskRelation.h
//  RiskMap
//
//  Created by Steven on 13-9-5.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskRelation : NSObject

@property (copy, nonatomic) NSString *relationId;
@property (copy, nonatomic) NSString *projectid;
@property (copy, nonatomic) NSString *riskFrom;
@property (copy, nonatomic) NSString *riskTo;
@property (copy, nonatomic) NSString *relationRemark;

@end

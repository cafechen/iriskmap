//
//  Risk.h
//  RiskMap
//
//  Created by Steven on 13-7-9.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Risk : NSObject

@property (copy, nonatomic) NSString *riskId;
@property (copy, nonatomic) NSString *projectId;
@property (copy, nonatomic) NSString *pageDetailId;
@property (copy, nonatomic) NSString *riskTitle;
@property (copy, nonatomic) NSString *riskCode;
@property (copy, nonatomic) NSString *riskTypeId;
@property (copy, nonatomic) NSString *riskTypeStr;
@property (copy, nonatomic) NSString *pageId;
@property (nonatomic, readwrite) int statis;

@end

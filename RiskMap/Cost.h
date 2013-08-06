//
//  Cost.h
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cost : NSObject

@property (copy, nonatomic) NSString *costId;
@property (copy, nonatomic) NSString *riskName;
@property (copy, nonatomic) NSString *riskCode;
@property (copy, nonatomic) NSString *riskType;
@property (nonatomic, readwrite) double beforeGailv;
@property (nonatomic, readwrite) double beforeAffect;
@property (nonatomic, readwrite) double beforeAffectQi;
@property (nonatomic, readwrite) double manaChengben;
@property (nonatomic, readwrite) double afterGailv;
@property (nonatomic, readwrite) double afterAffect;
@property (nonatomic, readwrite) double afterQi;
@property (nonatomic, readwrite) double affectQi;
@property (nonatomic, readwrite) double shouyi;
@property (nonatomic, readwrite) double jingshouyi;
@property (nonatomic, readwrite) double bilv;

@end

//
//  Score.h
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject

@property (copy, nonatomic) NSString *scoreId;
@property (copy, nonatomic) NSString *riskid;
@property (copy, nonatomic) NSString *scoreVectorId;
@property (nonatomic, readwrite) double scoreBefore;
@property (nonatomic, readwrite) double scoreEnd;

@end

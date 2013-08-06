//
//  Dictype.h
//  RiskMap
//
//  Created by steven on 7/22/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dictype : NSObject

@property (copy, nonatomic) NSString *dictypeId;
@property (copy, nonatomic) NSString *fatherId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *typeStr;
@property (nonatomic, readwrite) int isDel;

@end

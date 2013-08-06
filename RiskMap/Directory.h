//
//  Directory.h
//  RiskMap
//
//  Created by steven on 13-6-29.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Directory : NSObject

@property (nonatomic, readwrite) int level;

@property (nonatomic, readwrite) BOOL isOpen;

@property (nonatomic, readwrite) BOOL isFile;

@property (copy, nonatomic) NSString *fatherId;

@property (copy, nonatomic) NSString *dirId;

@property (copy, nonatomic) NSString *title;

@end

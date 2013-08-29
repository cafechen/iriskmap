//
//  Project.h
//  RiskMap
//
//  Created by steven on 13-8-11.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject

@property (copy, nonatomic) NSString *projectId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *huobi;
@property (nonatomic, readwrite) int show_cart;
@property (nonatomic, readwrite) int show_hot;
@property (nonatomic, readwrite) int show_sort;
@property (nonatomic, readwrite) int show_chengben;
@property (nonatomic, readwrite) int show_static;
@property (nonatomic, readwrite) int show_after;


@end

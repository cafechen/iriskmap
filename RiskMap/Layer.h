//
//  Layer.h
//  RiskMap
//
//  Created by steven on 13-6-29.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Layer : NSObject

@property (copy, nonatomic) NSString *layerId;

@property (nonatomic, readwrite) int visible;

@property (copy, nonatomic) NSString *layerName;

@property (copy, nonatomic) NSString *projectId;

@property (copy, nonatomic) NSString *pageIndex;

@property (copy, nonatomic) NSString *belongPage;

@property (nonatomic, readwrite) BOOL selected ;

@end

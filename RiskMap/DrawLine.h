//
//  DrawLine.h
//  RiskMap
//
//  Created by Steven on 13-9-5.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DrawLine : UIView{
}

@property (nonatomic, readwrite) CGPoint from;
@property (nonatomic, readwrite) CGPoint to;

- (id)initWithFrame:(CGRect)frame From: (CGPoint) thefrom To:(CGPoint) theto ;

@end

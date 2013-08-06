//
//  MyLongPressGestureRecognizer.m
//  RiskMap
//
//  Created by steven on 13-7-1.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import "MyLongPressGestureRecognizer.h"

@implementation MyLongPressGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action context:(id)context
{
    self = [super initWithTarget:target action:action] ;
    self.context = context ;
    return self ;
}

@end

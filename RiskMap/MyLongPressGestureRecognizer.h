//
//  MyLongPressGestureRecognizer.h
//  RiskMap
//
//  Created by steven on 13-7-1.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLongPressGestureRecognizer : UILongPressGestureRecognizer

@property (nonatomic, retain) id context;

- (id)initWithTarget:(id)target action:(SEL)action context:(id)context;

@end

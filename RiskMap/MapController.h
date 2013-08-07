//
//  MapController.h
//  RiskMap
//
//  Created by Steven on 13-6-26.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableArray *objectArray;
@property (nonatomic, retain) IBOutlet UIView *toolView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView2;
@property (nonatomic, retain) IBOutlet UIView *mapView;
@property (nonatomic, retain) NSArray *currLinked;
@property (nonatomic, readwrite) int target;
@property (nonatomic, readwrite) int maxX;
@property (nonatomic, readwrite) int maxY;
@property (nonatomic, readwrite) int mSize;

@end

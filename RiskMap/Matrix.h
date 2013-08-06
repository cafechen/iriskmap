//
//  Matrix.h
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matrix : NSObject

@property (copy, nonatomic) NSString *matrixId;
@property (copy, nonatomic) NSString *projectId;
@property (copy, nonatomic) NSString *matrix_x;
@property (copy, nonatomic) NSString *matrix_y;
@property (copy, nonatomic) NSString *matrix_title;
@property (copy, nonatomic) NSString *fatherid_matrix;
@property (copy, nonatomic) NSString *xIndex;
@property (copy, nonatomic) NSString *yIndex;
@property (nonatomic, readwrite) int Color;
@property (copy, nonatomic) NSString *levelType;

@end

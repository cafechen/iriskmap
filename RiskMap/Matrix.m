//
//  Matrix.m
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "Matrix.h"

@implementation Matrix

@synthesize matrixId;
@synthesize projectId;
@synthesize matrix_title;
@synthesize matrix_x;
@synthesize matrix_y;
@synthesize fatherid_matrix;
@synthesize xIndex;
@synthesize yIndex;
@synthesize Color;
@synthesize levelType;

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@][%@][%@][%@][%@][%@][%@][%@][%d][%@]",
            self.matrixId,
            self.projectId,
            self.matrix_title,
            self.matrix_x,
            self.matrix_y,
            self.fatherid_matrix,
            self.xIndex,
            self.yIndex,
            self.Color,
            self.levelType] ;
}

@end

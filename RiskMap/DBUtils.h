//
//  DBUtils.h
//  ssq
//
//  Created by steven on 13-4-24.
//  Copyright (c) 2013年 letoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface DBUtils : NSObject

+(BOOL) initDB ;
+(BOOL) updateDirectory ;
+(BOOL) updateProject ;
+(BOOL) updateProjectMap ;
+(BOOL) updateRisk ;
+(BOOL) updateProjectMatrix ;
+(BOOL) updateProjectVectorDetail ;
+(BOOL) updateRiskScore ;
+(BOOL) updateRiskCost ;
+(BOOL) updateDictType ;
+(NSMutableArray *) getProject ;
+(Project *) getProjectInfo:(NSString *) projectId ;
+(NSString *) getRisk:(NSString *) projectId RiskId:(NSString *)riskId ;
+(NSMutableArray *) getDirectory:(NSString *) fatherId ;
+(NSMutableArray *) getProjectMap:(NSString *) projectId ;
+(NSMutableArray *) getRisk:(NSString *) projectId ;
+(NSMutableArray *) getRiskType:(NSString *) projectId ;
+(NSMutableArray *) getProjectMatrix:(NSString *) projectId ;
+(NSMutableArray *) getProjectMatrixTitle:(NSString *) projectId ;
+(NSMutableArray *) getProjectVectorDetail: (NSString *) fatherid ;
+(NSMutableArray *) getRiskScore: (NSString *) vectorId ;
+(NSMutableArray *) getRiskCost ;
+(NSMutableArray *) getDictype ;
+(NSString *) findFilePath: (NSString *) filename;

@end

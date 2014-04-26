//
//  ProjectMap.h
//  RiskMap
//
//  Created by steven on 13-6-29.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectMap : NSObject

@property (copy, nonatomic) NSString *projectMapId;
@property (copy, nonatomic) NSString *projectId;
@property (copy, nonatomic) NSString *objectId;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, readwrite) double positionX;
@property (nonatomic, readwrite) double positionY;
@property (nonatomic, readwrite) double width;
@property (nonatomic, readwrite) double height;
@property (nonatomic, readwrite) int isline;
@property (nonatomic, readwrite) bool willShow;
@property (nonatomic, readwrite) bool isShow;
@property (copy, nonatomic) NSString *picPng;
@property (copy, nonatomic) NSString *picEmz;
@property (copy, nonatomic) NSString *belongPage;
@property (copy, nonatomic) NSString *Obj_maptype;
@property (copy, nonatomic) NSString *Obj_belongwho;
@property (copy, nonatomic) NSString *Obj_remark;
@property (copy, nonatomic) NSString *Obj_db_id;
@property (copy, nonatomic) NSString *Obj_riskTypeStr;
@property (copy, nonatomic) NSString *Obj_other1;
@property (copy, nonatomic) NSString *Obj_other2;
@property (copy, nonatomic) NSString *Obj_data1;
@property (copy, nonatomic) NSString *Obj_data2;
@property (copy, nonatomic) NSString *Obj_data3;
@property (nonatomic, readwrite) int lineType;
@property (nonatomic, readwrite) int lineType2;
@property (nonatomic, readwrite) int isDel;
@property (copy, nonatomic) NSString *linkPics;
@property (copy, nonatomic) NSString *cardPic;
@property (copy, nonatomic) NSString *fromWho;
@property (copy, nonatomic) NSString *toWho;
@property (copy, nonatomic) NSString *belongLayers;

@end

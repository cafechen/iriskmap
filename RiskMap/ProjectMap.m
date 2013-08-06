//
//  ProjectMap.m
//  RiskMap
//
//  Created by steven on 13-6-29.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import "ProjectMap.h"

@implementation ProjectMap

@synthesize projectMapId;
@synthesize projectId;
@synthesize objectId;
@synthesize title;
@synthesize positionX;
@synthesize positionY;
@synthesize width;
@synthesize height;
@synthesize isline;
@synthesize picPng;
@synthesize picEmz;
@synthesize belongPage;
@synthesize Obj_maptype;
@synthesize Obj_belongwho;
@synthesize Obj_remark;
@synthesize Obj_db_id;
@synthesize Obj_riskTypeStr;
@synthesize Obj_other1;
@synthesize Obj_other2;
@synthesize Obj_data1;
@synthesize Obj_data2;
@synthesize Obj_data3;
@synthesize lineType;
@synthesize lineType2;
@synthesize isDel;
@synthesize linkPics;
@synthesize cardPic;
@synthesize fromWho;
@synthesize toWho;
@synthesize isShow;
@synthesize willShow;

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@][%@][%@][%@][%f][%f][%f][%f][%d][%@][%@][%@][%@][%@][%@][%@][%@][%@][%@][%@][%@][%@][%d][%d][%d][%@][%@]",
            self.projectMapId,
            self.projectId,
            self.objectId,
            self.title,
            self.positionX,
            self.positionY,
            self.width,
            self.height,
            self.isline,
            self.picPng,
            self.picEmz,
            self.belongPage,
            self.Obj_maptype,
            self.Obj_belongwho,
            self.Obj_remark,
            self.Obj_db_id,
            self.Obj_riskTypeStr,
            self.Obj_other1,
            self.Obj_other2,
            self.Obj_data1,
            self.Obj_data2,
            self.Obj_data3,
            self.lineType,
            self.lineType2,
            self.isDel,
            self.linkPics,
            self.cardPic] ;
}

@end

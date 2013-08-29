//
//  DBUtils.m
//  ssq
//
//  Created by steven on 13-4-24.
//  Copyright (c) 2013年 letoke. All rights reserved.
//

#import "DBUtils.h"
#import "FMDatabase.h"
#import "GDataXMLNode.h"
#import "Directory.h"
#import "ProjectMap.h"
#import "Risk.h"
#import "Matrix.h"
#import "VectorDetail.h"
#import "Score.h"
#import "Cost.h"
#import "Dictype.h"
#import "Project.h"
#import "Vector.h"

@implementation DBUtils

+(FMDatabase*) getFMDB
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory
                                stringByAppendingPathComponent:@"riskmap.db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    
    return db ;
}

+(BOOL) initDB
{
    BOOL success;
    NSError *error;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory
                                stringByAppendingPathComponent:@"riskmap.db"];
    
    success = [fm fileExistsAtPath:writableDBPath];
    
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath]
                                   stringByAppendingPathComponent:@"riskmap.db"];
        success = [fm copyItemAtPath:defaultDBPath toPath:
                   writableDBPath error:&error];
        if(!success){
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return success ;
}

+(BOOL) updateDirectory
{
    [self checkDirectoryTable] ;
    [self updateDirectoryData] ;
    return YES ;
}

+(BOOL) updateRisk
{
    [self checkRiskTable] ;
    [self updateRiskData] ;
    return YES ;
}

+(BOOL) updateProject
{
    [self checkProjectTable] ;
    [self updateProjectData] ;
    return YES ;
}

+(BOOL) updateProjectMap
{
    [self checkProjectMapTable] ;
    [self updateProjectMapData] ;
    return YES ;
}

+(BOOL) updateProjectMatrix
{
    [self checkProjectMatrixTable] ;
    [self updateProjectMatrixData] ;
    return YES ;
}

+(BOOL) updateProjectVectorDetail
{
    //NSLog(@"#### updateProjectVectorDetail");
    [self checkProjectVectorDetailTable] ;
    [self updateProjectVectorDetailData] ;
    return YES ;
}

+(BOOL) updateRiskScore
{
    [self checkRiskScoreTable] ;
    [self updateRiskScoreData] ;
    return YES ;
}

+(BOOL) updateRiskCost
{
    [self checkRiskCostTable] ;
    [self updateRiskCostData] ;
    return YES ;
}

+(BOOL) updateDictType
{
    [self checkDicTypeTable] ;
    [self updateDicTypeData] ;
    return YES ;
}

+(BOOL) updateProjectVector
{
    [self checkProjectVectorTable] ;
    [self updateProjectVectorData] ;
    return YES ;
}

+(void) checkDirectoryTable
{
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='directory'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table directory(id varchar(255) primary key, fatherid varchar(255), title varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateDirectoryData{
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"t_project_folder.xml"];
    
    NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            GDataXMLElement *idElement = [[risk elementsForName:@"id"] objectAtIndex:0];
            NSString *riskId = [idElement stringValue];
            GDataXMLElement *fatherIdElement = [[risk elementsForName:@"fatherid"] objectAtIndex:0];
            NSString *fatherId = [fatherIdElement stringValue];
            GDataXMLElement *titleElement = [[risk elementsForName:@"title"] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            [db executeUpdate:@"REPLACE INTO directory(id, fatherid, title) VALUES(?, ?, ?)" ,
             riskId, fatherId, title];
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    //插入到数据库中
    
}

+(void) checkProjectTable
{
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='project'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table project(id varchar(255) primary key, fatherid varchar(255), title varchar(255), belong_department varchar(255),remark varchar(255),AddDate varchar(255),isUpload int, isComplete int, show_card int, show_hot int, show_sort int, show_chengben int, show_static int, show_after int, huobi varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateProjectData{
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"project.xml"];
    
    //NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            GDataXMLElement *idElement = [[risk elementsForName:@"id"] objectAtIndex:0];
            NSString *riskId = [idElement stringValue];
            GDataXMLElement *fatherIdElement = [[risk elementsForName:@"fatherId"] objectAtIndex:0];
            NSString *fatherId = [fatherIdElement stringValue];
            GDataXMLElement *titleElement = [[risk elementsForName:@"title"] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            GDataXMLElement *belongElement = [[risk elementsForName:@"belong_department"] objectAtIndex:0];
            NSString *belong = [belongElement stringValue];
            GDataXMLElement *remarkElement = [[risk elementsForName:@"remark"] objectAtIndex:0];
            NSString *remark = [remarkElement stringValue];
            GDataXMLElement *addDateElement = [[risk elementsForName:@"AddDate"] objectAtIndex:0];
            NSString *addDate = [addDateElement stringValue];
            GDataXMLElement *isUploadElement = [[risk elementsForName:@"isUpload"] objectAtIndex:0];
            NSString *isUpload = [isUploadElement stringValue];
            GDataXMLElement *isCompleteElement = [[risk elementsForName:@"isComplete"] objectAtIndex:0];
            NSString *isComplete = [isCompleteElement stringValue];
            GDataXMLElement *showCardElement = [[risk elementsForName:@"show_card"] objectAtIndex:0];
            NSString *showCard = [showCardElement stringValue];
            GDataXMLElement *showHotElement = [[risk elementsForName:@"show_hot"] objectAtIndex:0];
            NSString *showHot = [showHotElement stringValue];
            GDataXMLElement *showSortElement = [[risk elementsForName:@"show_sort"] objectAtIndex:0];
            NSString *showSort = [showSortElement stringValue];
            GDataXMLElement *showChengBenElement = [[risk elementsForName:@"show_chengben"] objectAtIndex:0];
            NSString *showChengBen = [showChengBenElement stringValue];
            GDataXMLElement *showStaticElement = [[risk elementsForName:@"show_static"] objectAtIndex:0];
            NSString *showStatic = [showStaticElement stringValue];
            GDataXMLElement *showAfterElement = [[risk elementsForName:@"show_after"] objectAtIndex:0];
            NSString *showAfter = [showAfterElement stringValue];
            GDataXMLElement *huobiElement = [[risk elementsForName:@"huobi"] objectAtIndex:0];
            NSString *huobi = [huobiElement stringValue];
            //NSLog(@"REPLACE INTO project(id, fatherid, title, belong_department, remark, AddDate, isUpload, isComplete, show_card, show_hot, show_sort, show_chengben, show_static, show_after) VALUES(%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@)", riskId, fatherId, title, belong, remark, addDate, isUpload, isComplete, showCard, showHot, showSort, showChengBen, showStatic, showAfter) ;
            [db executeUpdate:@"REPLACE INTO project(id, fatherid, title, belong_department, remark, AddDate, isUpload, isComplete, show_card, show_hot, show_sort, show_chengben, show_static, show_after, huobi) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" ,
             riskId, fatherId, title, belong, remark, addDate, isUpload, isComplete, showCard, showHot, showSort, showChengBen, showStatic, showAfter, huobi];
            //NSLog(@"UPDATE PROJECT %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    //插入到数据库中
    
}

+(void) checkProjectMapTable
{
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='projectMap'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table projectMap(id varchar(255) primary key, projectId varchar(255), objectId varchar(255), title varchar(255),positionX varchar(255), positionY varchar(255),width varchar(255), height varchar(255),isline varchar(255), picPng varchar(255),picEmz varchar(255),belongPage varchar(255), Obj_maptype varchar(255), Obj_belongwho varchar(255), Obj_remark varchar(255), Obj_db_id varchar(255), Obj_riskTypeStr varchar(255), Obj_other1 varchar(255), Obj_other2 varchar(255),Obj_data1 varchar(255),Obj_data2 varchar(255),Obj_data3 varchar(255),lineType varchar(255),lineType2 varchar(255),isDel varchar(255),linkPics varchar(255),cardPic varchar(255),fromWho varchar(255),toWho varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateProjectMapData{
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"projectMap.xml"];
    
    //NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
                [db executeUpdate:@"REPLACE INTO projectMap(id, projectId, objectId, title, positionX, positionY, width, height, isline, picPng, picEmz, belongPage, Obj_maptype, Obj_belongwho,Obj_remark,Obj_db_id,Obj_riskTypeStr,Obj_other1,Obj_other2,Obj_data1,Obj_data2,Obj_data3,lineType,lineType2,isDel,linkPics,cardPic,fromWho,toWho) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" ,
                         [[[risk elementsForName:@"id"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"projectId"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"objectId"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"title"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"positionX"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"positionY"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"width"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"height"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"isline"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"picPng"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"picEmz"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"belongPage"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_maptype"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_belongwho"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_remark"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_db_id"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_riskTypeStr"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_other1"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_other2"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_data1"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_data2"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"Obj_data3"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"lineType"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"lineType2"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"isDel"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"linkPics"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"cardPic"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"fromWho"] objectAtIndex:0] stringValue],
                         [[[risk elementsForName:@"toWho"] objectAtIndex:0] stringValue]
                         ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(void) checkRiskTable
{
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='risk'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table risk(id varchar(255) primary key, projectId varchar(255), pageDetailId varchar(255), riskTitle varchar(255),riskCode varchar(255), riskTypeId varchar(255),riskTypeStr varchar(255), pageId varchar(255), chanceVecorid varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateRiskData{
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"risk.xml"];
    
    //NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            [db executeUpdate:@"REPLACE INTO risk(id, projectId, pageDetailId, riskTitle, riskCode, riskTypeId, riskTypeStr, pageId) VALUES(?, ?, ?, ?, ?, ?, ?, ?)" ,
             [[[risk elementsForName:@"id"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"projectId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"pageDetailId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskTitle"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskCode"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskTypeId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskTypeStr"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"pageId"] objectAtIndex:0] stringValue]
             ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(void) checkProjectMatrixTable
{
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='projectMatrix'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table projectMatrix(id varchar(255) primary key, projectId varchar(255), matrix_title varchar(255), matrix_x varchar(255), matrix_y varchar(255),fatherid_matrix varchar(255), xIndex varchar(255), yIndex varchar(255), Color varchar(255), levelType varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateProjectMatrixData{
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"projectMatrix.xml"] ;
    
    NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            [db executeUpdate:@"REPLACE INTO projectMatrix(id, projectId, matrix_title, matrix_x, matrix_y, fatherid_matrix, xIndex, yIndex, Color, levelType) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" ,
             [[[risk elementsForName:@"id"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"projectId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"matrix_title"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"matrix_x"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"matrix_y"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"fatherid_matrix"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"xIndex"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"yIndex"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"Color"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"levelType"] objectAtIndex:0] stringValue]
             ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(void) checkProjectVectorDetailTable
{
    //NSLog(@"#### checkProjectVectorDetailTable");
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='projectVectorDetail'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table projectVectorDetail(id varchar(255) primary key, fatherid varchar(255), levelTitle varchar(255), score varchar(255),remarkTitle varchar(255), remarkContent varchar(255), theType varchar(255), projectId varchar(255), sort varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateProjectVectorDetailData{
    //NSLog(@"#### updateProjectVectorDetailData");
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"project_vectordetail.xml"] ;
    
    NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            [db executeUpdate:@"REPLACE INTO projectVectorDetail(id, fatherid, levelTitle, score, remarkTitle, remarkContent, theType, projectId, sort) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)" ,
             [[[risk elementsForName:@"id"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"fatherid"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"levelTitle"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"score"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"remarkTitle"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"remarkContent"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"theType"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"projectId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"sort"] objectAtIndex:0] stringValue]
             ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(void) checkProjectVectorTable
{
    //NSLog(@"#### checkProjectVectorDetailTable");
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='projectVector'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table projectVector(id varchar(255) primary key, title varchar(255), remark varchar(255), theType varchar(255), projectId varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateProjectVectorData{
    //NSLog(@"#### updateProjectVectorDetailData");
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"project_vector.xml"] ;
    
    NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            [db executeUpdate:@"REPLACE INTO projectVector(id, title, remark, theType, projectId) VALUES(?, ?, ?, ?, ?)" ,
             [[[risk elementsForName:@"id"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"title"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"remark"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"theType"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"projectId"] objectAtIndex:0] stringValue]
             ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(void) checkRiskScoreTable
{
    //NSLog(@"#### checkProjectVectorDetailTable");
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='riskScore'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table riskScore(id varchar(255) primary key, riskid varchar(255), scoreVectorId varchar(255), scoreBefore varchar(255),scoreEnd varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateRiskScoreData{
    //NSLog(@"#### updateProjectVectorDetailData");
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"risk_score.xml"];
    
    NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            [db executeUpdate:@"REPLACE INTO riskScore(id, riskid, scoreVectorId, scoreBefore, scoreEnd) VALUES(?, ?, ?, ?, ?)" ,
             [[[risk elementsForName:@"id"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskid"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"scoreVectorId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"scoreBefore"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"scoreEnd"] objectAtIndex:0] stringValue]
             ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(void) checkRiskCostTable
{
    //NSLog(@"#### checkProjectVectorDetailTable");
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='riskCost'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table riskCost(id varchar(255) primary key, riskName varchar(255), riskCode varchar(255), riskType varchar(255),beforeGailv varchar(255), beforeAffect varchar(255), beforeAffectQi varchar(255), manaChengben varchar(255), afterGailv varchar(255), afterAffect varchar(255), afterQi varchar(255), affectQi varchar(255), shouyi varchar(255), jingshouyi varchar(255), bilv varchar(255), projectId varchar(255), pageid varchar(255), riskvecorid varchar(255), chanceVecorid varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateRiskCostData{
    //NSLog(@"#### updateProjectVectorDetailData");
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"T_resultTemp.xml"] ;
    
    NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            [db executeUpdate:@"REPLACE INTO riskCost(id, riskName, riskCode, riskType, beforeGailv, beforeAffect, beforeAffectQi, manaChengben, afterGailv, afterAffect, afterQi, affectQi, shouyi, jingshouyi, bilv, projectId, pageid, riskvecorid, chanceVecorid) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" ,
             [[[risk elementsForName:@"ID"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskName"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskCode"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskType"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"beforeGailv"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"beforeAffect"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"beforeAffectQi"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"manaChengben"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"afterGailv"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"afterAffect"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"afterQi"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"affectQi"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"shouyi"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"jingshouyi"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"bilv"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"projectId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"pageid"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"riskvecorid"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"chanceVecorid"] objectAtIndex:0] stringValue]
             ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(void) checkDicTypeTable
{
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        int isExist = 0 ;
        
        // 判断表是否存在
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='dictype'"];
        while ([rs next]) {
            isExist = [rs intForColumn:@"count"] ;
        }
        
        // 如果没有创建表
        if(isExist == 0){
            [db executeUpdate:@"create table dictype(id varchar(255) primary key, fatherId varchar(255), title varchar(255), typeStr varchar(255), isDel varchar(255))"];
        }
        [db close];
        
    }else{
        NSLog(@"Could not open db.");
    }
}

+ (void)updateDicTypeData{
    //获取工程目录的xml文件
    NSString *filePath = [DBUtils findFilePath:@"dictype.xml"] ;
    
    //NSLog(@"%@", filePath) ;
    
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil] autorelease];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（User）
    NSArray *risks = [rootElement elementsForName:@"Risk"];
    
    FMDatabase* db = [DBUtils getFMDB] ;
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        for (GDataXMLElement *risk in risks) {
            [db executeUpdate:@"REPLACE INTO dictype(id, fatherId, title, typeStr, isDel) VALUES(?, ?, ?, ?, ?)" ,
             [[[risk elementsForName:@"id"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"fatherId"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"title"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"typeStr"] objectAtIndex:0] stringValue],
             [[[risk elementsForName:@"isDel"] objectAtIndex:0] stringValue]
             ];
            //NSLog(@"UPDATE PROJECTMAP %d", succ) ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
}

+(NSMutableArray *) getDirectory:(NSString *) fatherId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
    
        sql = [NSString stringWithFormat:@"SELECT id, fatherid, title from directory where fatherid = '%@'", fatherId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Directory *dir = [[Directory alloc] init] ;
            dir.dirId = [rs stringForColumn:@"id"] ;
            dir.fatherId = [rs stringForColumn:@"fatherid"] ;
            dir.title = [rs stringForColumn:@"title"] ;
            dir.isFile = NO ;
            [result addObject:dir] ;
            [dir release] ;
        }
        
        sql = [NSString stringWithFormat:@"SELECT id, fatherid, title from project where fatherid = '%@'", fatherId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        rs = [db executeQuery:sql];
        
        while ([rs next]) {
            Directory *dir = [[Directory alloc] init] ;
            dir.dirId = [rs stringForColumn:@"id"] ;
            dir.fatherId = [rs stringForColumn:@"fatherid"] ;
            dir.title = [rs stringForColumn:@"title"] ;
            dir.isFile = YES ;
            [result addObject:dir] ;
            [dir release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(NSMutableArray *) getProjectMap:(NSString *) projectId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, projectId, objectId, title, positionX, positionY, width, height, isline, picPng, picEmz, belongPage, Obj_maptype, Obj_belongwho,Obj_remark,Obj_db_id,Obj_riskTypeStr,Obj_other1,Obj_other2,Obj_data1,Obj_data2,Obj_data3,lineType,lineType2,isDel,linkPics, cardPic, fromWho, toWho from projectMap where projectId = '%@'", projectId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            ProjectMap *pm = [[ProjectMap alloc] init] ;
            pm.projectMapId = [rs stringForColumn:@"id"] ;
            pm.projectId = [rs stringForColumn:@"projectId"] ;
            pm.objectId = [rs stringForColumn:@"objectId"] ;
            pm.title = [rs stringForColumn:@"title"] ;
            pm.positionX = [[rs stringForColumn:@"positionX"] doubleValue];
            pm.positionY = [[rs stringForColumn:@"positionY"] doubleValue];
            pm.width = [[rs stringForColumn:@"width"] doubleValue];
            pm.height = [[rs stringForColumn:@"height"] doubleValue];
            pm.isline = [[rs stringForColumn:@"isline"] intValue];
            pm.picPng = [rs stringForColumn:@"picPng"] ;
            pm.picEmz = [rs stringForColumn:@"picEmz"] ;
            pm.belongPage = [rs stringForColumn:@"belongPage"] ;
            pm.Obj_maptype = [rs stringForColumn:@"Obj_maptype"] ;
            pm.Obj_belongwho = [rs stringForColumn:@"Obj_belongwho"] ;
            pm.Obj_remark = [rs stringForColumn:@"Obj_remark"] ;
            pm.Obj_db_id = [rs stringForColumn:@"Obj_db_id"] ;
            pm.Obj_riskTypeStr = [rs stringForColumn:@"Obj_riskTypeStr"] ;
            pm.Obj_other1 = [rs stringForColumn:@"Obj_other1"] ;
            pm.Obj_other2 = [rs stringForColumn:@"Obj_other2"] ;
            pm.Obj_data1 = [rs stringForColumn:@"Obj_data1"] ;
            pm.Obj_data2 = [rs stringForColumn:@"Obj_data2"] ;
            pm.Obj_data3 = [rs stringForColumn:@"Obj_data3"] ;
            pm.lineType = [[rs stringForColumn:@"lineType"] intValue];
            pm.lineType2 = [[rs stringForColumn:@"lineType2"] intValue];
            pm.isDel = [[rs stringForColumn:@"isDel"] intValue];
            pm.linkPics = [rs stringForColumn:@"linkPics"] ;
            pm.cardPic = [rs stringForColumn:@"cardPic"] ;
            pm.fromWho = [rs stringForColumn:@"fromWho"] ;
            pm.toWho = [rs stringForColumn:@"toWho"] ;
            [result addObject:pm] ;
            [pm release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(NSMutableArray *) getProject
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, title from project"] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            [rs stringForColumn:@"id"] ;
            Directory *dir = [[Directory alloc] init] ;
            dir.dirId = [rs stringForColumn:@"id"] ;
            dir.fatherId = @"0" ;
            dir.title = [rs stringForColumn:@"title"] ;
            dir.isFile = YES ;
            [result addObject:dir] ;
            [dir release] ;
        }
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(Project *) getProjectInfo:(NSString *) projectId
{
    
    Project *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, title, show_card, show_hot, show_sort, show_chengben, show_static, huobi from project where id = '%@'", projectId] ;
        
        NSLog(@"#### SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[Project alloc] init] autorelease];
        
        while ([rs next]) {
            result.projectId = [rs stringForColumn:@"id"] ;
            result.title = [rs stringForColumn:@"title"] ;
            result.show_cart = [rs intForColumn:@"show_cart"] ;
            result.show_hot = [rs intForColumn:@"show_hot"] ;
            result.show_sort = [rs intForColumn:@"show_sort"] ;
            result.show_chengben = [rs intForColumn:@"show_chengben"] ;
            result.show_static = [rs intForColumn:@"show_static"] ;
            result.huobi = [rs stringForColumn:@"huobi"] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(NSMutableArray *) getRisk:(NSString *) projectId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, projectId, pageDetailId, riskTitle, riskCode, riskTypeId, riskTypeStr, pageId from risk where projectId = '%@'", projectId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Risk *risk = [[Risk alloc] init] ;
            risk.riskId = [rs stringForColumn:@"id"] ;
            risk.projectId = [rs stringForColumn:@"projectId"] ;
            risk.pageDetailId = [rs stringForColumn:@"pageDetailId"] ;
            risk.riskTitle = [rs stringForColumn:@"riskTitle"] ;
            risk.riskCode = [rs stringForColumn:@"riskCode"];
            risk.riskTypeId = [rs stringForColumn:@"riskTypeId"];
            risk.riskTypeStr = [rs stringForColumn:@"riskTypeStr"];
            risk.pageId = [rs stringForColumn:@"pageId"];
            [result addObject:risk] ;
            [risk release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(NSString *) getRisk:(NSString *) projectId RiskId:(NSString *)riskId
{
    
    NSString *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT riskCode, riskTitle from risk where projectId = '%@' and id = '%@'", projectId, riskId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            result = [NSString stringWithFormat:@"%@ %@", [rs stringForColumn:@"riskCode"], [rs stringForColumn:@"riskTitle"]] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(NSMutableArray *) getRiskType:(NSString *) projectId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"select distinct r.riskTypeId as riskTypeId, d.title as title from risk r, dictype d where r.projectId = '%@' and r.riskTypeId = d.id;", projectId] ;
        
        NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Risk *risk = [[Risk alloc] init] ;
            risk.riskTypeId = [rs stringForColumn:@"riskTypeId"] ;
            risk.riskTitle = [rs stringForColumn:@"title"] ;
            [result addObject:risk] ;
            [risk release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}


//TODO 没有projectId
+(NSMutableArray *) getProjectMatrix:(NSString *) projectId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, projectId, matrix_title, matrix_x, matrix_y, fatherid_matrix, xIndex, yIndex, Color, levelType from projectMatrix"] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Matrix *matrix = [[Matrix alloc] init] ;
            matrix.matrixId = [rs stringForColumn:@"id"] ;
            matrix.projectId = [rs stringForColumn:@"projectId"] ;
            matrix.matrix_title = [rs stringForColumn:@"matrix_title"] ;
            matrix.matrix_x = [rs stringForColumn:@"matrix_x"] ;
            matrix.matrix_y = [rs stringForColumn:@"matrix_y"] ;
            matrix.fatherid_matrix = [rs stringForColumn:@"fatherid_matrix"];
            matrix.xIndex = [rs stringForColumn:@"xIndex"];
            matrix.yIndex = [rs stringForColumn:@"yIndex"];
            matrix.Color = [[rs stringForColumn:@"Color"] intValue];
            matrix.levelType = [rs stringForColumn:@"levelType"];
            [result addObject:matrix] ;
            [matrix release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(NSMutableArray *) getProjectMatrixTitle:(NSString *) projectId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT distinct matrix_title from projectMatrix where projectId='%@'", projectId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            [result addObject:[rs stringForColumn:@"matrix_title"]] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
}

+(NSMutableArray *) getProjectVectorDetail: (NSString *) fatherid
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, fatherid, levelTitle, score, remarkTitle, remarkContent, theType, projectId, sort from projectVectorDetail where fatherid = '%@' order by sort", fatherid] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            VectorDetail *vd = [[VectorDetail alloc] init] ;
            vd.detailId = [rs stringForColumn:@"id"] ;
            vd.fatherid = [rs stringForColumn:@"fatherid"] ;
            vd.levelTitle = [rs stringForColumn:@"levelTitle"] ;
            vd.score = [rs stringForColumn:@"score"] ;
            vd.remarkTitle = [rs stringForColumn:@"remarkTitle"];
            vd.remarkContent = [rs stringForColumn:@"remarkContent"];
            vd.theType = [rs stringForColumn:@"theType"];
            vd.projectId = [rs stringForColumn:@"projectId"];
            vd.sort = [rs stringForColumn:@"sort"];
            [result addObject:vd] ;
            [vd release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;

}

+(NSMutableArray *) getRiskScore: (NSString *) vectorId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, riskid, scoreVectorId, scoreBefore, scoreEnd from riskScore where scoreVectorId = '%@' order by riskid", vectorId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Score *score = [[Score alloc] init] ;
            score.scoreId = [rs stringForColumn:@"id"] ;
            score.riskid = [rs stringForColumn:@"riskid"] ;
            score.scoreVectorId = [rs stringForColumn:@"scoreVectorId"] ;
            score.scoreBefore = [[rs stringForColumn:@"scoreBefore"] doubleValue];
            score.scoreEnd = [[rs stringForColumn:@"scoreEnd"] doubleValue];
            [result addObject:score] ;
            [score release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
    
}

+(NSMutableArray *) getRiskCost: (NSString *) projectId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, riskName, riskCode, riskType, beforeGailv, beforeAffect, beforeAffectQi, manaChengben, afterGailv, afterAffect, afterQi, affectQi, shouyi, jingshouyi, bilv, projectId, pageid, riskvecorid, chanceVecorid from riskCost where projectId = '%@' order by id", projectId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Cost *cost = [[Cost alloc] init] ;
            cost.costId = [rs stringForColumn:@"id"] ;
            cost.riskName = [rs stringForColumn:@"riskName"] ;
            cost.riskCode = [rs stringForColumn:@"riskCode"] ;
            cost.riskType = [rs stringForColumn:@"riskType"] ;
            cost.beforeGailv = [[rs stringForColumn:@"beforeGailv"] doubleValue];
            cost.beforeAffect = [[rs stringForColumn:@"beforeAffect"] doubleValue];
            cost.beforeAffectQi = [[rs stringForColumn:@"beforeAffectQi"] doubleValue];
            cost.manaChengben = [[rs stringForColumn:@"manaChengben"] doubleValue];
            cost.afterGailv = [[rs stringForColumn:@"afterGailv"] doubleValue];
            cost.afterAffect = [[rs stringForColumn:@"afterAffect"] doubleValue];
            cost.afterQi = [[rs stringForColumn:@"afterQi"] doubleValue];
            cost.affectQi = [[rs stringForColumn:@"affectQi"] doubleValue];
            cost.shouyi = [[rs stringForColumn:@"shouyi"] doubleValue];
            cost.jingshouyi = [[rs stringForColumn:@"jingshouyi"] doubleValue];
            cost.bilv = [[rs stringForColumn:@"bilv"] doubleValue];
            cost.projectId = [rs stringForColumn:@"projectId"] ;
            cost.pageid = [rs stringForColumn:@"pageid"] ;
            cost.riskvecorid = [rs stringForColumn:@"riskvecorid"] ;
            cost.chanceVecorid = [rs stringForColumn:@"chanceVecorid"] ;
            [result addObject:cost] ;
            [cost release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
    
}

+(NSMutableArray *) getVector: (NSString *) projectId
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, title, remark, theType, projectId from projectVector where projectId = '%@' order by id", projectId] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Vector *vector = [[Vector alloc] init] ;
            vector.vectorId = [rs stringForColumn:@"id"] ;
            vector.title = [rs stringForColumn:@"title"] ;
            vector.remark = [rs stringForColumn:@"remark"] ;
            vector.theType = [rs stringForColumn:@"theType"] ;
            vector.projectId = [rs stringForColumn:@"projectId"] ;
            [result addObject:vector] ;
            [vector release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
    
}

+(NSMutableArray *) getDictype
{
    
    NSMutableArray *result = nil ;
    
    FMDatabase* db = [DBUtils getFMDB] ;
    
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //拼写SQL
        NSString *sql = nil ;
        
        sql = [NSString stringWithFormat:@"SELECT id, fatherId, title, typeStr, isDel from dictype order by id"] ;
        
        //NSLog(@"SQL: %@", sql) ;
        
        FMResultSet *rs = [db executeQuery:sql];
        
        result = [[[NSMutableArray alloc] init] autorelease];
        
        while ([rs next]) {
            Dictype *dictype = [[Dictype alloc] init] ;
            dictype.dictypeId = [rs stringForColumn:@"id"] ;
            dictype.fatherId = [rs stringForColumn:@"fatherId"] ;
            dictype.title = [rs stringForColumn:@"title"] ;
            dictype.typeStr = [rs stringForColumn:@"typeStr"] ;
            dictype.isDel = [[rs stringForColumn:@"isDel"] intValue];
            [result addObject:dictype] ;
            [dictype release] ;
        }
        
        [db close];
    }else{
        NSLog(@"Could not open db.");
    }
    
    return result ;
    
}

+(NSString *) findFilePath: (NSString *) filename
{
    NSString *str = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *unzipto = [str stringByAppendingPathComponent:@"projects"];
    
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
                                      enumeratorAtPath:unzipto];
    NSString *pname;
    
    while (pname = [direnum nextObject])
    {
        if([pname hasSuffix: filename] ||
           [pname hasSuffix: [filename uppercaseString]] ||
            [pname isEqualToString: filename] ||
            [[pname uppercaseString] isEqualToString: [filename uppercaseString]]){
            return [NSString stringWithFormat:@"%@/%@", unzipto, pname] ;
        }
    }

    return nil ;
}

@end

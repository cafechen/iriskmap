//
//  FileController.m
//  RiskMap
//
//  Created by steven on 13-8-5.
//  Copyright (c) 2013年 laka. All rights reserved.
//
#import "AppDelegate.h"
#import "FileController.h"
#import "Directory.h"
#import "DirectoryCell.h"
#import "ZipArchive.h"
#import "DBUtils.h"

@interface FileController ()

@end

@implementation FileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDirectory] ;
    // Do any additional setup after loading the view from its nib.
}

- (void) reloadFile
{
    [self loadDirectory] ;
    [self.dirTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) gotoInputPageButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoInputPage] ;
}

- (void) loadDirectory
{
    //NSArray *fileList = [[[NSFileManager defaultManager] directoryContentsAtPath:DOCUMENTS_FOLDER]
    //                     pathsMatchingExtensions:[NSArray arrayWithObject:@"risk"]] ;
    self.dirArray = [[[NSMutableArray alloc] init] autorelease] ;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *file = [path objectAtIndex:0]; //获得Document系统文件目录路径
    NSDirectoryEnumerator *direnum = [fileManager enumeratorAtPath:file ]; //遍历目录
    NSString *fileName;
    while((fileName = [direnum nextObject])){
        if([[fileName pathExtension] isEqualToString:@"risk"]){  //遍历条件
            Directory* dir = [[[Directory alloc] init] autorelease] ;
            dir.level = 1 ;
            dir.isOpen = YES ;
            dir.isFile = YES ;
            dir.title = fileName ;
            [self.dirArray addObject:dir] ;
            NSLog(@"%@",fileName);
        }  
    }
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    Directory *dir = [self.dirArray objectAtIndex:row] ;
    
    static NSString *TableSampleIdentifier = @"DirectoryCellIdentifier";
    
    DirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:
                           TableSampleIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DirectoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.isFile = dir.isFile;
    
    cell.isOpen = dir.isOpen;
    
    cell.level = dir.level;
    
    cell.directory = dir.title ;
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dirArray.count ;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    Directory *dir = [self.dirArray objectAtIndex:row] ;
    
    NSString *str = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *zipfile = [str stringByAppendingPathComponent:dir.title];
    
    NSString *unzipto = [str stringByAppendingPathComponent:@"projects"];
    
    NSString *dbfile = [str stringByAppendingPathComponent:@"riskmap.db"];
    
    //清空文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:unzipto error:nil];
    [fileManager removeItemAtPath:dbfile error:nil];
    
    ZipArchive *unzip = [[ZipArchive alloc] init];
    
    BOOL result;
    if([unzip UnzipOpenFile:zipfile]){
        result = [unzip UnzipFileTo:unzipto overWrite:YES];
        if(result){
            NSLog(@"解压成功");
            //初始化数据库
            [DBUtils initDB] ;
            //更新目录结构
            [DBUtils updateDirectory] ;
            [DBUtils updateProject] ;
            [DBUtils updateProjectMap];
            [DBUtils updateRisk] ;
            [DBUtils updateProjectMatrix] ;
            [DBUtils updateProjectVectorDetail] ;
            [DBUtils updateRiskScore] ;
            [DBUtils updateRiskCost] ;
            [DBUtils updateDictType] ;
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
            [appDelegate gotoMainPage] ;
        }else{
            NSLog(@"解压失败");
        }
    }
    
    return nil ;
}


@end

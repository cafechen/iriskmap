//
//  MainController.m
//  RiskMap
//
//  Created by Steven on 13-6-26.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "DirectoryCell.h"
#import "GDataXMLNode.h"
#import "DBUtils.h"
#import "Directory.h"

@interface MainController ()

@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取目录结构
    [self loadDirectory];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDirectory
{
    self.dirArray = [DBUtils getProject] ;
    for(int i = 0; i < self.dirArray.count; i++){
        Directory* dir = [self.dirArray objectAtIndex:i] ;
        dir.level = 1 ;
        dir.isOpen = NO ;
    }
}

- (IBAction) gotoLastPageButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoLastPage] ;
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
    //NSLog(@"######## %d", self.dirArray.count) ;
    return self.dirArray.count ;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showLoading];
    
    NSUInteger row = [indexPath row];
    
    return [self selectRow:row] ;
}

- (NSIndexPath *) selectRow: (int) row
{
    Directory *dir = [self.dirArray objectAtIndex:row] ;
    //首先判断是否是目录
    if(dir.isFile){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
        appDelegate.currProjectMap = [dir.dirId copy];
        [self hideLoading] ;
        [appDelegate gotoMapPage] ;
        return nil ;
    }else{
        //加载或者收起更多的目录
        if(dir.isOpen){
            //关闭子目录
            while(true){
                if(row < self.dirArray.count - 1){
                    Directory *nextDir = [self.dirArray objectAtIndex:(row + 1)] ;
                    if(nextDir.level <= dir.level){
                        dir.isOpen = NO ;
                        break ;
                    }else{
                        [self.dirArray removeObjectAtIndex:(row + 1)] ;
                    }
                }else{
                    dir.isOpen = NO ;
                    break ;
                }
            }
        }else{
            //打开子目录
            NSMutableArray *nextLevelArray = [DBUtils getDirectory:dir.dirId] ;
            //NSLog(@"######## %d", nextLevelArray.count) ;
            for(int i = 0; i < nextLevelArray.count; i++){
                Directory *nextDir = [nextLevelArray objectAtIndex:i] ;
                //NSLog(@"######## %@", nextDir.title) ;
                nextDir.level = dir.level + 1 ;
                nextDir.isOpen = NO ;
                [self.dirArray insertObject:nextDir atIndex:(row + i + 1)] ;
            }
            dir.isOpen = YES ;
        }
        [self.dirTableView reloadData] ;
    }
    [self hideLoading] ;
    return nil ;
}

-(void) showLoading
{
    [self.view addSubview:self.loadingView] ;
}

-(void) hideLoading
{
    [self.loadingView removeFromSuperview] ;
}


@end

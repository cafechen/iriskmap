//
//  RiskListController.m
//  RiskMap
//
//  Created by Steven on 13-7-9.
//  Copyright (c) 2013年 laka. All rights reserved.
//
#import "AppDelegate.h"
#import "RiskListController.h"
#import <QuartzCore/QuartzCore.h>
#import "RiskListCell.h"
#import "DBUtils.h"
#import "Risk.h"
#import "ProjectMap.h"
#import "RiskFactorCell.h"

@interface RiskListController ()

@end

@implementation RiskListController

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
    self.currTable = 0 ;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    self.riskArray = [DBUtils getRisk:appDelegate.currProjectMap] ;
    self.objectArray = [DBUtils getProjectMap:appDelegate.currProjectMap] ;
    self.factorArray = [[[NSMutableArray alloc] init] autorelease] ;
    self.targetArray = [[[NSMutableArray alloc] init] autorelease] ;
    for(int i = 0; i < self.objectArray.count; i++){
        ProjectMap *pm = [self.objectArray objectAtIndex:i] ;
        if([@"因素" isEqualToString:pm.Obj_maptype]){
            [self.factorArray addObject:pm];
        }
        if([@"目标" isEqualToString:pm.Obj_maptype]){
            [self.targetArray addObject:pm];
        }
    }
    self.riskTitleArray = [DBUtils getRiskType:appDelegate.currProjectMap] ;
    self.scrollView.contentSize = CGSizeMake(1024, ScreenHeight - 135) ;
    // Do any additional setup after loading the view from its nib.
    
    [self.segmentedControl addTarget:self
                              action:@selector(changeView:)
                    forControlEvents:UIControlEventValueChanged];
}

- (void) changeView:(id)sender
{
    self.currTable = self.segmentedControl.selectedSegmentIndex ;
    [self.tableView reloadData] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) gotoLastPageButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    [appDelegate gotoLastPage] ;
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0 ;
    switch (self.currTable) {
        case 0:{
            count = self.riskArray.count + 1 ;
            break;
        }
        case 1:
            count = self.factorArray.count + 1 ;
            break;
        case 2:
            count = self.targetArray.count + 1 ;
            break;
        default:
            break;
    }
    [self.totalLabel setText:[NSString stringWithFormat:@"总计:%d", count - 1]] ;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.currTable) {
        case 0:
            return [self tableView01:tableView cellForRowAtIndexPath:indexPath] ;
            break;
        case 1:
            return [self tableView02:tableView cellForRowAtIndexPath:indexPath] ;
            break;
        case 2:
            return [self tableView03:tableView cellForRowAtIndexPath:indexPath] ;
            break;
        default:
            break;
    }
    return nil ;
}


- (UITableViewCell *)tableView01:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    static NSString *TableSampleIdentifier = @"RiskListCellIdentifier";
    
    RiskListCell *cell = [tableView dequeueReusableCellWithIdentifier:
                        TableSampleIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RiskListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(row > 0){
        Risk *risk = (Risk *)[self.riskArray objectAtIndex:(row - 1)];
        //cell.riskType = risk.riskTypeId ;
        cell.riskTitle = risk.riskTitle ;
        for(int i = 0; i < self.riskTitleArray.count; i++){
            Risk *risk2 = [self.riskTitleArray objectAtIndex:i] ;
            if([risk2.riskTypeId isEqualToString:risk.riskTypeId]){
                cell.riskType = risk2.riskTitle ;
            }
        }
        cell.riskTypeStr = risk.riskTypeStr ;
        cell.riskCode = risk.riskCode ;
        cell.riskTitleLabel.textAlignment = UITextAlignmentLeft ;
        cell.riskTitleLabel.textColor = [UIColor blackColor];
        cell.riskCodeLabel.textColor = [UIColor blackColor];
        cell.riskTypeLabel.textColor = [UIColor blackColor];
        cell.riskTypeStrLabel.textColor = [UIColor blackColor];
    }
    
	return cell;
}

- (UITableViewCell *)tableView02:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    static NSString *TableSampleIdentifier = @"RiskFactorCellIdentifier";
    
    RiskFactorCell *cell = [tableView dequeueReusableCellWithIdentifier:
                          TableSampleIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RiskFactorCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(row > 0){
        ProjectMap *pm = (ProjectMap *)[self.factorArray objectAtIndex:(row - 1)];
        //cell.riskType = risk.riskTypeId ;
        cell.title = pm.title ;
        cell.type = pm.Obj_maptype ;
        cell.remark = pm.Obj_remark ;
        cell.titleLabel.textAlignment = UITextAlignmentLeft ;
        cell.remarkLabel.textAlignment = UITextAlignmentLeft ;
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.remarkLabel.textColor = [UIColor blackColor];
    }
    
	return cell;
}

- (UITableViewCell *)tableView03:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    static NSString *TableSampleIdentifier = @"RiskFactorCellIdentifier";
    
    RiskFactorCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            TableSampleIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RiskFactorCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(row > 0){
        ProjectMap *pm = (ProjectMap *)[self.targetArray objectAtIndex:(row - 1)];
        //cell.riskType = risk.riskTypeId ;
        cell.title = pm.title ;
        cell.type = pm.Obj_maptype ;
        cell.remark = pm.Obj_remark ;
        cell.titleLabel.textAlignment = UITextAlignmentLeft ;
        cell.remarkLabel.textAlignment = UITextAlignmentLeft ;
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.remarkLabel.textColor = [UIColor blackColor];
    }
    
	return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.currTable) {
        case 0:
            return [self tableView01:tableView willSelectRowAtIndexPath:indexPath];
            break;
        case 1:
            return [self tableView02:tableView willSelectRowAtIndexPath:indexPath];
            break;
        case 2:
            return [self tableView03:tableView willSelectRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
    return nil ;
}

- (NSIndexPath *)tableView01:(UITableView *)tableView
willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if(row > 0){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
        Risk *risk = [self.riskArray objectAtIndex:(row - 1)] ;
        appDelegate.currDBID = [risk.riskId copy] ;
        [appDelegate gotoLastMapPage] ;
    }
    return nil ;
}

- (NSIndexPath *)tableView02:(UITableView *)tableView
willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if(row > 0){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
        ProjectMap *pm = [self.factorArray objectAtIndex:(row -1)] ;
        appDelegate.currDBID = [pm.Obj_db_id copy] ;
        [appDelegate gotoLastMapPage] ;
    }
    return nil ;
}

- (NSIndexPath *)tableView03:(UITableView *)tableView
willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if(row > 0){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
        ProjectMap *pm = [self.targetArray objectAtIndex:(row -1)] ;
        appDelegate.currDBID = [pm.Obj_db_id copy] ;
        [appDelegate gotoLastMapPage] ;
    }
    return nil ;
}


@end

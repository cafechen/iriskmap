//
//  RiskListController.m
//  RiskMap
//
//  Created by Steven on 13-7-9.
//  Copyright (c) 2013年 laka. All rights reserved.
//
#import "AppDelegate.h"
#import "RiskListController.h"
#import "RiskListCell.h"
#import "DBUtils.h"
#import "Risk.h"

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    self.riskArray = [DBUtils getRisk:appDelegate.currProjectMap] ;
    self.searchArray = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 0; i < self.riskArray.count; i++){
        Risk *risk = [self.riskArray objectAtIndex:i] ;
        [self.searchArray addObject:risk] ;
    }
    self.riskTitleArray = [DBUtils getRiskType:appDelegate.currProjectMap] ;
    self.scrollView.contentSize = CGSizeMake(800, ScreenHeight - 135) ;
    // Do any additional setup after loading the view from its nib.
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
    return self.searchArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
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
        Risk *risk = (Risk *)[self.searchArray objectAtIndex:(row - 1)];
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing") ;
    return YES ;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing") ;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldEndEditing") ;
    return YES ;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing") ;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange") ;
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0)
{
    NSLog(@"shouldChangeTextInRange") ;
    if([text isEqualToString:@"\n"]){
        [self.searchArray removeAllObjects] ;
        for(int i = 0; i < self.riskArray.count; i++){
            Risk *risk = [self.riskArray objectAtIndex:i] ;
            if([risk.riskTitle rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].length > 0 ||
               [risk.riskTypeStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].length > 0 ||
               [risk.riskCode rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].length > 0 ||
               [risk.riskTypeId rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].length > 0){
                [self.searchArray addObject:risk] ;
            }
        }
        [searchBar resignFirstResponder];
        [self.tableView reloadData] ;
    }
    return YES ;
}

@end

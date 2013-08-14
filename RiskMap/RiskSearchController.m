//
//  RiskSearchController.m
//  RiskMap
//
//  Created by steven on 8/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "DBUtils.h"
#import "AppDelegate.h"
#import "RiskSearchController.h"
#import "RiskListCell.h"
#import "Risk.h"

@interface RiskSearchController ()

@end

@implementation RiskSearchController

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
    self.scrollView.contentSize = CGSizeMake(800, ScreenHeight - 135) ;
    self.riskTitleArray = [DBUtils getRiskType:appDelegate.currProjectMap] ;
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
    return self.riskArray.count + 1 ;
}\

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

@end

//
//  RiskCostController.m
//  RiskMap
//
//  Created by steven on 7/14/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "AppDelegate.h"
#import "DBUtils.h"
#import "RiskCostController.h"
#import "RiskCostCell.h"
#import "Cost.h"

@interface RiskCostController ()

@end

@implementation RiskCostController

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
    self.riskArray = [DBUtils getRiskCost] ;
    NSLog(@"#### %d", self.riskArray.count) ;
    self.scrollView.contentSize = CGSizeMake(1479, ScreenHeight - 135) ;
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
    return self.riskArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    static NSString *TableSampleIdentifier = @"RiskCostCellIdentifier";
    
    RiskCostCell *cell = [tableView dequeueReusableCellWithIdentifier:
                          TableSampleIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RiskCostCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(row > 0){
        Cost *cost = (Cost *)[self.riskArray objectAtIndex:(row - 1)];
        cell.costIdLabel.text = cost.costId ;
        cell.riskNameLabel.text = cost.riskName ;
        cell.riskCodeLabel.text = cost.riskCode ;
        cell.riskTypeLabel.text = cost.riskType ;
        cell.riskTypeLabel.text = [NSString stringWithFormat:@"%.2f", cost.beforeGailv] ;
        cell.beforeAffectLabel.text = [NSString stringWithFormat:@"%.2f", cost.beforeAffect] ;
        cell.beforeAffectQiLabel.text = [NSString stringWithFormat:@"%.2f", cost.beforeAffectQi] ;
        cell.manaChengbenLabel.text = [NSString stringWithFormat:@"%.2f", cost.manaChengben] ;
        cell.afterGailvLabel.text = [NSString stringWithFormat:@"%.2f", cost.afterGailv] ;
        cell.afterAffectLabel.text = [NSString stringWithFormat:@"%.2f", cost.afterAffect] ;
        cell.afterQiLabel.text = [NSString stringWithFormat:@"%.2f", cost.afterQi] ;
        cell.affectQiLabel.text = [NSString stringWithFormat:@"%.2f", cost.affectQi] ;
        cell.shouyiLabel.text = [NSString stringWithFormat:@"%.2f", cost.shouyi] ;
        cell.jingshouyiLabel.text = [NSString stringWithFormat:@"%.2f", cost.jingshouyi] ;
        cell.bilvLabel.text = [NSString stringWithFormat:@"%.2f", cost.bilv] ;
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

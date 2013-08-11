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
#import "Vector.h"

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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate] ;
    self.riskArray = [DBUtils getRiskCost:appDelegate.currProjectMap] ;
    self.vectorArray = [DBUtils getVector:appDelegate.currProjectMap] ;
    
    self.leftArray = [[[NSMutableArray alloc] init] autorelease] ;
    self.rightArray = [[[NSMutableArray alloc] init] autorelease] ;
    
    self.currLeft = -1 ;
    self.currRight = -1 ;
    
    self.filter = @"" ;
    
    for(int i = 0; i < self.vectorArray.count; i++){
        Vector *v = [self.vectorArray objectAtIndex:i] ;
        for(int j = 0; j < self.riskArray.count; j++){
            Cost *cost = [self.riskArray objectAtIndex:j] ;
            if([v.vectorId isEqualToString:cost.riskvecorid]){
                [self.leftArray addObject:v] ;
                break ;
            }
        }
    }
    
    for(int i = 0; i < self.vectorArray.count; i++){
        Vector *v = [self.vectorArray objectAtIndex:i] ;
        for(int j = 0; j < self.riskArray.count; j++){
            Cost *cost = [self.riskArray objectAtIndex:j] ;
            if([v.vectorId isEqualToString:cost.chanceVecorid]){
                [self.rightArray addObject:v] ;
                break ;
            }
        }
    }
    
    self.tableArray = [[[NSMutableArray alloc] init] autorelease] ;
    if(self.leftArray.count > 0){
        Vector *v = [self.leftArray objectAtIndex:0] ;
        for(int i = 0; i < self.riskArray.count; i++){
            Cost *cost = [self.riskArray objectAtIndex:i] ;
            if([cost.riskvecorid isEqualToString:v.vectorId]){
                [self.tableArray addObject:cost] ;
            }
        }
        self.leftLabel.text = v.title ;
        self.currLeft = 0 ;
    }
    
    if(self.rightArray.count > 0){
        Vector *v = [self.rightArray objectAtIndex:0] ;
        for(int i = 0; i < self.riskArray.count; i++){
            Cost *cost = [self.riskArray objectAtIndex:i] ;
            if([cost.riskvecorid isEqualToString:v.vectorId]){
                [self.tableArray addObject:cost] ;
            }
        }
        self.rightLabel.text = v.title ;
        self.currLeft = 1 ;
    }
    
    NSLog(@"####4343 %d %d", self.leftArray.count, self.rightArray.count) ;
    self.scrollView.contentSize = CGSizeMake(1549, ScreenHeight - 135) ;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) showLeftAction:(id)sender
{
    self.whichChange = 0 ;
    //获取权限列表
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择威胁概率的顺序量表"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil] ;
    for(int i = 0; i < self.leftArray.count; i++){
        Vector *v = [self.leftArray objectAtIndex:i] ;
        [actionSheet addButtonWithTitle:v.title] ;
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction) showRightAction:(id)sender
{
    self.whichChange = 1 ;
    //获取权限列表
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择机会概率的顺序量表"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil] ;
    for(int i = 0; i < self.rightArray.count; i++){
        Vector *v = [self.rightArray objectAtIndex:i] ;
        [actionSheet addButtonWithTitle:v.title] ;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
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
    return self.tableArray.count + 1;
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
        Cost *cost = (Cost *)[self.tableArray objectAtIndex:(row - 1)];
        cell.riskNameLabel.text = cost.riskName ;
        cell.riskCodeLabel.text = cost.riskCode ;
        cell.riskTypeLabel.text = cost.riskType ;
        cell.beforeGailvLabel.text = [NSString stringWithFormat:@"%.2f", cost.beforeGailv] ;
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

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 0)
        return ;
    if(self.whichChange == 0){
        self.currLeft = buttonIndex ;
    }else{
        self.currRight = buttonIndex ;
    }
    [self reloadTable:nil] ;
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
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
    [self reloadTable:searchBar.text] ;
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
        [searchBar resignFirstResponder];
        [self reloadTable:searchBar.text] ;
    }
    return YES ;
}

-(void) reloadTable:(NSString *) filter
{
    if(filter != nil){
        self.filter = [filter copy] ;
    }
    [self.tableArray removeAllObjects] ;
    if(self.leftArray.count > 0){
        Vector *v = [self.leftArray objectAtIndex:self.currLeft] ;
        for(int i = 0; i < self.riskArray.count; i++){
            Cost *cost = [self.riskArray objectAtIndex:i] ;
            if([cost.riskvecorid isEqualToString:v.vectorId]){
                if([@"" isEqualToString:self.filter]|| [cost.riskName rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [cost.riskCode rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [cost.riskType rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.beforeGailv] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.beforeAffect]rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.beforeAffectQi] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.manaChengben] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.afterGailv] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.afterQi] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.affectQi] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.shouyi] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.jingshouyi] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0 ||
                   [[NSString stringWithFormat:@"%.2f", cost.bilv] rangeOfString:self.filter options:NSCaseInsensitiveSearch].length > 0)
                [self.tableArray addObject:cost] ;
            }
            self.leftLabel.text = v.title ;
        }
    }
    if(self.rightArray.count > 0){
        Vector *v = [self.rightArray objectAtIndex:self.currRight] ;
        for(int i = 0; i < self.riskArray.count; i++){
            Cost *cost = [self.riskArray objectAtIndex:i] ;
            if([cost.riskvecorid isEqualToString:v.vectorId]){
                [self.tableArray addObject:cost] ;
            }
            self.rightLabel.text = v.title ;
        }
    }
    [self.tableView reloadData] ;
}
@end

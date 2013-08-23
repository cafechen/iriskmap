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
            if([cost.chanceVecorid isEqualToString:v.vectorId]){
                [self.tableArray addObject:cost] ;
            }
        }
        self.rightLabel.text = v.title ;
        self.currRight = 0 ;
    }
    
    [self addTotally];
    
    NSLog(@"####4343 %d %d", self.leftArray.count, self.rightArray.count) ;
    self.scrollView.contentSize = CGSizeMake(1549, ScreenHeight - 135) ;
    // Do any additional setup after loading the view from its nib.
}

- (void)addTotally
{
    Cost *total = [[[Cost alloc] init] autorelease] ;
    total.riskName = @"总计" ;
    total.riskCode = @"-" ;
    total.riskType = @"-" ;
    for(int i = 0; i < self.tableArray.count; i++){
        Cost *cost = [self.tableArray objectAtIndex:i] ;
        total.beforeGailv = total.beforeGailv  + cost.beforeGailv ;
        total.beforeAffect = total.beforeAffect  + cost.beforeAffect ;
        total.beforeAffectQi = total.beforeAffectQi  + cost.beforeAffectQi ;
        total.manaChengben = total.manaChengben  + cost.manaChengben ;
        total.afterGailv = total.afterGailv  + cost.afterGailv ;
        total.afterAffect = total.afterAffect  + cost.afterAffect ;
        total.afterQi = total.afterQi  + cost.afterQi ;
        total.affectQi = total.affectQi  + cost.affectQi ;
        total.shouyi = total.shouyi  + cost.shouyi ;
        total.jingshouyi = total.jingshouyi  + cost.jingshouyi ;
        total.bilv = total.bilv  + cost.bilv ;
    }
    
    [self.tableArray addObject:total] ;
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
    
    if(self.leftArray.count == 0){
        [actionSheet addButtonWithTitle:@"返回"] ;
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
    
    if(self.rightArray.count == 0){
        [actionSheet addButtonWithTitle:@"返回"] ;
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
    [self.totalLabel setText:[NSString stringWithFormat:@"总计:%d", self.tableArray.count]] ;
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
        cell.riskNameLabel.textColor = [UIColor blackColor] ;
        cell.riskCodeLabel.text = cost.riskCode ;
        cell.riskCodeLabel.textColor = [UIColor blackColor] ;
        cell.riskTypeLabel.text = cost.riskType ;
        cell.riskTypeLabel.textColor = [UIColor blackColor] ;
        NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];
        cell.beforeGailvLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.beforeGailv]] ;
        cell.beforeGailvLabel.textColor = [UIColor blackColor] ;
        cell.beforeAffectLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.beforeAffect]] ;
        cell.beforeAffectLabel.textColor = [UIColor blackColor] ;
        cell.beforeAffectQiLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.beforeAffectQi]] ;
        cell.beforeAffectQiLabel.textColor = [UIColor blackColor] ;
        cell.manaChengbenLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.manaChengben]] ;
        cell.manaChengbenLabel.textColor = [UIColor blackColor] ;
        cell.afterGailvLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.afterGailv]] ;
        cell.afterGailvLabel.textColor = [UIColor blackColor] ;
        cell.afterAffectLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.afterAffect]] ;
        cell.afterAffectLabel.textColor = [UIColor blackColor] ;
        cell.afterQiLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.afterQi]] ;
        cell.afterQiLabel.textColor = [UIColor blackColor] ;
        cell.affectQiLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.affectQi]] ;
        cell.affectQiLabel.textColor = [UIColor blackColor] ;
        cell.shouyiLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.shouyi]] ;
        cell.shouyiLabel.textColor = [UIColor blackColor] ;
        cell.jingshouyiLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.jingshouyi]] ;
        cell.jingshouyiLabel.textColor = [UIColor blackColor] ;
        cell.bilvLabel.text = [numberFormatter stringFromNumber: [NSNumber numberWithDouble: cost.bilv]] ;
        cell.bilvLabel.textColor = [UIColor blackColor] ;
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
    NSLog(@"#### #### #### %d", buttonIndex) ;
    if(buttonIndex < 0 || [@"返回" isEqualToString: actionSheet.title])
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
    [self.scrollView setUserInteractionEnabled:NO];
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
        NSLog(@"#### #### ####111 %d %d", self.currLeft, self.leftArray.count) ;
        Vector *v = [self.leftArray objectAtIndex:self.currLeft] ;
        NSLog(@"#### #### ####111 %@", v.vectorId) ;
        for(int i = 0; i < self.riskArray.count; i++){
            Cost *cost = [self.riskArray objectAtIndex:i] ;
            NSLog(@"#### #### ####111 %@ %@", cost.riskvecorid, v.vectorId) ;
            if([cost.riskvecorid isEqualToString:v.vectorId]){
                NSLog(@"#### #### ####111 111 %@ %@", cost.riskvecorid, v.vectorId) ;
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
        NSLog(@"#### #### ####222 %d %d", self.currRight, self.rightArray.count) ;
        Vector *v = [self.rightArray objectAtIndex:self.currRight] ;
        NSLog(@"#### #### ####222 %d %d", self.currRight, self.rightArray.count) ;
        for(int i = 0; i < self.riskArray.count; i++){
            Cost *cost = [self.riskArray objectAtIndex:i] ;
            if([cost.chanceVecorid isEqualToString:v.vectorId]){
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
            self.rightLabel.text = v.title ;
        }
    }
    
    [self addTotally];

    [self.tableView reloadData] ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar)
    {
        [self.scrollView setUserInteractionEnabled:YES];
        [self.searchBar resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end

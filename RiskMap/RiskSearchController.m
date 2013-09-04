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
#import "Dictype.h"
#import "Vector.h"
#import "Score.h"

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
    NSMutableArray *allArray = [DBUtils getDictype] ;
    self.dictArray = [[[NSMutableArray alloc] init] autorelease] ;
    for(int i = 0; i < allArray.count; i++){
        Dictype *type = [allArray objectAtIndex:i] ;
        if([@"风险" isEqualToString:type.typeStr] && [@"0" isEqualToString:type.fatherId]){
            [self.dictArray addObject:type] ;
        }
    }
    self.currRiskType = 0 ;
    self.currVector = 0 ;
    self.currManage = 0 ;
    self.currRange = 0 ;
    self.currScore = 0.0 ;
    
    self.matrixArray = [DBUtils getProjectMatrix:appDelegate.currProjectMap] ;
    self.vectorArray = [DBUtils getVector:appDelegate.currProjectMap] ;
    self.riskArray = [DBUtils getRisk:appDelegate.currProjectMap] ;
    self.searchRiskArray = [[[NSMutableArray alloc] init] autorelease] ;
    for(int i = 0; i < self.riskArray.count; i++){
        Risk *r = [self.riskArray objectAtIndex:i] ;
        [self.searchRiskArray addObject:r] ;
    }
    self.totalLabel.text = [NSString stringWithFormat:@"总计:%d", self.searchRiskArray.count] ;
    self.scrollView.contentSize = CGSizeMake(1024, ScreenHeight - 135) ;
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

- (IBAction) showRiskType:(id) sender
{
    self.currButton = 0 ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil, nil] ;
    NSLog(@"#### %d", self.dictArray.count) ;
    [actionSheet addButtonWithTitle:@"全部分类"] ;
    for(int i = 0; i < self.dictArray.count; i++){
        Dictype *type = [self.dictArray objectAtIndex:i] ;
        [actionSheet addButtonWithTitle:type.title] ;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction) showVector:(id) sender
{
    self.currButton = 1 ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil, nil] ;
    NSLog(@"#### %d", self.vectorArray.count) ;
    [actionSheet addButtonWithTitle:@"全部量表"] ;
    for(int m = 0; m < self.vectorArray.count; m++){
        Vector *v = [self.vectorArray objectAtIndex:m] ;
       [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@-%@", v.title, v.theType]] ;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction) showManage:(id) sender
{
    self.currButton = 2 ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"管理前风险评分", @"管理后风险评分",@"管理前风险影响", @"管理后风险影响", nil] ;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction) showRange:(id) sender
{
    self.currButton = 3 ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@">=", @"<=", nil] ;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction) search:(id) sender
{
    //先清空
    [self.searchRiskArray removeAllObjects] ;
    for(int i = 0; i < self.riskArray.count; i++){
        Risk *risk = [self.riskArray objectAtIndex:i] ;
        //逐条过滤
        //1 风险分类
        if(self.currRiskType != 0){
            //这时候需要看看是否是该类别
            Dictype *dict = [self.dictArray objectAtIndex:(self.currRiskType - 1)] ;
            if(![dict.dictypeId isEqualToString:risk.riskTypeId])
                continue ;
        }
        
        //2 顺序量表
        BOOL isAdd = NO ;
        if(self.currVector == 0){
            for(int i = 0; i < self.vectorArray.count; i++){
                Vector *v = [self.vectorArray objectAtIndex:i] ;
                NSMutableArray *riskScoreArray = [DBUtils getRiskScore:v.vectorId] ;
                NSLog(@"#### riskScoreArray %d %f", riskScoreArray.count, self.currScore) ;
                for(int j = 0; j < riskScoreArray.count; j++){
                    Score *score = [riskScoreArray objectAtIndex:j] ;
                    if([score.riskid isEqualToString:risk.riskId]){
                    if(self.currManage == 0){
                        //管理前
                        if(score.scoreBefore >= [self.rangeFieldSmail.text floatValue] &&
                           score.scoreBefore <= [self.rangeFieldBig.text floatValue]){
                            isAdd = YES ;
                        }
                    }else{
                        //管理后
                        if(score.scoreEnd >= [self.rangeFieldSmail.text floatValue] &&
                           score.scoreEnd <= [self.rangeFieldBig.text floatValue]){
                            isAdd = YES ;
                        }
                    }
                    }
                }
            }
        }else{
            Vector *v = [self.vectorArray objectAtIndex:(self.currVector - 1)] ;
            NSMutableArray *riskScoreArray = [DBUtils getRiskScore:v.vectorId] ;
            NSLog(@"#### riskScoreArray %d", riskScoreArray.count) ;
            for(int j = 0; j < riskScoreArray.count; j++){
                Score *score = [riskScoreArray objectAtIndex:j] ;
                if([score.riskid isEqualToString:risk.riskId]){
                    if(self.currManage == 0){
                        //管理前
                        if(score.scoreBefore >= [self.rangeFieldSmail.text floatValue] &&
                           score.scoreBefore <= [self.rangeFieldBig.text floatValue]){
                            isAdd = YES ;
                        }
                    }else{
                        //管理后
                        if(score.scoreEnd >= [self.rangeFieldSmail.text floatValue] &&
                           score.scoreEnd <= [self.rangeFieldBig.text floatValue]){
                            isAdd = YES ;
                        }
                    }
                }
            }

        }
        if(isAdd){
            [self.searchRiskArray addObject:risk] ;
        }
    }
    self.totalLabel.text = [NSString stringWithFormat:@"总计:%d", self.searchRiskArray.count] ;
    [self.tableView reloadData] ;
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 0){
        return ;
    }
    switch (self.currButton) {
        case 0:{
            self.currRiskType = buttonIndex ;
            if(self.currRiskType == 0){
                self.riskTypeLabel.text = @"全部分类" ;
            }else{
                Dictype *type = [self.dictArray objectAtIndex:(buttonIndex - 1)] ;
                self.riskTypeLabel.text = type.title ;
            }
            break;
        }
        case 1:{
            self.currVector = buttonIndex ;
            if(self.currVector == 0){
                self.riskVectorLabel.text = @"全部量表" ;
            }else{
                Vector *v = [self.vectorArray objectAtIndex:(buttonIndex - 1)] ;
                self.riskVectorLabel.text = [NSString stringWithFormat:@"%@-%@", v.title, v.theType] ;
            }
            break ;
        }
        case 2:{
            self.currManage = buttonIndex ;
            NSLog(@"#### self.currManage=%d", self.currManage) ;
            if(self.currManage == 0){
                [self.manageButton setTitle:@"管理前风险评分" forState:UIControlStateNormal] ;
            }else if(self.currManage == 1){
                [self.manageButton setTitle:@"管理后风险评分" forState:UIControlStateNormal] ;
            }else if(self.currManage == 2){
                [self.manageButton setTitle:@"管理前风险影响" forState:UIControlStateNormal] ;
            }else if(self.currManage == 3){
                [self.manageButton setTitle:@"管理后风险影响" forState:UIControlStateNormal] ;
            }
            break ;
        }
        case 3:{
            self.currRange = buttonIndex ;
            if(self.currRange == 0){
                [self.rangeButton setTitle:@">=" forState:UIControlStateNormal] ;
            }else{
                [self.rangeButton setTitle:@"<=" forState:UIControlStateNormal] ;
            }
            break ;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchRiskArray.count + 1 ;
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
        Risk *risk = (Risk *)[self.searchRiskArray objectAtIndex:(row - 1)];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil ;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (void)keyboardWillShow:(NSNotification *)noti
{
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.currScore = [textField.text floatValue] ;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField
{
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
}

-(BOOL)textField:(UITextField *)theTextField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        self.currScore = [theTextField.text floatValue] ;
        [theTextField resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.rangeFieldSmail isFirstResponder] && [touch view] != self.rangeFieldSmail) {
        [self.rangeFieldSmail resignFirstResponder];
    }
    if ([self.rangeFieldBig isFirstResponder] && [touch view] != self.rangeFieldBig) {
        [self.rangeFieldBig resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end

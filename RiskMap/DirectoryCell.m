//
//  DirectoryCell.m
//  RiskMap
//
//  Created by steven on 6/20/13.
//  Copyright (c) 2013 laka. All rights reserved.
//

#import "DirectoryCell.h"

@implementation DirectoryCell

@synthesize directory;
@synthesize isOpen;
@synthesize isFile;
@synthesize level;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void) setIsOpen:(BOOL)open
{
    isOpen = open ;
    if(self.isOpen){
        [self.dirImageView setImage:[UIImage imageNamed:@"Glass_Folder_002.png"]] ;
    }else{
        [self.dirImageView setImage:[UIImage imageNamed:@"Glass_Folder_001.png"]] ;
    }
    if(self.isFile){
        [self.dirImageView setImage:[UIImage imageNamed:@"Glass_Folder_003.png"]] ;
    }
}

-(void) setIsFile:(BOOL)file
{
    isFile = file ;
    if(self.isFile){
        [self.dirImageView setImage:[UIImage imageNamed:@"Glass_Folder_003.png"]] ;
    }
}

-(void) setLevel:(int)l{
    int offset = (l - 1)*20 ;
    self.dirImageView.frame = CGRectMake(5 + offset, 5, 33, 33) ;
    self.directoryLabel.frame = CGRectMake(46 + offset , 12, 254 - offset, 20) ;
}

-(void)setDirectory:(NSString *) dir {
    if (![dir isEqualToString:directory]) {
        directory = [dir copy];
        self.directoryLabel.text = directory;
    }
}

@end

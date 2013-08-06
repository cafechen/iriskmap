//
//  InputController.h
//  RiskMap
//
//  Created by steven on 13-8-5.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"

@interface InputController : UIViewController <WebFileResourceDelegate> {
	IBOutlet UILabel *urlLabel;
	HTTPServer *httpServer;
	NSMutableArray *fileList;
}

- (IBAction)toggleService:(id)sender;
@end

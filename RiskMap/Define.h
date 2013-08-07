//
//  Define.h
//  RiskMap
//
//  Created by steven on 13-6-29.
//  Copyright (c) 2013年 laka. All rights reserved.
//

#ifndef RiskMap_Define_h
#define RiskMap_Define_h
#define StateBarHeight 20
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ScreenHeight (isIpad?[[UIScreen mainScreen] bounds].size.width:[[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth (isIpad?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)
#define MainHeight (ScreenHeight - StateBarHeight)
#define MainWidth ScreenWidth
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#endif

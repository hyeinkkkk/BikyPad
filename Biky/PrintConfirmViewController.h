//
//  PrintConfirmViewController.h
//  Biky
//
//  Created by Hyein on 2015. 7. 10..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintConfirmViewController : UIViewController
@property NSString * action;
@property NSMutableDictionary * data;
@property NSDictionary * player;
@property NSString * barcode;
@property NSUInteger awardCount;

@end

//
//  CreateIDViewController.h
//  Biky
//
//  Created by Hyein on 2015. 7. 1..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateIDViewController : UIViewController
@property (nonatomic,retain) IBOutlet UILabel *serialText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property NSString *barcode;
@end

//
//  PhotoViewController.h
//  Biky
//
//  Created by Hyein on 2015. 6. 22..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXPrinterController.h"
#import "BXPrinterControlDelegate.h"
#import <WebKit/WebKit.h>

@interface PhotoViewController : UIViewController < UIImagePickerControllerDelegate, UINavigationControllerDelegate, BXPrinterControlDelegate >
{
    BXPrinterController* _pController;
    BXPrinter * _printer;
}
- (IBAction)takePhoto :(UIButton *)sender;
- (IBAction)selectPhoto :(UIButton *)sender;

@end

//
//  SignViewController.h
//  Biky
//
//  Created by Hyein on 2015. 6. 23..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJRSignatureView.h"
#import "BXPrinterController.h"
#import "BXPrinterControlDelegate.h"

@interface SignViewController : UIViewController<BXPrinterControlDelegate>{
    PJRSignatureView *signatureView;
    BXPrinterController* _pController;
    BXPrinter * _printer;
    __weak IBOutlet UILabel *testLabel;

}

@end

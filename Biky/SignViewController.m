//
//  SignViewController.m
//  Biky
//
//  Created by Hyein on 2015. 6. 23..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "SignViewController.h"
#import "BXPrinterControlDelegate.h"
#import "BXPrinterController.h"


@interface SignViewController ()

@end

@implementation SignViewController

- (void)didFindPrinter:(BXPrinterController *)controller printer:(BXPrinter *)printer {
    NSLog(@"found printer");
    
}

- (void)msrArrived:(BXPrinterController *)controller track:(NSNumber *)track {
    NSLog(@"msr arrived");
}

- (IBAction)clearView:(id)sender {
    [signatureView clearSignature];
}
- (IBAction)printImage:(id)sender {
    
    UIImage *img = [self imageWithView:self.view];
    NSLog(@"img %@",img);
    
    [_pController lineFeed:1];
    [_pController printBitmapWithImage:img width:BXL_WIDTH_FULL level:50];
    [_pController lineFeed:5];
    NSLog(@"print completed!");
    
}

-(void) printerInitialize
{
    NSLog(@"printerInit??");
    _pController = [BXPrinterController getInstance];
    _pController.delegate       = self;
    _pController.lookupCount    = 5;
    _pController.AutoConnection = BXL_CONNECTIONMODE_NOAUTO;
    
    [_pController open];
    
    _printer = [BXPrinter new];
    
    _printer.macAddress = @"74:F0:7D:E2:23:4C";
    _printer.connectionClass = BXL_CONNECTIONCLASS_BT;
    
//    _printer.address = [NSString stringWithFormat:@"192.168.1.41"];
//    _printer.port = 9100;
//    _printer.connectionClass = BXL_CONNECTIONCLASS_ETHERNET;
    
    NSLog(@"printer %@", _printer);
    NSLog(@" pCtl %@",_pController);
    
    _pController.target = _printer;
    [_pController selectTarget];
    
    if( NO==[_pController connect] )
        NSLog(@"Connect Error");
    
    _pController.textEncoding = BXL_TEXTENCODING_KSC5601;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
    
//    if (BXL_SUCCESS == [_pController printText:@"TEST"]) {
//        NSLog(@"print ??");
//        [_pController lineFeed:1];
//    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Signature";
    _pController = [BXPrinterController getInstance];
    [self printerInitialize];
    
//    NSProcessInfo *proc = [NSProcessInfo processInfo];
//    NSArray *args = [proc arguments];
//    //실행 시킬 경로를 알아보기 위해
//    NSLog(@"%@",args);
//    
//    NSFileHandle *readFile;
//    
//    readFile = [NSFileHandle fileHandleForReadingAtPath:@"test.txt"];
//    if(readFile == nil)
//    {
//        NSLog(@"fail to read file");
//        return;
//    }
//    
//    NSData *data = [readFile readDataToEndOfFile];
//    NSString* text = [[NSString alloc] initWithData: data
//                                           encoding: NSUTF8StringEncoding];
//    NSLog(@"%@", text);
//    [readFile closeFile];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    signatureView= [[PJRSignatureView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-200)];
//    [signatureView createLableView:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-200)];
    [self.view addSubview:signatureView];
    
    
}

- (UIImage *) imageWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

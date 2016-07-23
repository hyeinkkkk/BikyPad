//
//  MovieIntroViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 9..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "MovieIntroViewController.h"
#import "BarcodeScanViewController.h"
#import "DateListViewController.h"
#import "HTTPClient.h"
#import "Constants.h"


@interface MovieIntroViewController ()

@end

@implementation MovieIntroViewController{
    NSString *_barcode;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT");
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goDateList:) name:DateListNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) goDateList:(NSNotification *)noti{
    NSLog(@"다음 페이지? %@",noti);
    _barcode = noti.userInfo[@"barcode"];
    HTTPClient * client = [HTTPClient httpClient];
    [client barcode:_barcode getPlayerByBarcodeWithCallback:^(id response) {
        if([response isEqual:@"none"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:@"플레이어가 존재하지 않습니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        }
        else{
            [self performSegueWithIdentifier:@"DateList" sender:nil];
        }
    }];
    
    
}

- (IBAction)unwindMovieIntro:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier %@",segue.identifier);
}
- (IBAction)clickedHome:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController * initialViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    initialViewController.navigationBarHidden = YES;
    self.view.window.rootViewController = initialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)ClickedInputButton:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BarcodeScanViewController *barcodeController = [mainStoryboard instantiateViewControllerWithIdentifier:@"BarcodeScanViewController"];
//    barcodeController.data = self.selectedSession;
    barcodeController.action = @"movie";
    [self presentViewController:barcodeController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"DateList"]){
        DateListViewController *dest = (DateListViewController *) segue.destinationViewController;
        dest.barcode = _barcode;
    }
}


@end

//
//  FloorPlayTitleViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 10..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "FloorPlayTitleViewController.h"
#import "BarcodeScanViewController.h"
#import "FloorPlayResultViewController.h"
#import "HTTPClient.h"
#import "Constants.h"

@interface FloorPlayTitleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *floorPlayLabel;

@end

@implementation FloorPlayTitleViewController
- (IBAction)clickedInputButton:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BarcodeScanViewController *barcodeController = [mainStoryboard instantiateViewControllerWithIdentifier:@"BarcodeScanViewController"];
//    barcodeController.data = self.floorPlay;
    barcodeController.action = @"floor_play";
    [self presentViewController:barcodeController animated:YES completion:nil];

}

- (IBAction)unwindFloorPlayTitle:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier %@",segue.identifier);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT");
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goResultView:) name:FloorPlayListNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) goResultView:(NSNotification *)noti{
    NSLog(@"다음 페이지? %@",noti);
    //    _barcode = noti.userInfo[@"barcode"];
    HTTPClient *client = [HTTPClient httpClient];
    
    [client barcode:noti.userInfo[@"barcode"] getPlayerByBarcodeWithCallback:^(id response) {
        if([response isEqual:@"none"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:@"플레이어가 존재하지 않습니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            [alertView show];
        }
        else{
            [client floorId:self.floorPlay[@"_id"] barcode: noti.userInfo[@"barcode"] createPlayerActivityWithCallback:^(id response) {
                if([response isEqual:@"full"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                        message:@"이미 모든 카드를 획득하셨습니다."
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles: nil];
                    [alertView show];

                }
                else{
                    [self performSegueWithIdentifier:@"FloorPlayResult" sender:response];
                }
                
            }];
        }
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.floorPlayLabel.text = self.floorPlay[@"name_ko"];
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
    if ([segue.identifier isEqualToString:@"FloorPlayResult"]){
        FloorPlayResultViewController *floorController = (FloorPlayResultViewController *)segue.destinationViewController;
        floorController.playerName = sender[@"name"];
        floorController.floorPlay = self.floorPlay;
    }
}


@end

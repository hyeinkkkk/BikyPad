//
//  InputBarcodeViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 9..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "InputBarcodeViewController.h"
#import "BarcodeScanViewController.h"
#import "SelectBalloonViewController.h"
#import "PrintCardViewController.h"
#import "PrintConfirmViewController.h"
#import "Constants.h"
#import "HTTPClient.h"

@interface InputBarcodeViewController (){
    NSString * _barcode;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@end

@implementation InputBarcodeViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT");
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goNextSegue:) name:PlayerHomeNextNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)clickedButton:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BarcodeScanViewController *barcodeController = [mainStoryboard instantiateViewControllerWithIdentifier:@"BarcodeScanViewController"];
    
    barcodeController.action = self.mainTitle;
    [self presentViewController:barcodeController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self.mainTitle isEqual:@"print_card"]){
        self.titleLabel.text = @"다름카드 출력하기";
        
        self.descriptionLabel.text = @"수집한 다름카드를 출력하세요. \n다름카드를 출력하시려면 바코드를 입력하세요.";
    }
    else if([self.mainTitle isEqual:@"print_activities"]){
        self.titleLabel.text = @"오늘 활동카드";
        self.descriptionLabel.text = @"오늘 하루 동안 즐긴 활동을 출력하세요. \n오늘 활동카드는 하루에 2회까지 출력 가능합니다.";
    }
    else if([self.mainTitle isEqual:@"print_guestbook"]){
        self.titleLabel.text = @"방명록 출력";
        self.descriptionLabel.text = @"BIKY 영화놀이터 STORYPLAYING의 느낀점을 적어주세요. \n방명록은 하루에 5회까지 출력 가능합니다.";
    }
    else{
        [self.homeButton setHidden:YES];
    }
    
    
}

- (void) goNextSegue:(NSNotification *)noti{
    NSLog(@"inputBarcode 다음 페이지? %@",noti);
    _barcode = noti.userInfo[@"barcode"];
    
    HTTPClient * client = [HTTPClient httpClient];
    [client barcode:_barcode getPlayerByBarcodeWithCallback:^(id response) {
        NSLog(@"reponse? %@",response);
        if([response isEqual:@"none"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:@"플레이어가 존재하지 않습니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            
            [alertView show];
            return;
        }
        else{
            [self selectNextController:noti.userInfo[@"action"]];
        }

    }];
    
    
    
}

- (void) selectNextController:(NSString *)action{
    if([action isEqualToString:@"print_guestbook"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GuestBook" bundle:nil];
        UINavigationController * initialViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"GuestbookNavigationController"];
        SelectBalloonViewController *selectBalloonViewController =  (SelectBalloonViewController *) initialViewController.viewControllers[0];
        selectBalloonViewController.barcode = _barcode;
        self.view.window.rootViewController = initialViewController;
    }
    else if([action isEqualToString:@"print_card"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PlayerCard" bundle:nil];
        UINavigationController * initialViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerCardNavigationController"];
        PrintCardViewController *printCardViewController = (PrintCardViewController *)initialViewController.viewControllers[0];
        printCardViewController.serial = _barcode;
        self.view.window.rootViewController = initialViewController;
    }
    else if([action isEqualToString:@"print_activities"]){
        HTTPClient *client = [HTTPClient httpClient];
        [client barcode: _barcode
getPlayerTodayActivityWithCallback:^(id response){
    [self performSegueWithIdentifier:@"PrintConfirm" sender:response];
    
}];
        
    }
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
    if ([segue.identifier isEqualToString:@"PrintConfirm"]){
        PrintConfirmViewController *printConfirmViewController = (PrintConfirmViewController *)segue.destinationViewController;
        printConfirmViewController.action = @"print_activities";
        printConfirmViewController.data = sender;
    }

}


@end

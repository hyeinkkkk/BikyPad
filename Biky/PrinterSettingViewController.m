//
//  PrinterSettingViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 22..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "PrinterSettingViewController.h"
#import "PrinterController.h"

@interface PrinterSettingViewController (){
    NSString *mode;
}
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *settingAddress;
@property (weak, nonatomic) IBOutlet UILabel *settingMode;

@end

@implementation PrinterSettingViewController
- (IBAction)changedPrintMode:(UISegmentedControl *)sender {
    NSLog(@"sender is ....... %ld",sender.selectedSegmentIndex);
    if(sender.selectedSegmentIndex == 0){
        mode = @"bluetooth";
        self.addressTextField.placeholder = @"블루투스 MAC주소를 입력해주세요.";
    }
    else{
        mode = @"ip";
        self.addressTextField.placeholder = @"프린터 ip주소를 입력해주세요.";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mode = @"ip";
    NSDictionary *setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"printer"];
    self.settingMode.text = [NSString stringWithFormat:@"현재 모드: %@",setting[@"mode"]];
    self.settingAddress.text = [NSString stringWithFormat: @"현재 주소: %@",setting[@"address"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickedOK:(id)sender {
    
    NSDictionary *printer = @{@"address":[self.addressTextField.text uppercaseString] , @"mode":mode};
    
    [[NSUserDefaults standardUserDefaults] setObject:printer forKey:@"printer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"UserDefaults?? %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"printer"]);

    PrinterController *printerController = [PrinterController printerController];
    NSString * address = [self.addressTextField.text uppercaseString];
    [printerController selectPrinterTaget:mode address:address];
    [self dismissViewControllerAnimated:YES completion:nil];
//    printerController.address = self.addressTextField.text;
//    printerController.mode = mode;
}
- (IBAction)clickedOut:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

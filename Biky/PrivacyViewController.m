//
//  PrivacyViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 1..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "PrivacyViewController.h"
#import "BarcodeScanViewController.h"
#import "Constants.h"
#import "CreateIDViewController.h"

@interface PrivacyViewController () {
    NSString *_barcode;
}
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation PrivacyViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT");
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goCreateID:) name:CreateIDNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.checkBtn setImage:[UIImage imageNamed:@"box_check.png"] forState:UIControlStateNormal];

}

- (IBAction)toggleButton:(UIButton *)sender {
    if([ self.checkBtn.currentImage isEqual:[UIImage imageNamed:@"box_check.png"]]){
        [self.checkBtn setImage:[UIImage imageNamed:@"box_check_over.png"] forState:UIControlStateNormal];
        self.checkBtn.tintColor = [UIColor colorWithRed:0.9 green:0.34 blue:0.12 alpha:1];
    }
    else{
        [self.checkBtn setImage:[UIImage imageNamed:@"box_check.png"] forState:UIControlStateNormal];
        self.checkBtn.tintColor = [UIColor lightGrayColor];
        
    }

}

- (IBAction)clickedOkBtn:(UIButton *)sender {
    
    
    if([self.checkBtn.currentImage isEqual:[UIImage imageNamed:@"box_check.png"]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:@"동의를 하셔야 가입하실 수 있습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles: nil];
        
        [alertView show];
    }
    else{
        [self performSegueWithIdentifier:@"Scan" sender:sender];
    }
    NSLog(@"click!");
}

- (void) goCreateID:(NSNotification *) noti{
    NSLog(@"noti is ? %@",noti);
    _barcode = noti.userInfo[@"barcode"];
    [self performSegueWithIdentifier:@"CreateID" sender:noti];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue??? %@",segue);
    if ([[segue identifier] isEqualToString:@"CreateID"]) {
        NSLog(@"method??");
        CreateIDViewController *dest = (CreateIDViewController *)[segue destinationViewController];
        dest.barcode = _barcode;
    } else if ([[segue identifier] isEqualToString:@"Scan"]) {
        BarcodeScanViewController *barcodeController = (BarcodeScanViewController *)[segue destinationViewController];
        barcodeController.action = @"create_player";
    }
}

@end

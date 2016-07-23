//
//  SearchPlayerViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 3..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//
#import "SearchPlayerViewController.h"
#import "BarcodeScanViewController.h"
#import "HTTPClient.h"
#import "Constants.h"
#import "CompleteIDViewController.h"

@interface SearchPlayerViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (strong, atomic) NSDictionary *responsePlayer;

@property NSInteger count;

@end

@implementation SearchPlayerViewController {
    NSString *_username;
    float inputViewOriginX, inputViewOriginY;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT");
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUpdateID:) name:UpdateIDNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];

    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textF");
    [textField resignFirstResponder];
    return YES;
}

- (void)goUpdateID:(NSNotification *) noti{
    
    [self performSegueWithIdentifier:@"CompleteID" sender:noti];
}

-(void) onKeyboardShow:(NSNotification *) noti{
    self.view.transform = CGAffineTransformMakeTranslation(0, -150);

}

-(void) onKeyboardHide:(NSNotification *) noti{
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.responsePlayer = @{};
    self.count = 0;
    
    self.nameText.delegate = self;
    self.phoneText.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)clickedUpdateBarcode:(UIButton *)sender {
    HTTPClient *client = [HTTPClient httpClient];
    
    self.nameText.text = [self.nameText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.phoneText.text = [self.phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.phoneText.text = [self.phoneText.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [client phone:self.phoneText.text name:self.nameText.text getPlayerByPhoneNumberWithCallback: ^(id response){
        
        if([response isKindOfClass:[NSDictionary class]]){
            self.responsePlayer = response;
            _username = self.nameText.text;
            NSLog(@"player is : %@", response);
            NSLog(@"sender is %@ : ", sender);
            [self performSegueWithIdentifier:@"Scan" sender:sender];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                    message:@"플레이어가 존재하지 않습니다."
                   delegate:self
          cancelButtonTitle:@"Cancel"
          otherButtonTitles: nil];
            
            [alertView show];
            self.nameText.text = @"";
            self.phoneText.text = @"";
        }
    }];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CompleteID"]) {
        CompleteIDViewController *completeIDViewController = (CompleteIDViewController *)[segue destinationViewController];
        completeIDViewController.name = _username;
        completeIDViewController.action = @"update_player";
    } else if ([[segue identifier] isEqualToString:@"Scan"]) {
        BarcodeScanViewController *barcodeController = (BarcodeScanViewController *)[segue destinationViewController];
        barcodeController.action = @"update_player";
        barcodeController.data = self.responsePlayer;
    }
}

@end

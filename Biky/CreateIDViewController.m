//
//  CreateIDViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 1..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "CreateIDViewController.h"
#import "CompleteIDViewController.h"
#import "HTTPClient.h"

@interface CreateIDViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property enum gender {MALE,FEMALE};
@property enum gender gender;
@property (weak, nonatomic) IBOutlet UIPickerView *yearPickerView;
@property (atomic,strong) NSMutableArray * years;
@property (atomic,strong) NSString * selectedYears;
@property (atomic,strong) NSString * selectedGender;
@property (weak, nonatomic) IBOutlet UIView *yearFrameView;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@end

@implementation CreateIDViewController
- (IBAction)changedGender:(UIButton *) sender {
    NSLog(@"%ld",(long)sender.tag);
    self.gender = (int)sender.tag;
    switch (self.gender)
    {
        case MALE:
            self.selectedGender = @"Male";
            [sender setBackgroundImage:[UIImage imageNamed:@"btn_male_over.png"]
                              forState:UIControlStateNormal];
            [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"btn_female.png"]
                              forState:UIControlStateNormal];
            
            break;
        case FEMALE:
            NSLog(@"female???");
            self.selectedGender = @"Female";
            [sender setBackgroundImage:[UIImage imageNamed:@"btn_female_over.png"]
                              forState:UIControlStateNormal];
            [self.maleButton setBackgroundImage:[UIImage imageNamed:@"btn_male.png"]
                                         forState:UIControlStateNormal];
            break;
            
        default: 
            break; 
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textF");
    [textField resignFirstResponder];
    return YES;
}

- (void) hideKeyBoard {
    [self.nameText resignFirstResponder];
    [self.phoneText resignFirstResponder];
}


-(void) onKeyboardShow:(NSNotification *) noti{
    self.view.transform = CGAffineTransformMakeTranslation(0, -100);
    
}

-(void) onKeyboardHide:(NSNotification *) noti{
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
}

- (void)viewDidLoad {
    NSLog(@"VIEW DID LOAD");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    
    self.nameText.delegate = self;
    self.phoneText.delegate = self;
    
    self.yearFrameView.layer.borderColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1].CGColor;
    self.yearFrameView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.yearFrameView.layer.borderWidth = 1.0f;
    
    
    self.years = [[NSMutableArray alloc] init];
    
    for(int i=1935;i<2014;i++){
        [self.years addObject: [NSString stringWithFormat:@"%d",i]];
    }
    [self.yearPickerView selectRow:73 inComponent:0 animated:NO];
    self.selectedYears = [self.years objectAtIndex:73];
    self.serialText.text = self.barcode;
    self.selectedGender = @"";
    
    NSLog(@"serialText? %@",self.serialText.text);
    
}

- (void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSLog(@"VIEW DID APPEAR");
    NSLog(@"bbarcode ? %@",self.barcode);
//    self.barcode = @"0024721500083";
    self.serialText.text = self.barcode;

}
- (IBAction)clickedCreateButton:(id)sender {
    HTTPClient *client = [HTTPClient httpClient];

    self.nameText.text = [self.nameText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.phoneText.text = [self.phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.phoneText.text = [self.phoneText.text stringByReplacingOccurrencesOfString:@"-" withString:@""];

    [UIPasteboard generalPasteboard].string = self.phoneText.text;
    
    NSLog(@" nameText : %@",self.nameText.text);
    NSLog(@" phoneText : %@",self.phoneText.text);
    if([self.nameText.text isEqual:@""] || [self.phoneText.text isEqual:@""]|| [self.selectedGender isEqual:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                      message:[NSString stringWithFormat:@"정보를 모두 입력해주세요."]
                     delegate:self
            cancelButtonTitle:@"Cancel"
            otherButtonTitles: nil];

        [alertView show];

    }
    else{
        [client name:self.nameText.text phone:self.phoneText.text barcode:self.barcode birthyear:self.selectedYears gender:self.selectedGender createPlayerWithCallback:^(id response) {
            NSLog(@"%@",response);
            if([response isKindOfClass:[NSDictionary class]]){
                [self performSegueWithIdentifier:@"CompleteID" sender:sender];

            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                    message:[NSString stringWithFormat:@"오류 발생: \n %@",response]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles: nil];
                
                [alertView show];

            }
        }];
    }
}

// The number of columns of data
- (long) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.years count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int year = [[self.years objectAtIndex:row] intValue];
    
    return [NSString stringWithFormat:@"%@ (%d)",[self.years objectAtIndex:row],2016-year];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
        NSLog(@"선택된 세션? %@",self.years[row]);
    self.selectedYears = [self.years[row] mutableCopy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"CompleteID"]){
        CompleteIDViewController *completeIDViewController = (CompleteIDViewController *)segue.destinationViewController;
        completeIDViewController.name = self.nameText.text;
        completeIDViewController.action = @"create_player";
    }
}

@end

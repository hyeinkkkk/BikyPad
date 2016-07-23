//
//  MovieListViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 7..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "MovieListViewController.h"
#import "BarcodeScanViewController.h"
#import "MovieResultViewController.h"
#import "DateListViewController.h"
#import "HTTPClient.h"

@interface MovieListViewController () <UIPickerViewDataSource ,UIPickerViewDelegate>
{
    BOOL sendMessage;
}
@property (weak, nonatomic) IBOutlet UIPickerView *MoviePickerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, atomic) NSArray* sessionArray;
@property (strong, atomic) NSMutableDictionary * selectedSession;
@property (strong, atomic) NSString* month;
@property (strong, atomic) NSString* day;

@end

@implementation MovieListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"영화선택" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    HTTPClient *client = [HTTPClient httpClient];
        [client date:self.date getMovieListWithCallback:^(id response) {
            self.sessionArray = response;
            self.selectedSession = [self.sessionArray[0] mutableCopy];
            [self.MoviePickerView reloadAllComponents];
        }];
    sendMessage = NO;
    NSLog(@"sendMessage? %d",sendMessage);
    NSArray *chunks = [self.date componentsSeparatedByString: @"-"];
    self.month = [chunks objectAtIndex:0];
    self.day = [chunks objectAtIndex:1];
    self.dateLabel.text = [NSString stringWithFormat:@"%@일",[self.date stringByReplacingOccurrencesOfString:@"-" withString:@"월"]];
}


- (IBAction)clickedOK:(id)sender {
    
    [self.selectedSession setObject:self.month forKey:@"month"];
    [self.selectedSession setObject:self.day forKey:@"date"];
    if (sendMessage)
        return;
    sendMessage = YES;
    
    HTTPClient *client = [HTTPClient httpClient];
    
    [client movie:self.selectedSession barcode:self.barcode createPlayerActivityWithCallback:^(id response) {
        NSLog(@"client callback?? %@",response);
        if([response isEqual:@"full"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:@"이미 모든 카드를 획득하셨습니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            [alertView show];
            
        }
        else{
            [self performSegueWithIdentifier:@"MovieResult" sender:response];
        }
    }];
}

- (IBAction)unwindMovieList:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier 99999%@",segue.identifier);
    sendMessage = NO;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (int)[self.sessionArray count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //세션이름-극장이름
    return [self.sessionArray[row][@"session_ko"] stringByAppendingString:[NSString stringWithFormat:@"- %@",self.sessionArray[row][@"theater_ko"]]];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
//    NSLog([NSString stringWithFormat: @"선택된 세션? %@",self.sessionArray[row]]);
    self.selectedSession = [self.sessionArray[row] mutableCopy];
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
    NSLog(@"segue? 불렸니? %@",segue.identifier);
    if([segue.identifier isEqualToString:@"MovieResult"]){
        MovieResultViewController *movieResultViewController = (MovieResultViewController *)[segue destinationViewController];
        movieResultViewController.player = sender;
        movieResultViewController.barcode = self.barcode;
        movieResultViewController.movie = self.selectedSession;
    }
    else if([segue.identifier isEqualToString:@"UnwindDateList"]){
        DateListViewController *dateController = (DateListViewController *)segue.destinationViewController;
        dateController.barcode = self.barcode;
    }
}


@end

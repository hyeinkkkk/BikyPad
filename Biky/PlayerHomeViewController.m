
//
//  PlayerHomeViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 14..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "PlayerHomeViewController.h"
#import "InputBarcodeViewController.h"

@interface PlayerHomeViewController ()

@end

@implementation PlayerHomeViewController
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
- (IBAction)clickedPrintCard:(id)sender {
    [self performInputBarcodeSegue:@"print_card"];
}

- (IBAction)clickedGuestBook:(id)sender {
    [self performInputBarcodeSegue:@"print_guestbook"];
}

- (IBAction)clickedTodayResult:(id)sender {
    [self performInputBarcodeSegue:@"print_activities"];
}

- (void) performInputBarcodeSegue:(NSString *)action{
    [self performSegueWithIdentifier:@"InputBarcode" sender:action];
}

- (IBAction)unwindHome:(UIStoryboardSegue *)segue{
    NSLog(@"unwind");
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
    NSLog(@"segue ? %@",segue);
    if([[segue identifier] isEqualToString:@"InputBarcode"]){
        InputBarcodeViewController *destination = (InputBarcodeViewController *)[segue destinationViewController];
        destination.mainTitle = sender;
    }
}


@end

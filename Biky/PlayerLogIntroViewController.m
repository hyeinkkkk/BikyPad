//
//  PlayerLogIntroViewController.m
//  Biky
//
//  Created by CS6 on 7/13/15.
//  Copyright (c) 2015 Nolgong. All rights reserved.
//

#import "PlayerLogIntroViewController.h"
#import "BarcodeScanViewController.h"

@interface PlayerLogIntroViewController ()

@end

@implementation PlayerLogIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Log controller");
}

- (IBAction)clickedInputButton:(id)sender
{
    UIStoryboard *playerLogStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BarcodeScanViewController *barcodeController = [playerLogStoryboard instantiateViewControllerWithIdentifier:@"BarcodeScanViewController"];
    
    NSLog(@"Here");
    barcodeController.action = @"playerLog";
    [self presentViewController:barcodeController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindFromPlayerLogListView:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier %@",segue.identifier);
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

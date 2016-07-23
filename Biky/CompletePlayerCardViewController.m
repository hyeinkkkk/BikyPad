//
//  CompletePlayerCardViewController.m
//  Biky
//
//  Created by CS6 on 7/16/15.
//  Copyright (c) 2015 Nolgong. All rights reserved.
//

#import "CompletePlayerCardViewController.h"
#import "PlayerHomeViewController.h"
#import "PrintCardViewController.h"

@interface CompletePlayerCardViewController ()

@end

@implementation CompletePlayerCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(goToHomeStoryboard:) withObject:nil afterDelay:5.0 ];
}

- (IBAction)goToHomeStoryboard:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    PlayerHomeViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerHomeViewController"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:initialViewController]
    ;
    navi.navigationBarHidden = YES;
    self.view.window.rootViewController = navi;
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
    if ([segue.identifier isEqualToString:@"unwindPlayerCardList"]){
        PrintCardViewController *printCardViewController = (PrintCardViewController *)segue.destinationViewController;
        printCardViewController.serial = self.barcode;
    }
}


@end

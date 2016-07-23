//
//  JoinViewController.m
//  Biky
//
//  Created by nolgong on 2015. 7. 16..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController ()

@end

@implementation JoinViewController
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindFromPrivacy:(UIStoryboardSegue *)segue
{
    // UIViewController *detailViewController = [segue sourceViewController];
    NSLog(@"%@", segue.identifier);
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

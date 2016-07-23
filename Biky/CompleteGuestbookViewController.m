//
//  CompleteGuestbookViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 16..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "CompleteGuestbookViewController.h"
#import "SelectBalloonViewController.h"
#import "PlayerHomeViewController.h"

@interface CompleteGuestbookViewController ()

@end

@implementation CompleteGuestbookViewController



- (IBAction)clickedExit:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    PlayerHomeViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerHomeViewController"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:initialViewController]
    ;
    navi.navigationBarHidden = YES;
    self.view.window.rootViewController = navi;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(clickedExit:) withObject:nil afterDelay:5.0 ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

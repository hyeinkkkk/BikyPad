//
//  DoneGuestbookViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 10..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "DoneGuestbookViewController.h"
#import "InputBarcodeViewController.h"
#import "PlayerHomeViewController.h"

@interface DoneGuestbookViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation DoneGuestbookViewController
- (IBAction)clickedBackButton:(id)sender {
    [self dismissModal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self.action isEqual:@"print_fail"]){
        self.nameLabel.text = self.playerName;
//        self.descriptionLabel.text = @"오늘 가능한 방명록을 모두 출력하셨습니다. \n 손글씨 방명록을 이용해주세요.";
//        self.descriptionLabel.numberOfLines = 0;
        [self performSelector:@selector(dismissModal) withObject:nil afterDelay:5.0 ];
    }
    else if([self.action isEqual:@"print_success"]){
//        self.descriptionLabel.text = @"출력중입니다..";
        [self performSelector:@selector(dismissModal) withObject:nil afterDelay:5.0 ];
    }
}

- (void) dismissModal{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    PlayerHomeViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerHomeViewController"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:initialViewController]
    ;
    navi.navigationBarHidden = YES;
    self.view.window.rootViewController = navi;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//    InputBarcodeViewController *inputBarcodeViewController = [storyboard instantiateViewControllerWithIdentifier:@"InputBarcodeViewController"];
//    inputBarcodeViewController.mainTitle = @"print_guestbook";
//    [self presentViewController:inputBarcodeViewController animated:NO completion:nil];
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

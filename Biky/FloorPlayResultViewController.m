//
//  FloorPlayResultViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 10..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "FloorPlayResultViewController.h"
#import "FloorPlayTitleViewController.h"

@interface FloorPlayResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation FloorPlayResultViewController

- (IBAction)clickedFloorPlayTitle:(id)sender {
    FloorPlayTitleViewController *floorPlayTitleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FloorPlayTitleViewController"];
    floorPlayTitleViewController.floorPlay = self.floorPlay;
    [self presentViewController:floorPlayTitleViewController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@님의 %@ 바닥놀이 참여가 인정되었습니다.",self.playerName,self.floorPlay[@"name_ko"]];
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
    if ([segue.identifier isEqualToString:@"unwindFloorPlayTitle"]){
        FloorPlayTitleViewController *floorPlayTitleViewController = (FloorPlayTitleViewController *)segue.destinationViewController;
        floorPlayTitleViewController.floorPlay = self.floorPlay;

    }
}


@end

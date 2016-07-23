//
//  ResultViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 7..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "ResultViewController.h"
#import "FloorPlayListViewController.h"
#import "DateListViewController.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ResultViewController
- (IBAction)clickedOK:(id)sender {
    if([self.action isEqual:@"floor_play"]){
        UIStoryboard *floorPlayStoryboard = [UIStoryboard storyboardWithName:@"FloorPlay" bundle:nil];
        FloorPlayListViewController *floorPlayListViewController = [floorPlayStoryboard instantiateViewControllerWithIdentifier:@"FloorPlayListViewController"];
        [self presentViewController:floorPlayListViewController animated:YES completion:nil];
    }
    else if([self.action isEqual:@"movie"]){
        UIStoryboard *movieStoryboard = [UIStoryboard storyboardWithName:@"Movie" bundle:nil];
        DateListViewController *dateListViewController = [movieStoryboard instantiateViewControllerWithIdentifier:@"DateListViewController"];
        [self presentViewController:dateListViewController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = [NSString stringWithFormat:@"%@님의 ",self.data[@"player_name"]];
    if ([self.action isEqual:@"floor_play"]){
        self.descriptionLabel.text = [NSString stringWithFormat:@"[%@] 바닥놀의 참여가 인정되었습니다.",self.data[@"activity_name"]];
    }
    else if ([self.action isEqual:@"movie"]){
        self.descriptionLabel.text = [NSString stringWithFormat:@"[%@] 영화 관람이 인정되었습니다.",self.data[@"activity_name"]];
    }

    
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

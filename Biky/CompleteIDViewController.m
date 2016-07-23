//
//  CompleteIDViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 2..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "CompleteIDViewController.h"

@interface CompleteIDViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CompleteIDViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.nameText.text = self.name;
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"self.name is %@",self.name);
//    self.nameText.text = [NSString stringWithFormat:@"%@",self.name];
    if([self.action isEqual:@"update_player"]){
        self.titleLabel.text = @"ID업데이트";
        self.descriptionText.text = [NSString stringWithFormat:@"%@님의 아이디가 수정되었습니다!",self.name];
    }
    else if([self.action isEqual:@"create_player"]){
        self.titleLabel.text = @"바코드ID발급";
        self.descriptionText.text = [NSString stringWithFormat:@"%@님의 아이디가 생성되었습니다!",self.name];
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

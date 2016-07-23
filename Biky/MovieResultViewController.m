//
//  MovieResultViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 10..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "MovieResultViewController.h"
#import "DateListViewController.h"
#import "MovieListViewController.h"

@interface MovieResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectDateButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMovieButton;

@end

@implementation MovieResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self.player isEqual:@"exist"]){
        self.descriptionLabel.text = @"영화관람이 중복되었습니다. \n 다시 확인하시고 입력해주세요.";
        self.descriptionLabel.numberOfLines = 0;
//        [self.selectMovieButton setHidden:YES];
//        [self.selectDateButton setHidden:YES];
    }
    else{
        self.descriptionLabel.text = [NSString stringWithFormat:@"%@님의 %@ 영화관람이 \n인정되었습니다.",self.player[@"name"],self.movie[@"session_ko"]];
        self.descriptionLabel.numberOfLines = 0;
        [self.descriptionLabel sizeToFit];
        
    }
    
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
    if([segue.identifier isEqualToString:@"UnwindDateList"]){
        DateListViewController *dateListViewController = (DateListViewController *)segue.destinationViewController;
        dateListViewController.barcode = self.barcode;
    }
    else if([segue.identifier isEqualToString:@"UnwindMovieList"]){
        MovieListViewController *movieListViewController = (MovieListViewController *)segue.destinationViewController;
        movieListViewController.date = [NSString stringWithFormat:@"%@-%@",self.movie[@"month"],self.movie[@"date"]];
        movieListViewController.barcode = self.barcode;
    }
}


@end

//
//  FloorPlayListViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 7..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "FloorPlayListViewController.h"
#import "FloorPlayTitleViewController.h"
#import "Constants.h"
#import "HTTPClient.h"

@interface FloorPlayListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *floorCollction;
@property (strong, atomic) NSArray *floorPlayArray;
@end

@implementation FloorPlayListViewController{
    HTTPClient *client;
}
- (IBAction)clickedHome:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController * initialViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    initialViewController.navigationBarHidden = YES;
    self.view.window.rootViewController = initialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.floorCollction.frame = CGRectMake(20,20,self.view.frame.size.width, self.view.frame.size.height);
    
    client = [HTTPClient httpClient];
    [client getFloorPlayListWithCallback:^(id response) {
        
        self.floorPlayArray = response;
        
        [self.floorCollction reloadData];

    }];
}

- (IBAction)unwindFloorList:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier %@",segue.identifier);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


// 컬렉션 뷰 아이템 갯수
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.floorPlayArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 컬렉션 셀을 생성
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"floor" forIndexPath:indexPath];
    [cell.layer setCornerRadius:5.0f];
    NSUInteger row = [indexPath row];
    
    UILabel *label = (UILabel *) [cell.contentView viewWithTag:10];
    label.text = self.floorPlayArray[row][@"name_ko"];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"FloorPlayTitle" sender:indexPath];
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
    if([segue.identifier isEqualToString:@"FloorPlayTitle"]){
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        FloorPlayTitleViewController *floorPlayTitleViewController = segue.destinationViewController;
        floorPlayTitleViewController.floorPlay = [self.floorPlayArray objectAtIndex:[indexPath row]];
//        [self presentViewController:floorPlayTitleViewController animated:YES completion:nil];

    }
}


@end

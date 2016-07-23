//
//  DateListViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 7..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "DateListViewController.h"
#import "MovieListViewController.h"
#import "HTTPClient.h"


@interface DateListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *dateCollection;
@property (strong, atomic) NSArray *dateArray;
@property (strong, atomic) HTTPClient * client;

@end

@implementation DateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.client = [HTTPClient httpClient];
    [self.client getDateListWithCallback:^(id response) {
        
        self.dateArray = response;
        
        [self.dateCollection reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindDateList:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier2 %@",segue.identifier);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


// 컬렉션 뷰 아이템 갯수
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dateArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 컬렉션 셀을 생성
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Date" forIndexPath:indexPath];
    [cell.layer setCornerRadius:5.0f];
    NSUInteger row = [indexPath row];
    
    UILabel * label = (UILabel *)[cell viewWithTag:10];
    label.text = [self.dateArray[row] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"MovieList" sender:indexPath];
//    MovieListViewController *movieListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieListViewController"];
//    movieListViewController.date = [[self.dateArray objectAtIndex:[indexPath row]] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
//    movieListViewController.barcode = self.barcode;
//    [self presentViewController:movieListViewController animated:NO completion:nil];

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"MovieList"]){
        NSIndexPath * indexPath = (NSIndexPath *)sender;
        MovieListViewController *dest = (MovieListViewController *)segue.destinationViewController;
        dest.date = [[self.dateArray objectAtIndex:[indexPath row]] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        dest.barcode = self.barcode;
        
    }
}


@end

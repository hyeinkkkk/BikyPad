//
//  AllCardsViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 21..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "AllCardsViewController.h"
#import "PrintConfirmViewController.h"
#import "HTTPClient.h"

@interface AllCardsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@end

@implementation AllCardsViewController{
    NSArray *cardList;
}
- (IBAction)clickedHome:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController * initialViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    initialViewController.navigationBarHidden = YES;
    self.view.window.rootViewController = initialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HTTPClient *client = [HTTPClient httpClient];
    [client getAllCardsWithCallback:^(id response) {
        cardList = response;
        [self.cardCollectionView reloadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


// 컬렉션 뷰 아이템 갯수
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [cardList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    NSUInteger row = [indexPath row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    
    if ([cardList[row][@"director"] isEqual:@"kid"]) {
        
        label.text = [NSString stringWithFormat:@"%@. %@",cardList[row][@"card"],[cardList[row][@"title_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];//cardList[row][@"title_ko"];
    }
    else{
        label.text = [NSString stringWithFormat:@"%@. %@",cardList[row][@"index"],[cardList[row][@"action_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];//cardList[row][@"action_ko"];
    }
    
    [cell.layer setCornerRadius:5.0f];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"card? %@",cardList[[indexPath row]]);

    PrintConfirmViewController *printConfirmViewController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PrintConfirmViewController"];
    printConfirmViewController.action = @"print_card";
    //    printConfirmViewController.data = [self.cardList objectAtIndex:[indexPath row]];
    
    NSArray *card = [NSArray arrayWithObjects:[cardList objectAtIndex:[indexPath row]], nil];
    printConfirmViewController.data = [NSMutableDictionary dictionaryWithObject:card forKey:@"cards"];
    
    if ([card[0][@"director"] isEqual: @"kid"] ){
        [printConfirmViewController.data setObject:card[0][@"title_ko"] forKey:@"title"];
    }
    else{
        [printConfirmViewController.data setObject:card[0][@"action_ko"] forKey:@"title"];
    }
    
    printConfirmViewController.player = @{@"name": @"biky"};
    
    printConfirmViewController.awardCount = 1;
   
    
    [self presentViewController:printConfirmViewController animated:YES completion:nil];
    
//    PrintConfirmViewController *printConfirmViewController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PrintConfirmViewController"];
//    printConfirmViewController.action = @"print_card";
//    printConfirmViewController.data = [cardList objectAtIndex:[indexPath row]];
//    printConfirmViewController.player = @{@"name": @"biky"};
//    if([[cardList objectAtIndex:[indexPath row]][@"director"] isEqual:@"kid"]){
//        printConfirmViewController.awardCount = 1;
//        
//    }else{
//        printConfirmViewController.awardCount = 1;
//    }
//    
//    [self presentViewController:printConfirmViewController animated:YES completion:nil];
    
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

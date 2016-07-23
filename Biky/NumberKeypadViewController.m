//
//  NumberKeypadViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 20..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "NumberKeypadViewController.h"
#import "Constants.h"

@interface NumberKeypadViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *numberCollectionView;

@end

@implementation NumberKeypadViewController{
//    NSInteger count;
    NSArray * numbers;
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rotateNumberpad:(id)sender {
    self.numberCollectionView.transform = CGAffineTransformConcat(self.numberCollectionView.transform, CGAffineTransformMakeRotation(M_PI));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    numbers = [[NSArray alloc] initWithObjects:@"1",@"2", @"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"<-",@"OK", nil];
    NSLog(@"self.action %@",self.action);
    NSLog(@"self.data %@",self.data);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}


// 컬렉션 뷰 아이템 갯수
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = 4*[indexPath section]+[indexPath row];
    UICollectionViewCell *cell;
    
    // 컬렉션 셀을 생성
    if (index == 10){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cancel" forIndexPath:indexPath];
        
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:11];
        
        imageView.image = [UIImage imageNamed:@"arrow-left"];
        
        
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Number" forIndexPath:indexPath];
    }
    
    switch (index) {
        case 10:
            cell.backgroundColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.64 alpha:1];
            break;
        case 11:
            cell.backgroundColor = [UIColor colorWithRed:0.91 green:0.33 blue:0.02 alpha:1];
            break;
        default:
            cell.backgroundColor = [UIColor colorWithRed:0.45 green:0.71 blue:0.27 alpha:1];
            break;
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, collectionView.frame.size.width/5,collectionView.frame.size.height/5);
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    }
    else{
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 150  ,100);
//        cell.frame = CGRectMake(cell.frame.origin.x+150, cell.frame.origin.y+150, 150  ,100);
        label.font = [UIFont fontWithName:@"Helvetica Neue" size:40];
    }
    
    label.text = [NSString stringWithFormat:@"%@", numbers[index]];
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGSize cellSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        cellSize =  CGSizeMake(self.numberCollectionView.frame.size.width/5, self.numberCollectionView.frame.size.height/4);
    }
    else
        cellSize =  CGSizeMake(150,100);//self.numberCollectionView.frame.size.width/5, self.numberCollectionView.frame.size.height/3);
//    CGSize cellSize = CGSizeMake(self.collectionView.bounds.size.width, [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height);
    
    return cellSize;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSUInteger index = 4*[indexPath section]+[indexPath row];
    NSString * sender = numbers[index];
    
    if([sender isEqualToString:@"<-"]){
        if ([self.barcodeLabel.text length] > 0){
            self.barcodeLabel.text = [self.barcodeLabel.text substringToIndex:[self.barcodeLabel.text length] - 1];
        }
    }
    else if ([sender isEqualToString:@"OK"]){
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"in keypad controller %@", self.data);
            
            if ([self.action isEqualToString:@"update_player"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:BarcodeSerialNotification object:nil userInfo:@{@"barcode":self.barcodeLabel.text , @"action": self.action, @"data":self.data}];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:BarcodeSerialNotification object:nil userInfo:@{@"barcode":self.barcodeLabel.text , @"action": self.action}];
            }
            
        }];

    }
    else{
        self.barcodeLabel.text = [self.barcodeLabel.text stringByAppendingString:sender];
    }

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

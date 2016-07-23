//
//  SelectBalloonViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 9..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "SelectBalloonViewController.h"
#import "WriteGuestbookViewController.h"
#import "DoneGuestbookViewController.h"
#import "PlayerHomeViewController.h"
#import "HTTPClient.h"

@interface SelectBalloonViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSNumber *wroteCount;
}
@property (weak, nonatomic) IBOutlet UICollectionView *balloonCollectionView;

@end

@implementation SelectBalloonViewController


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
    self.balloonCollectionView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    // Do any additional setup after loading the view.
//    self.barcode = @"10290537";
    HTTPClient *client = [HTTPClient httpClient];
    [client barcode:self.barcode getPlayerGuestBookWithCallback: ^(id response){
        NSLog(@"!!!!!!! %@",response);
        
        int value = [response intValue];
        wroteCount = [NSNumber numberWithInt:value + 1];
        
        if([response isEqual:@5]){
            [client barcode:self.barcode getPlayerByBarcodeWithCallback:^(id playerResponse) {
                NSLog(@"playerRes ? %@",playerResponse);
                DoneGuestbookViewController *doneGuestBookViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DoneGuestbookViewController"];
                doneGuestBookViewController.playerName = playerResponse[@"name"];
                doneGuestBookViewController.action = @"print_fail";
                [self presentViewController:doneGuestBookViewController animated:YES completion:nil];
            }];
            
        }

    }];
}

- (IBAction)unwindFromWriteGuestbook:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier %@",segue.identifier);
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
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    // 컬렉션 셀을 생성
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Ballon" forIndexPath:indexPath];
    
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:10];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"balloon_%lu.jpg",(unsigned long)row+1]];

    
    return cell;
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"선택???");
    [self performSegueWithIdentifier:@"WriteGuestBook" sender:indexPath];

    
//    WriteGuestbookViewController *writeGuestbookViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteGuestbookViewController"];
//    writeGuestbookViewController.balloonIndex = (int) [indexPath row]+1;
//    writeGuestbookViewController.barcode = self.barcode;
//    writeGuestbookViewController.wroteCount = wroteCount;
//    [self presentViewController:writeGuestbookViewController animated:YES completion:nil];

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"넘어가기전?");
    NSLog(@"segue? %@", segue.identifier);
    NSLog(@"segue? %@", sender);
    
    if([[segue identifier] isEqualToString:@"WriteGuestBook"]){
        WriteGuestbookViewController *dest = (WriteGuestbookViewController *)[segue destinationViewController];
        dest.barcode = self.barcode;
        dest.wroteCount = wroteCount;
        dest.balloonIndex = (int)[sender row]+1;
    }
    
    
}


@end

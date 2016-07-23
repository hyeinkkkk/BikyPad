//
//  PrintCardViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 8..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "PrintCardViewController.h"
#import "PrintConfirmViewController.h"
#import "InputBarcodeViewController.h"
#import "CompletePlayerCardViewController.h"
#import "PlayerHomeViewController.h"
#import "HTTPClient.h"
#import "Constants.h"

@interface PrintCardViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectonView;
@property (strong, atomic)  NSMutableArray *cardList;
@property (strong, atomic)  NSDictionary *player;
@property  NSUInteger directorCount;
@property (weak, nonatomic) IBOutlet UILabel *awardCount;
@property (weak, nonatomic) IBOutlet UILabel *gameCount;
//@property (strong, atomic) PrinterController *printer;
@property (weak, nonatomic) IBOutlet UILabel *movieCount;
@property (weak, nonatomic) IBOutlet UILabel *guestbookCount;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UIView *floorPlayView;
@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UIView *guestbookView;
@property (weak, nonatomic) IBOutlet UILabel *nothingDescription;


@end

@implementation PrintCardViewController
- (IBAction)PrintAllCards:(id)sender {
    
    PrintConfirmViewController *printConfirmViewController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PrintConfirmViewController"];
    printConfirmViewController.action = @"print_card";
    
    NSArray *card = self.cardList;
    printConfirmViewController.data = [NSMutableDictionary dictionaryWithObject:card forKey:@"cards"];
    
    [printConfirmViewController.data setObject:@"모든" forKey:@"title"];
    
    printConfirmViewController.player = self.player;
    printConfirmViewController.awardCount = 0;

    [self presentViewController:printConfirmViewController animated:YES completion:nil];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT");
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printConfirmed:) name:PrintConfirmNotifiction object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)unwindPlayerCardList:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier %@",segue.identifier);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.serial = @"6x890";
    
    [self.floorPlayView.layer setBorderWidth:1.0f];
    [self.floorPlayView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1].CGColor];
    [self.movieView.layer setBorderWidth:1.0f];
    [self.movieView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1].CGColor];
    [self.guestbookView.layer setBorderWidth:1.0f];
    [self.guestbookView.layer setBorderColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1].CGColor];
    
    NSLog(@"ViewDidLoad???");
    self.directorCount = 0;
    [self loadCardList];
}

- (void)loadCardList {
    HTTPClient *client = [HTTPClient httpClient];
    NSLog(@"loadCardList %@",self.serial );
    [client barcode:self.serial getPlayerActivityWithCallback:^(id response) {

        if ([response isEqual:@"none"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:[NSString stringWithFormat:@"바코드 오류! \n %@",response]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            
            [alertView show];

        }
        else{
            if ([response[@"cards"] count] == 0){
                [self.nothingDescription setHidden:NO];
                [self.cardCollectonView setHidden:YES];
                return;
            }
            self.cardList = [[NSMutableArray alloc] init];
            for(int i=0;i<[response[@"cards"] count];i++){
                //cardList에는 print가 가능한 카드만 보여준다.
                NSLog(@"directorCount %@",[response[@"cards"] objectAtIndex:i]);
                if ([[response[@"cards"] objectAtIndex:i][@"print"] boolValue] == 0){
                    [self.cardList addObject:[response[@"cards"] objectAtIndex:i]];
                }
                if ([[response[@"cards"] objectAtIndex:i][@"director"] isEqual:@"kid"]){
                    self.directorCount ++;
//                    NSLog(@"directorCount %lu",self.directorCount);
                }

            }
            
            NSLog(@"cardList???????  %@",self.cardList);
            
            self.player = response[@"player"];
            self.playerNameLabel.text = self.player[@"name"];
            self.movieCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[response[@"movies"] count]];
            self.awardCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[response[@"cards"] count]];
            self.gameCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[response[@"floors"] count]];
            self.guestbookCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[response[@"guestbook_img"] count]];
            [self.cardCollectonView reloadData];
        }
    }];
}

- (void)printConfirmed:(NSNotification *)notification {

    NSLog(@"printConfirm");
    [self loadCardList];
        NSLog(@"perform Segue");
    [self performSegueWithIdentifier:@"CompletePlayerCard" sender:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (IBAction)clickedBackButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    PlayerHomeViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerHomeViewController"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:initialViewController]
    ;
    navi.navigationBarHidden = YES;
    self.view.window.rootViewController = navi;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//    InputBarcodeViewController *inputBarcodeViewController = [storyboard instantiateViewControllerWithIdentifier:@"InputBarcodeViewController"];
//    inputBarcodeViewController.mainTitle = @"print_card";
//    [self presentViewController:inputBarcodeViewController animated:NO completion:nil];

    
}


// 컬렉션 뷰 아이템 갯수
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cardList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 컬렉션 셀을 생성
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    
//    [cell.layer setCornerRadius:5.0f];
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:[UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1].CGColor]; //[UIColor blackColor].CGColor];
    NSUInteger row = [indexPath row];
    UILabel * label = (UILabel *)[cell viewWithTag:10];
    if ((int)self.cardList[row][@"print"] == NO) {
//        continue;
        NSLog(@"filter printed card");
    }
    
    if ([self.cardList[row][@"director"] isEqual:@"kid"]) {
        label.text = [self.cardList[row][@"title_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@""];//cardList[row][@"title_ko"];
    }
    else{
        label.text = [self.cardList[row][@"action_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@""];//cardList[row][@"action_ko"];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click?? %@" ,[self.cardList objectAtIndex:[indexPath row]]);
    
    PrintConfirmViewController *printConfirmViewController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PrintConfirmViewController"];
    printConfirmViewController.action = @"print_card";
//    printConfirmViewController.data = [self.cardList objectAtIndex:[indexPath row]];
    
    NSArray *card = [NSArray arrayWithObjects:[self.cardList objectAtIndex:[indexPath row]], nil];
    printConfirmViewController.data = [NSMutableDictionary dictionaryWithObject:card forKey:@"cards"];
    
    if ([card[0][@"director"] isEqual: @"kid"] ){
        [printConfirmViewController.data setObject:card[0][@"title_ko"] forKey:@"title"];
    }
    else{
        [printConfirmViewController.data setObject:card[0][@"action_ko"] forKey:@"title"];
    }
    
    printConfirmViewController.player = self.player;
    if([[self.cardList objectAtIndex:[indexPath row]][@"director"] isEqual:@"kid"]){
        printConfirmViewController.awardCount = self.directorCount;
        
    }else{
        printConfirmViewController.awardCount = [self.cardList count];
    }
    
    [self presentViewController:printConfirmViewController animated:YES completion:nil];

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
    if([segue.identifier isEqualToString:@"CompletePlayerCard"]){
        CompletePlayerCardViewController *completePlayerCardViewController = (CompletePlayerCardViewController *)segue.destinationViewController;
        completePlayerCardViewController.barcode = self.serial;
    }
}


@end

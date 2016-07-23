//
//  PrintConfirmViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 10..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "PrintConfirmViewController.h"
#import "PrinterController.h"
#import "PrintCardViewController.h"
#import "InputBarcodeViewController.h"
#import "CompletePlayerCardViewController.h"
#import "PlayerHomeViewController.h"
#import "HTTPClient.h"
#import "Constants.h"

@interface PrintConfirmViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerCardDescription;
@property (weak, nonatomic) IBOutlet UILabel *playerActivityDescription;
@property (strong, atomic) PrinterController *printer;
@property (weak, nonatomic) IBOutlet UIButton *OKbutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property  NSUInteger directorCount;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *printDescription;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *nothingDescription;

@end

@implementation PrintConfirmViewController
- (IBAction)clickedCancel:(id)sender {
    if([self.action isEqual:@"print_card"]){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if([self.action isEqual:@"print_activities"]){
        InputBarcodeViewController *inputBarcodeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputBarcodeViewController"];
        inputBarcodeViewController.mainTitle = @"print_activities";
        [self presentViewController:inputBarcodeViewController animated:NO completion:nil];
    }
}

- (IBAction)clickedPrint:(id)sender {
    NSLog(@"프린트 시작!");
    [self.loadingView setHidden:NO];
    [self.loadingView startAnimating];
    [self.printDescription setHidden:NO];
    [self.playerCardDescription setHidden:YES];
    [self.playerActivityDescription setHidden:YES];
    [self.OKbutton setHidden:YES];
    [self.cancelButton setHidden:YES];
    
//    self.discription.text = @"출력중입니다...";

    HTTPClient *client = [HTTPClient httpClient];
    
    if([self.action isEqual:@"print_card"]){
        NSLog(@"print_card List? %@",self.data);
        int printCount = ([self.data[@"cards"] count] < 11 ? [self.data[@"cards"] count] : 10);
        for (int i=0;i < printCount; i++){
            NSDictionary * card = self.data[@"cards"][i];
            if ([card[@"director"] isEqual: @"kid"] ){
                [self.printer printDirectorCard:card awardCount:self.awardCount playerName:self.player[@"name"]];
                NSLog(@"출력할 카드는? %@",card);
            }
            else {
                [self.printer printCard:card awardCount:self.awardCount playerName:self.player[@"name"]];
                NSLog(@"출력할 카드는? %@",card);
            }
            [client barcode:self.player[@"serial"] director:card[@"director"] card:card[@"_id"] updatePlayerActivityWithCallback:^(id response){
                //            통신이 끝난 후에, 다시 pirntCard Controller로 이동해야한다.
                NSLog(@"통신");
                
            }];

        }
        NSLog(@"프린트 끝!");
        [self.loadingView stopAnimating];
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PrintConfirmNotifiction object:nil];
        }];
        
    }
    else if([self.action isEqual:@"print_activities"]){
     //self.data에서 활동들만 뽑아서 데이터를 넘긴다.
        for(int i=0;i<[self.data[@"cards"] count];i++){
            if ([[self.data[@"cards"] objectAtIndex:i][@"director"] isEqual:@"kid"]){
                self.directorCount ++;

                NSLog(@"directorCount %lu",self.directorCount);
            }
        }
        [self.printer printTodayResult:self.data[@"activities"] playerName:self.data[@"player"][@"name"] awardCount:[self.data[@"cards"] count] dircectorCount:self.directorCount];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        PlayerHomeViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerHomeViewController"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:initialViewController]
        ;
        navi.navigationBarHidden = YES;
        self.view.window.rootViewController = navi;
    }
}

- (void) showDescription{
    if([self.action isEqual:@"print_card"]){
        
        self.titleLabel.text = @"다름카드 출력";
        
        [self.playerCardDescription setHidden:NO];
        [self.playerActivityDescription setHidden:YES];
        [self.nothingDescription setHidden:YES];
        
        self.cardNameLabel.text =[self.data[@"title"] stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        
    }
    else if([self.action isEqual:@"print_activities"]){
        
        self.titleLabel.text = @"오늘 활동카드 출력";
        if([self.data[@"activities"] count] == 0){
            [self.playerActivityDescription setHidden:YES];
            [self.playerCardDescription setHidden:YES];
            [self.nothingDescription setHidden:NO];
            [self.OKbutton setHidden:YES];

        }
        else{
            [self.playerActivityDescription setHidden:NO];
            [self.playerCardDescription setHidden:YES];
            [self.nothingDescription setHidden:YES];
        }
    }
    [self.printDescription setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.printer = [PrinterController printerController];
//    NSLog(@"data ?? %@",self.data);
    self.directorCount = 0;
    
    [self.loadingView setHidden:YES];
    [self showDescription];

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

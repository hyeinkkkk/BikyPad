//
//  HomeViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 6..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "HomeViewController.h"
#import "InputBarcodeViewController.h"
#import "PrinterController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;

@end

@implementation HomeViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT HomeController");
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"printer ? %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"printer"]);
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"printer"] != nil){
            PrinterController *printerController = [PrinterController printerController];
            
            NSDictionary *printerInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"printer"];
            NSString * address = printerInfo[@"address"]; //[[NSUserDefaults standardUserDefaults] stringForKey:@"address"];
            NSString * mode = printerInfo[@"mode"]; //[[NSUserDefaults standardUserDefaults] stringForKey:@"mode"];
            
            [printerController selectPrinterTaget:mode address:address];
            //        NSLog(@"nil");
        }
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (IBAction)unwindHomeconclcon:(UIStoryboardSegue *)segue {
    NSLog(@"segue identifier %@",segue.identifier);
}


- (IBAction)clickedCreateID:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateIDNavigationController"];
    self.view.window.rootViewController = initialViewController;
}
- (IBAction)clickedMovie:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Movie" bundle:nil];
    UINavigationController * initialViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MovieNavigationController"];
    self.view.window.rootViewController = initialViewController;

}
- (IBAction)clickedFloorPlay:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FloorPlay" bundle:nil];
    UINavigationController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"FloorPlayNavigationController"];
    self.view.window.rootViewController = initialViewController;
}
- (IBAction)clickedPlayerLog:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PlayerLog" bundle:nil];
    UIViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerLogIntroViewController"];
    self.view.window.rootViewController = initialViewController;
}
- (IBAction)clickedAdminCard:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AllCards" bundle:nil];
    UIViewController * initialViewController = [storyboard instantiateViewControllerWithIdentifier:@"AllCardsViewController"];
    self.view.window.rootViewController = initialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        NSLog(@"ipad");
        [self.settingButton setHidden:NO];
        [self.cardButton setHidden:NO];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-bas
 ed application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

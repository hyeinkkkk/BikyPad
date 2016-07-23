//
//  WriteGuestbookViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 9..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "WriteGuestbookViewController.h"
#import "PJRSignatureView.h"
#import "PrinterController.h"
#import "DoneGuestbookViewController.h"
#import "SelectBalloonViewController.h"
#import "CompleteGuestbookViewController.h"
#import "PlayerHomeViewController.h"
#import "HTTPClient.h"

@interface WriteGuestbookViewController ()
{
    PJRSignatureView *writeView;
    PrinterController *printer;
}
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end

@implementation WriteGuestbookViewController

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
    // Do any additional setup after loading the view.
    NSLog(@"index ??? %d",self.balloonIndex);
    printer = [PrinterController printerController];
    
//    self.barcode = @"8806920001323";
//    self.balloonIndex = 3;
//    self.wroteCount = 1;
    NSLog(@"wroteCount ? %@",self.wroteCount);
    self.countLabel.text = [NSString stringWithFormat:@"%@",self.wroteCount];
    writeView = [[PJRSignatureView alloc] initWithFrame:CGRectMake(215 , 124, 584 ,584)]; //self.view.bounds.size.width - 400, self.view.bounds.size.height-20)];
    [writeView setBackgroundImage:[NSString stringWithFormat:@"balloon_%d",self.balloonIndex]];
    [self.view addSubview:writeView];
    NSLog(@"들어왔니???");
}
- (IBAction)clearWriteView:(id)sender {
    [writeView clearSignature];
}


- (IBAction)printBalloon:(id)sender {
    UIImage *img = [self imageWithView:writeView];

    [printer printBalloon:img];
    HTTPClient *client = [HTTPClient httpClient];
    [client uploadImage:img
                 serial:self.barcode
    imageUploadResponseWithCallback:^(id response){
        NSLog(@"print Balloon-------------->%@",response);
        if([response isEqual:@"full"]){
            NSLog(@"full ????? %d",[response isEqual:@"full"]);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:@"이미 모든 카드를 획득하셨습니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            [alertView show];
            
        }
        else{
            NSLog(@"else ");
            [self performSegueWithIdentifier:@"CompleteGuestbook" sender:sender];
        }
        
//        CompleteGuestbookViewController *completeGuestbookViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteGuestbookViewController"];
//        completeGuestbookViewController.barcode = self.barcode;
//        [self presentViewController:completeGuestbookViewController animated:YES completion:nil];

}
     ];
    
}

- (UIImage *) imageWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, 0.0, self.view.bounds.size.height+200);
    
    UIGraphicsEndImageContext();
    
    return img;
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
    if([[segue identifier] isEqualToString:@"CompleteGuestbook"]){
        CompleteGuestbookViewController *dest = (CompleteGuestbookViewController *)[segue destinationViewController];
        dest.barcode = self.barcode;
    }
}


@end

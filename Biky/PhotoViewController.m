//
//  PhotoViewController.m
//  Biky
//
//  Created by Hyein on 2015. 6. 22..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "PhotoViewController.h"
#import "BXCode.h"


@interface PhotoViewController (){
    
}
@property (weak, nonatomic) IBOutlet UITextField *textName;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (strong, nonatomic) BXPrinterController * pController;
//@property (strong,nonatomic) BXPrinter *printer;
@end

@implementation PhotoViewController

- (IBAction)printPaper:(id)sender {
    _pController.textEncoding = BXL_TEXTENCODING_KSC5601;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;

    NSLog(@"connect ??? %d",[_pController connect]);
//    NSString * txt = @"플레이어 : 2~4명 \n   예상 시간 : 5분 이내 \n    게임 룰 \n    1. 중앙(달)에 플레이어가 다 모인다 \n    2. 플레이어 별로 지구로 내려갈 길을 정한다.\n    3. 시작과 동시에 각자 길을 따라 지구로 내려간다.\n    단, 숫자 1부터 10까지 순서대로 밟으면서 지구로 내려가야 한다.\n    4. 가장 먼저 지구에 도착한 사람이 승리한다. \n";
//    [_pController printText:[NSString stringWithFormat:@" %@",txt]];
    
    [_pController printText:[NSString stringWithFormat:@" %@",self.textName.text]];
    [self printImage:self.imageView.image];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //printer init
    [self printerInitialize];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
            message:@"Device has no camera"
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)didFindPrinter:(BXPrinterController *)controller
               printer:(BXPrinter *)printer
{
//    NSLog(@"didFindPrinter \r\n    * target Name : %@    * target BDN : %@", printer.name, printer.bluetoothDeviceName);
    
    //Add 7
    controller.target = printer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) printerInitialize
{
    NSLog(@"printerInit??");
    _pController = [BXPrinterController getInstance];
    _pController.delegate       = self;
    _pController.lookupCount    = 5;
    _pController.AutoConnection = BXL_CONNECTIONMODE_NOAUTO;

    [_pController open];
    
    _printer = [BXPrinter new];

    _printer.address = [NSString stringWithFormat:@"192.168.1.95"];
    _printer.port = 9100;
    _printer.connectionClass = BXL_CONNECTIONCLASS_ETHERNET;

    NSLog(@"printer %@", _printer);
    NSLog(@" pCtl %@",_pController);

    _pController.target = _printer;
    [_pController selectTarget];
    
    if( NO==[_pController connect] )
        NSLog(@"Connect Error");
    
    _pController.textEncoding = BXL_TEXTENCODING_KSC5601;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
    
    if (BXL_SUCCESS == [_pController printText:@"TEST"]) {
        NSLog(@"print ??");
        [_pController lineFeed:1];
    }

    
}


- (IBAction)takePhoto :(id)sender{
//    _pController.textEncoding = BXL_TEXTENCODING_KSC5601;
//    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
//    
//    NSLog(@"connect ??? %d",[_pController connect]);
//    if (BXL_SUCCESS == [_pController printText:@"TEST"]) {
//        NSLog(@"print ??");
//        [_pController lineFeed:1];
//        [_pController printBitmapWithImage:[UIImage imageNamed:@"test.jpg"] width:BXL_WIDTH_FULL level:1030];
//        [_pController lineFeed:10];
//    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSLog(@"picker is %@",picker.delegate);
    [self presentViewController: picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)printImage:(UIImage *)photo{

    NSLog(@"print ??");
    [_pController lineFeed:1];
    [_pController printBitmapWithImage:photo width:BXL_WIDTH_FULL level:1030];
    [_pController lineFeed:10];


}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    NSLog(@"image is %@",self.imageView.image);
    UIImageWriteToSavedPhotosAlbum (chosenImage, nil, nil , nil);
//    [self printImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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

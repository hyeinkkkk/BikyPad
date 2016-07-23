//
//  BarcodeScanViewController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 1..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "BarcodeScanViewController.h"
#import "CreateIDViewController.h"
#import "CompleteIDViewController.h"
#import "ResultViewController.h"
#import "PrintCardViewController.h"
#import "DateListViewController.h"
#import "FloorPlayResultViewController.h"
#import "SelectBalloonViewController.h"
#import "PrintConfirmViewController.h"
#import "PlayerLogListViewController.h"
#import "NumberKeypadViewController.h"
#import "Constants.h"
#import "HTTPClient.h"
#import <AVFoundation/AVFoundation.h>

@interface BarcodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_captureDevice;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    AVCaptureConnection *_previewLayerConnection;
    
    UIView *_highlightView;
    UILabel *_label;
    UIButton *_button, * _numberKeypadButton;
    
    UIDevice *_device;
    NSInteger _orientation;
    
    __weak IBOutlet UILabel *barcodeText;
    BOOL sendMessage;
}
@end

@implementation BarcodeScanViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"INIT");
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBarcodeSerial:) name:BarcodeSerialNotification object:nil];
        _device = [UIDevice currentDevice];
        [_device beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        _orientation = [_device orientation];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange{
    NSLog(@"deviceOrientation %ld",[_device orientation]);
    
//    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _orientation = [_device orientation];
    
    switch (_orientation) {
        case 1:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            break;
        case 2:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
            break;
        case 3:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            break;
        default:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sendMessage = NO;
    
    NSLog(@"player is .. %@",self.data);
    // Do any additional setup after loading the view.
//    [self deviceOrientationDidChange];
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    _numberKeypadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _numberKeypadButton.frame = CGRectMake(90, self.view.bounds.size.height - 70, self.view.bounds.size.width-400, 60);
    _numberKeypadButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _numberKeypadButton.tintColor = [UIColor whiteColor];
    _numberKeypadButton.backgroundColor = [UIColor colorWithRed:0.36 green:0.68 blue:0.2 alpha:1];//colorWithWhite:0.15 alpha:0.65];
    _numberKeypadButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20.0];
    [_numberKeypadButton addTarget:self action:@selector(goNumberKeypad:) forControlEvents:UIControlEventTouchUpInside];
    [_numberKeypadButton setTitle:@"직접 바코드 번호 입력하기" forState:UIControlStateNormal];
    
    [self.view addSubview:_numberKeypadButton];
    
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = CGRectMake(self.view.bounds.size.width-290, self.view.bounds.size.height - 70, 200, 60);
    _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _button.tintColor = [UIColor blackColor];
    _button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20.0];
    _button.backgroundColor = [UIColor whiteColor];
    [_button addTarget:self action:@selector(switchCameraTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"카메라종료" forState:UIControlStateNormal];
    
    [self.view addSubview:_button];
    
    _session = [[AVCaptureSession alloc] init];
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _previewLayerConnection = _prevLayer.connection;
    
    //    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
    //        //ipad 가로모드일때 카메라를 돌린다.
    ////        [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    //        [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    //    }
    
    switch (_orientation) {
        case 0:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
            break;
        case 1:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            break;
        case 3:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            break;
        default:
            [_previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
            break;
    }
    
    
    [self.view.layer addSublayer:_prevLayer];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
    [self.view bringSubviewToFront:_button];
    [self.view bringSubviewToFront:_numberKeypadButton];
    [_session startRunning];
    
}

- (void)getBarcodeSerial:(NSNotification *) noti{
    NSLog(@"######## getBarcodeSerial noti??? %@",noti.userInfo);
    NSLog(@"self.action? %@",self.action);
    NSString * detectionString = noti.userInfo[@"barcode"];
    
    if([self.action isEqual: @"create_player"]){
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CreateIDNotification object:nil userInfo:@{@"barcode":detectionString}];
        }];
        
    } // end of create_player
    else if([self.action  isEqual: @"update_player"]){
        HTTPClient *client = [HTTPClient httpClient];
//        [client phone: self.data[@"phone_number"] barcode:detectionString updatePlayerWithCallback: ^(id response){
        [client playerId:noti.userInfo[@"data"][@"_id"] barcode:detectionString updatePlayerWithCallback: ^(id response){
        NSLog(@"%@",response);
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateIDNotification object:nil userInfo:@{@"name":self.data[@"name"]}];
            }];
        }];
    } // end of update_player
    else if([self.action isEqual: @"floor_play"]){
        [self sendNotificationWithBarcode:FloorPlayListNotification barcode:detectionString];
        
    }// end of floor_play
    else if([self.action isEqual: @"movie"]){
        [self sendNotificationWithBarcode:DateListNotification barcode:detectionString];
        
    }// end of movie
    else if([self.action isEqual: @"print_card"]){
        [self sendNotificationWithBarcode:PlayerHomeNextNotification barcode:detectionString];
        
    }// end of print_card
    else if([self.action isEqual:@"print_guestbook"]){
        [self sendNotificationWithBarcode:PlayerHomeNextNotification barcode:detectionString];
        
    }// end of print_guestbook
    else if([self.action isEqual: @"print_activities"]){
        [self sendNotificationWithBarcode:PlayerHomeNextNotification barcode:detectionString];
        
    }// end of print_activities
    else if([self.action isEqual:@"playerLog"]){
        
        HTTPClient *client = [HTTPClient httpClient];
        [client barcode: (NSString *) detectionString
getPlayerAlldayActivitiesWithCallback:^(id response){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PlayerLog"
                                                                 bundle:nil];
            PlayerLogListViewController *playerLogListViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerLogListViewController"];
            
            playerLogListViewController.playerActivities = response;
            [self presentViewController:playerLogListViewController animated:YES completion:nil];
        }];
    }
}

- (void) goNumberKeypad:(UIButton *)sender{
    NumberKeypadViewController *numberKeypadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NumberKeypadViewController"];
    numberKeypadViewController.action = self.action;
    if([self.action isEqualToString:@"update_player"]){
        numberKeypadViewController.data = self.data;
    }

    [self presentViewController:numberKeypadViewController animated:YES completion:nil];
}

-(void) switchCameraTapped: (UIButton *) sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    //Change camera source
//    if(_session)
//    {
//        //Indicate that some changes will be made to the session
//        [_session beginConfiguration];
//        
//        //Remove existing input
//        AVCaptureInput* currentCameraInput = [_session.inputs objectAtIndex:0];
//        [_session removeInput:currentCameraInput];
//        
//        //Get new input
//        AVCaptureDevice *newCamera = nil;
//        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
//        {
//            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
//        }
//        else
//        {
//            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
//        }
//        
//        //Add input to session
//        NSError *err = nil;
//        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
//        if(!newVideoInput || err)
//        {
//            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
//        }
//        else
//        {
//            [_session addInput:newVideoInput];
//        }
//        
//        //Commit all the configuration changes at once
//        [_session commitConfiguration];
//    }
}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            [_output setMetadataObjectsDelegate:nil queue:dispatch_get_main_queue()];

            _label.text = detectionString;
            NSLog(@"serial is %@",detectionString);
            
            [_prevLayer removeFromSuperlayer];
            
            if([self.action isEqual: @"create_player"]){
                if (sendMessage)
                    break;
                sendMessage = YES;
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:CreateIDNotification object:nil userInfo:@{@"barcode":detectionString}];
                }];
//                NSLog(@"create_player?");
                
            } // end of create_player
            else if([self.action  isEqual: @"update_player"]){
                if (sendMessage)
                    break;
                sendMessage = YES;
                HTTPClient *client = [HTTPClient httpClient];
//                [client phone: self.data[@"phone_number"] barcode:detectionString updatePlayerWithCallback: ^(id response){
                [client playerId:self.data[@"_id"] barcode:detectionString updatePlayerWithCallback: ^(id response){
                NSLog(@"%@",response);
                    NSLog(@"after scan %@", self.data);
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateIDNotification object:nil userInfo:@{@"name":self.data[@"name"]}];
                    }];
                }];
            } // end of update_player
            else if([self.action isEqual: @"floor_play"]){
                if (sendMessage)
                    break;
                sendMessage = YES;
                
                [self sendNotificationWithBarcode:FloorPlayListNotification barcode:detectionString];
                
            }// end of floor_play
            else if([self.action isEqual: @"movie"]){
                
                [self sendNotificationWithBarcode:DateListNotification barcode:detectionString];
                
   
            }// end of movie
            else if([self.action isEqual: @"print_card"]){
                if (sendMessage)
                    break;
                sendMessage = YES;
                [self sendNotificationWithBarcode:PlayerHomeNextNotification barcode:detectionString];
                
            }// end of print_card
            else if([self.action isEqual:@"print_guestbook"]){
                [self sendNotificationWithBarcode:PlayerHomeNextNotification barcode:detectionString];
                
            }// end of print_guestbook
            else if([self.action isEqual: @"print_activities"]){
                if (sendMessage)
                    break;
                sendMessage = YES;
                [self sendNotificationWithBarcode:PlayerHomeNextNotification barcode:detectionString];
                
                
            }// end of print_activities
            else if([self.action isEqual:@"playerLog"]){
                if(sendMessage)
                    break;
                sendMessage = YES;
                
                NSLog(@"%@", detectionString);

                HTTPClient *client = [HTTPClient httpClient];
                        [client barcode: (NSString *) detectionString
  getPlayerAlldayActivitiesWithCallback:^(id response){
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PlayerLog"
                                                                             bundle:nil];
                        PlayerLogListViewController *playerLogListViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerLogListViewController"];
      
      
                        playerLogListViewController.playerActivities = response;
                        [self presentViewController:playerLogListViewController animated:YES completion:nil];
                    }];
            }

            
            break;
        }

    }
    
    _highlightView.frame = highlightViewRect;
}

-(void) sendNotificationWithBarcode:(NSString *)noti barcode:(NSString *)barcode{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:noti object:nil userInfo:@{@"barcode": barcode , @"action" : self.action }];
    }];
    
}

- (IBAction)clickedOKButton:(id)sender {
    NSLog(@"barcode!!! %@", barcodeText.text);
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

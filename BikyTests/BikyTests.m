//
//  BikyTests.m
//  BikyTests
//
//  Created by Hyein on 2015. 6. 22..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HTTPClient.h"
#import "PrinterController.h"

@interface BikyTests : XCTestCase

@end

@implementation BikyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"Login"];
    HTTPClient *client = [[HTTPClient alloc] init];
    [client getFriendsWithCallback:^(id response){
        NSLog(@"RRR %@", response[@"atmCount"]);
        [exp fulfill];
        XCTAssertNotNil(response, @"ViewController should contain a view");
        XCTAssertEqual(107, [response[@"atmCount"] intValue], @"ATM");
        XCTAssertEqual(1, [response[@"game"] count], @"ATM");
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];

}

- (void) testCreatePlayer {
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"create"];
//    HTTPClient *client = [[HTTPClient alloc] init];
    
    HTTPClient *client = [HTTPClient httpClient];
    
    [client name:@"hyein" phone:@"50323" barcode:@"2874829837" birthyear:@"1991" gender:@"Female" createPlayerWithCallback:^(id response) {
        [exp fulfill];
        NSLog(@"%@",response);
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void)testSearchPlayer {
    HTTPClient *client = [HTTPClient httpClient];

    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get Player"];

    [client phone: @"2" name:@"ㅓ" getPlayerByPhoneNumberWithCallback: ^(id response){
        [exp fulfill];
        NSLog(@"%@",response);
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void)testgetPlayerByBarcode {
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get Player"];
    
    [client barcode:@"0021500083" getPlayerByBarcodeWithCallback: ^(id response){
        [exp fulfill];
        NSLog(@"testgetPlayerByBarcode  ? %@",response); //실패시 0
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void) testGetCards{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get Player"];
    
    [client getAllCardsWithCallback: ^(id response){
        [exp fulfill];
        NSLog(@"testgetPlayerGuestbook  ?? %@",response); //fail 0
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void) testgetPlayerGuestbook{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get Player"];
    
    [client barcode:@"00247215000" getPlayerGuestBookWithCallback: ^(id response){
        [exp fulfill];
        NSLog(@"testgetPlayerGuestbook  ?? %@",response); //fail 0
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void)testupdatePlayer {
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"update Player"];
    
//    [client phone:@"3" barcode:@"5355" updatePlayerWithCallback: ^(id response){
    [client playerId:@"sdf23rwsdf" barcode:@"234323" updatePlayerWithCallback: ^(id response){
    [exp fulfill];
        NSLog(@"5355 ????? %@",response); //fail 0
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void)testgetFloor {
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get Floor"];
    
    [client getFloorPlayListWithCallback:^(id response){
        [exp fulfill];
        NSLog(@"%@",response);
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void) testgetDate{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get Date"];
    
    [client getDateListWithCallback:^(id response){
        [exp fulfill];
        NSLog(@"%@",response);
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];

}

- (void) testFloorCreateActivity{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"create avvvv"];

    
    [client floorId:@"55a89dbb6aaccc2aa92eb10f" barcode:@"12290537" createPlayerActivityWithCallback:^(id response) {
        NSLog(@"Floor_play response????? %@",response); //fail 0
        [exp fulfill];
        NSLog(@"%@",response);
    }];
    
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        
        // handle failure
    }];
}

- (void) testcreateActivity{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"create avvvv"];
    
    NSDictionary * object = @{
     @"session_order": @"1",
     @"session_ko" : @"아버지 자전거와 나의 이야기",
     @"theater_ko": @"하늘연극장",
     @"theater_en": @"Haneulyeon",
     @"date": @"30",
     @"month": @"7"
     };
    
    [client movie:object
          barcode:@"8849159184"
createPlayerActivityWithCallback:^(id response) {
        [exp fulfill];
        NSLog(@"movie create??? %@",response); //fail - exist
    }];

    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {

        // handle failure
    }];
}

- (void) testGetMovies{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get movies"];
    
    [client date:@"8-4" getMovieListWithCallback:^(id response){
        [exp fulfill];
        NSLog(@"%@",response);
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void) testGetActivities{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"get activity"];
    
    [client barcode:@"88089159184"
            getPlayerActivityWithCallback:^(id response) {[exp fulfill];}
     ];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void) testPrint{
    PrinterController *printer = [PrinterController printerController];
    NSDictionary * card = @{
                            @"_id" : @"559cb6d16aaccc1a43290c1a",
                            @"title_en" : @"How to steal a Dog",
                            @"action_en" : @"",
                            @"director" : @"senior",
                            @"index" : @78,
                            @"action_ko" : @"훔쳐",
                            @"title_ko" : @"개를 훔치는 완벽한 방법"
                            };
    
    [printer printCard:card awardCount:2 playerName:@"hyein"];
    
}

- (void) testActivities{

    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"test Activites"];
    
    [client barcode: (NSString *) @"88089159184"
     getPlayerTodayActivityWithCallback:^(id response){
        [exp fulfill];
        NSLog(@"-------------->%@",response); //fail - 0
        }
     ];
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        // handle failure
    }];
    
}

- (void) testPutActivities{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"test Activites"];
    
    [client barcode:@"883949159184" director:@"senior" card:@"559fbbbf6aaccc3110ce76f4" updatePlayerActivityWithCallback:^(id response){
    [exp fulfill];
    NSLog(@"-------------->%@",response); //fail - 0
}
     ];
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void) testTodayActivities{
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"test Activites"];
    
    [client barcode:@"00247200083" getPlayerTodayActivityWithCallback:^(id response){
        [exp fulfill];
        NSLog(@"-------------->%@",response); // fail - 0
    }];
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void)testUpload{
    UIImage *image = [UIImage imageNamed:@"11.jpg"];
    HTTPClient *client = [HTTPClient httpClient];
    
    XCTAssert(YES, @"Pass");
    XCTestExpectation *exp = [self expectationWithDescription:@"done upload"];
    
    [client uploadImage:image
                 serial:@"0024721500083"
    imageUploadResponseWithCallback:^(id response){
                [exp fulfill];
                NSLog(@"-------------->%@",response);
            }
     ];
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        // handle failure
    }];

}

@end

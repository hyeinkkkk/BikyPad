//
//  HTTPClient.h
//  Biky
//
//  Created by Hyein on 2015. 6. 25..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"

typedef void (^NetworkErrorBlock)(NSString *errorMessage);

@interface HTTPClient : NSObject

@property (strong) NetworkErrorBlock commonErrorCallback;
@property (readonly) NSString *address;

+ (HTTPClient *) httpClient;

//- (id) initSingleton;

- (void) getFriendsWithCallback:(void (^)(id))callback;

- (void) name: (NSString *) game_id
        phone: (NSString *) player_id
      barcode: (NSString *) barcode
    birthyear: (NSString *) birthyear
      gender : (NSString *) gender
        createPlayerWithCallback:(void (^)(id))callback;

- (void) barcode: (NSString *) barcode
getPlayerByBarcodeWithCallback: (void (^)(id))callback;

- (void) phone: (NSString *) phone
          name: (NSString *) name
getPlayerByPhoneNumberWithCallback: (void (^)(id))callback;

//- (void) phone: (NSString *) phone
//       barcode: (NSString *) barcode
- (void) playerId: (NSString *) playerId
          barcode: (NSString *) barcode
updatePlayerWithCallback: (void (^) (id))callback;

- (void) getFloorPlayListWithCallback: (void (^) (id))callback;

- (void) getDateListWithCallback:(void (^) (id))callback;

- (void) date: (NSString *)date
getMovieListWithCallback: (void (^) (id))callback;

- (void) floorId : (NSString *) floorId
         barcode : (NSString *) barcode
createPlayerActivityWithCallback:(void (^) (id))callback;

- (void) movie: (NSDictionary *)movie
      barcode : (NSString *) barcode
createPlayerActivityWithCallback:(void (^) (id))callback;

- (void) barcode: (NSString *) barcode
getPlayerActivityWithCallback: (void (^) (id))callback;

- (void) barcode: (NSString *) barcode
getPlayerGuestBookWithCallback: (void (^) (id))callback;

- (void) barcode: (NSString *) barcode
getPlayerTodayActivityWithCallback: (void (^) (id))callback;

- (void) barcode:(NSString *) barcode
getPlayerAlldayActivitiesWithCallback: (void (^) (id))callback;


- (void)uploadImage:(UIImage *)image
             serial:(NSString *)serial
imageUploadResponseWithCallback: (void (^) (id))callback;

- (void) barcode:(NSString *)barcode
        director:(NSString *)director
            card:(NSString *)cardId
updatePlayerActivityWithCallback: (void (^) (id))callback;

- (void)getAllCardsWithCallback: (void (^) (id))callback;

- (void) barcode:(NSString *)barcode
updatePlayerPrintStateWithCallback: (void (^) (id))callback;

@end

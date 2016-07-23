//
//  HTTPClient.m
//  Biky
//
//  Created by Hyein on 2015. 6. 25..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient {
    AFHTTPRequestOperationManager* _manager;
    AFURLSessionManager* _sessionManager;
}

- (id) init{
    if (self = [super init]) {
        _address = @"http://localhost:9009";//@"http://175.126.74.17:9009";//@"http://1.234.22.137:9009";
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

+ (HTTPClient *) httpClient{
    static HTTPClient * instance = nil;
    
    if (instance != nil){
        return instance;
    }
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
      {
          instance = [[HTTPClient alloc] init];
      });
    return instance;
}

- (void)makeRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters callback:(void (^)(id))callback {

    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:[NSString stringWithFormat:@"%@/%@", _address, path] parameters:parameters error:NULL];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"HTTP Response Status Code: %ld", (long)[operation.response statusCode]);
          NSLog(@"HTTP Response Body: %@", responseObject);
          switch ([operation.response statusCode]) {
              case 500:
                  self.commonErrorCallback(responseObject[@"error"]);
                  break;
              case 404:
                  callback(responseObject[@"error"]);
                  break;
              default:
                  callback(responseObject[@"response"]);
                  break;
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          self.commonErrorCallback(error.localizedDescription);
          NSLog(@"error");
      }];
    
    [_manager.operationQueue addOperation:operation];
}

- (void)getFriendsWithCallback:(void (^)(id))callback {
    [_manager GET:[NSString stringWithFormat:@"%@/player", _address] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.commonErrorCallback(error.localizedDescription);
    }];
}

- (void) name: (NSString *) name
        phone: (NSString *) phone
      barcode: (NSString *) barcode
    birthyear: (NSString *) birthyear
      gender : (NSString *) gender

createPlayerWithCallback:(void (^)(id))callback{
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"name": name,
                                 @"phone_number": phone,
                                 @"serial": barcode,
                                 @"birthyear" : birthyear,
                                 @"sex" : gender
                                 };
    
    [self makeRequestWithMethod:@"POST" path:@"players" parameters:bodyObject callback:callback];
    
}

- (void) barcode: (NSString *) barcode
getPlayerByBarcodeWithCallback: (void (^)(id))callback{
    // Create request
    NSDictionary* urlParameters = @{ @"serial":barcode};
    
    [self makeRequestWithMethod:@"GET" path:@"players" parameters:urlParameters callback:callback];

}


- (void) phone: (NSString *) phone
          name: (NSString *) name
getPlayerByPhoneNumberWithCallback: (void (^)(id))callback{
    NSDictionary* urlParameters = @{ @"phone_number":phone, @"name" : name};
    
    [self makeRequestWithMethod:@"GET" path:@"players" parameters:urlParameters callback:callback];

}

//- (void) phone: (NSString *) phone
//       barcode: (NSString *) barcode
- (void) playerId: (NSString *) playerId
          barcode: (NSString *) barcode
updatePlayerWithCallback: (void (^) (id))callback{
    NSDictionary* bodyObject = @{
//                                 @"phone_number": phone,
                                 @"serial": barcode,
                                 @"player_id":playerId
                                 };
    
    [self makeRequestWithMethod:@"PUT" path:@"players" parameters:bodyObject callback:callback];
}

- (void) getFloorPlayListWithCallback: (void (^) (id))callback{
    
    [self makeRequestWithMethod:@"GET" path:@"floors" parameters:nil callback:callback];

}

- (void) floorId : (NSString *) floorId
        barcode : (NSString *) barcode
    createPlayerActivityWithCallback:(void (^) (id))callback{
    NSDictionary* bodyObject = @{
                                 @"floor_id": floorId
                                 };
    NSLog(@"==================== object is %@", bodyObject);
    [self makeRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"date-activities/%@", barcode] parameters:bodyObject callback:callback];

}

- (void) getDateListWithCallback:(void (^) (id))callback{
    [self makeRequestWithMethod:@"GET" path:@"screening-dates" parameters:nil callback:callback];

}

- (void) movie: (NSDictionary *)movie
      barcode : (NSString *) barcode
createPlayerActivityWithCallback:(void (^) (id))callback{
    
    NSDictionary* bodyObject = movie;
    [self makeRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"date-activities/%@", barcode] parameters:bodyObject callback:callback];
    
    }

- (void) date: (NSString *)date
    getMovieListWithCallback: (void (^) (id))callback{

    [self makeRequestWithMethod:@"GET" path:[NSString stringWithFormat:@"movies/%@", date] parameters:nil callback:callback];

}

- (void) barcode: (NSString *) barcode
getPlayerActivityWithCallback: (void (^) (id))callback{
    
    NSDictionary* parameters = @{ @"serial": barcode };
    
    [self makeRequestWithMethod:@"GET" path:@"dates-activities" parameters:parameters callback:callback];

}

- (void) barcode: (NSString *) barcode
getPlayerGuestBookWithCallback: (void (^) (id))callback{
    [self makeRequestWithMethod:@"GET" path:[NSString stringWithFormat:@"guests-book/%@", barcode] parameters:nil callback:callback];
  
}


- (void) barcode: (NSString *) barcode
getPlayerTodayActivityWithCallback: (void (^) (id))callback{
    // Create request
//    NSDictionary* parameters = @{ @"serial": barcode };
    
    [self makeRequestWithMethod:@"GET" path:[NSString stringWithFormat:@"date-activities/%@", barcode] parameters:nil callback:callback];

}

- (void) barcode: (NSString *) barcode
getPlayerAlldayActivitiesWithCallback: (void (^) (id))callback{
    [self makeRequestWithMethod:@"GET" path:[NSString stringWithFormat:@"player-log/%@", barcode] parameters:nil callback:callback];

}


- (void)uploadImage:(UIImage *)image
             serial:(NSString *)serial
imageUploadResponseWithCallback:(void(^)(id))callback {

    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@/guests-book/%@", _address, serial] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"filearg" fileName:@"guestbook" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [sessionManager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            callback(error);
        } else {
            callback(responseObject[@"response"]);
            
        }
    }];
    
    [uploadTask resume];
    
}

- (void) barcode:(NSString *)barcode
        director:(NSString *)director
            card:(NSString *)cardId
updatePlayerActivityWithCallback: (void (^) (id))callback{
    
    NSDictionary* bodyObject = @{
                                 @"_id": cardId, //@"559fbbbf6aaccc3110ce76f4",
                                 @"director": director //@"senior"
                                 };
    
    [self makeRequestWithMethod:@"PUT" path:[NSString stringWithFormat:@"date-activities/%@", barcode] parameters:bodyObject callback:callback];

}

- (void)getAllCardsWithCallback: (void (^) (id))callback{
    
    [self makeRequestWithMethod:@"GET" path:@"cards" parameters:nil callback:callback];
}



- (void) barcode: (NSString *) barcode
updatePlayerPrintStateWithCallback: (void (^) (id))callback{
    NSLog(@"barcode is :::::: %@", barcode);
    [self makeRequestWithMethod:@"PUT" path:[NSString stringWithFormat:@"restore-date-activities/%@", barcode] parameters:nil callback:callback];
    
}
@end


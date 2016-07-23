//
//  PrinterController.h
//  Biky
//
//  Created by Hyein on 2015. 7. 8..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXPrinterController.h"
#import "BXPrinterControlDelegate.h"

@interface PrinterController : NSObject <BXPrinterControlDelegate>
{
    BXPrinterController* _pController;
    BXPrinter * _printer;
}

@property NSString *address;
@property NSString *mode;

+ (PrinterController*) printerController;

- (id) initSingleton;
- (void) selectPrinterTaget:(NSString *)mode address:(NSString *)address;
- (void) printCard:(NSDictionary *)card awardCount:(NSUInteger)awardCount playerName:(NSString *)playerName;
- (void) printDirectorCard: (NSDictionary *) card awardCount:(NSUInteger)awardCount playerName:(NSString *)playerName;
- (void) printTodayResult:(NSArray *) activities playerName:(NSString *)playerName awardCount:(NSUInteger)count dircectorCount:(NSUInteger) directorCount;
- (void) printBalloon:(UIImage *)balloon;
- (void) printTest;
- (void) printTestImage;
//- (NSDate *) convertTime:(NSString *) time;

@end

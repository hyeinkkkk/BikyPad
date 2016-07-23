//
//  PrinterController.m
//  Biky
//
//  Created by Hyein on 2015. 7. 8..
//  Copyright (c) 2015년 Nolgong. All rights reserved.
//

#import "PrinterController.h"
#import "HTTPClient.h"

@implementation PrinterController

- (void)didFindPrinter:(BXPrinterController *)controller printer:(BXPrinter *)printer {
    NSLog(@"found printer");
    
}

- (void)msrArrived:(BXPrinterController *)controller track:(NSNumber *)track {
    NSLog(@"msr arrived");
}

- (void) printTest{
    [_pController printText:@"감독\n"];
}

- (void) printTestImage{
    for(int i=67;i<=100;i++){
        [_pController printText:[NSString stringWithFormat:@"%d \n",i]];
        [_pController printBitmapWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]] width:BXL_WIDTH_FULL level:1035];
        [_pController lineFeed:2];

    }
//    [_pController printBitmapWithImage:[UIImage imageNamed:@"21.jpg"] width:BXL_WIDTH_FULL level:1035];
//    [_pController printBitmapWithImage:[UIImage imageNamed:@"42.jpg"] width:BXL_WIDTH_FULL level:1035];
//    [_pController printBitmapWithImage:[UIImage imageNamed:@"61.jpg"] width:BXL_WIDTH_FULL level:1035];
//    [_pController printBitmapWithImage:[UIImage imageNamed:@"79.jpg"] width:BXL_WIDTH_FULL level:1035];
}

- (id) initSingleton{
    if((self = [super init])){
        NSLog(@"printerInit??");
        _pController = [BXPrinterController getInstance];
        _pController.delegate       = self;
        _pController.lookupCount    = 5;
        _pController.AutoConnection = BXL_CONNECTIONMODE_NOAUTO;
        
        [_pController open];
        
        
//        _printer.macAddress = @w //ivory2
//          _printer.macAddress = @"74:F0:7D:E7:DA:A8"; //ivory
//        _printer.macAddress = @"74:F0:7D:E2:23:4C"; //black
//        _printer.connectionClass = BXL_CONNECTIONCLASS_BT;
        
//        _printer.connectionClass = BXL_CONNECTIONCLASS_ETHERNET;
//        _printer.address = @"192.168.1.95";//[NSString stringWithFormat:@"192.168.192.123"];
//        _printer.port = 9100;
        
    }
    return self;
}

- (void) selectPrinterTaget:(NSString *)mode address:(NSString *)address{
    NSLog(@"mode??? %@",mode);
    NSLog(@"address ?? %@",address);
    
    _printer = [BXPrinter new];
    
    if ([mode isEqualToString:@"bluetooth"]){
        _printer.macAddress = address;
        _printer.connectionClass = BXL_CONNECTIONCLASS_BT;
    }
    else{
        _printer.connectionClass = BXL_CONNECTIONCLASS_ETHERNET;
        _printer.address = address;
        _printer.port = 9100;
    }
    _pController.target = _printer;
    [_pController selectTarget];
    
    if( NO==[_pController connect] )
        NSLog(@"Connect Error");
    
    _pController.textEncoding = BXL_TEXTENCODING_KSC5601;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
}

+ (PrinterController *) printerController{
    static PrinterController * instance = nil;
    
    if(instance != nil){
        return instance;
    }
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
    {
        instance = [[PrinterController alloc] initSingleton];
    });
    
    return instance;
}

- (NSString *) convertTimeZone:(NSString *) time {
    NSString * timeStampString = time;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSLog(@"Date String is ? %@",dateString);
    return dateString;
}

- (void) frontTemplete: (NSString*) playerName{
    [_pController lineFeed:1];
    //    [_pController printBitmapWithImage:photo width:BXL_WIDTH_FULL level:1030];
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    [_pController printText:[NSString stringWithFormat:@"%@ \n", dateString]];
    
    [_pController printText:[NSString stringWithFormat:@"ID: %@ \n", playerName]];
    
    [_pController lineFeed:2];
    
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    [_pController printText:@"    제 10회 부산국제어린이청소년영화제\n"];
    
    [_pController printBitmapWithImage:[UIImage imageNamed:@"logo_storyplaying_print"] width:BXL_WIDTH_FULL level:50];
    _pController.alignment = BXL_ALIGNMENT_CENTER;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController lineFeed:1];
    [_pController printText:@"다름을 찾아라!"];
    [_pController lineFeed:1];
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------"];
    [_pController lineFeed:1];
    
}

- (void) printCard:(NSDictionary *)card awardCount:(NSUInteger)awardCount playerName:(NSString *)playerName{
    
    [self frontTemplete:playerName];
    
    _pController.alignment = BXL_ALIGNMENT_RIGHT;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
    [_pController printText:[NSString stringWithFormat:@"%@ / 100\n", card[@"index"]]];
    [_pController lineFeed:1];
    
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    [_pController printText:@"영화명: \n"];
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
    NSString * title_ko = [card[@"title_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n", title_ko]];
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    NSString * title_en = [card[@"title_en"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n", title_en]];
    [_pController lineFeed:1];
    [_pController printBitmapWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",card[@"index"]]] width:BXL_WIDTH_FULL level:1020];
    [_pController lineFeed:1];
    
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:@"액션 문장:\n"];
    _pController.attribute = BXL_FT_DEFAULT;
    NSString * story = [card[@"story_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n\n", story]];
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    NSString * action = [card[@"action_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n", action]];
    
    [_pController lineFeed:2];
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------\n"];
    //    [_pController lineFeed:1];
    
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
    NSString * action_subject = [card[@"action_subject"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n",action_subject]];
    [_pController printBitmapWithImage:[UIImage imageNamed:@"word_bubble.jpg"] width:BXL_WIDTH_FULL level:50];
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    NSString * action_verb = [card[@"action_verb"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n",action_verb]];
    [_pController lineFeed:1];
    
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@"빈 말풍선에 여러분만의 이야기를 담아주세요\n"];
    
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------\n"];
    
    [_pController printBitmapWithImage:[UIImage imageNamed:@"logo.jpg"] width:BXL_WIDTH_FULL level:50];
    
    [_pController lineFeed:5];
    
    [_pController cutPaper];
    
    //    pController.attribute = BXL_FT_BOLD| BXL_FT_UNDERLINE;
    //    [_pController lineFeed:10];
    
}

- (void) printDirectorCard: (NSDictionary *) card awardCount:(NSUInteger)awardCount playerName:(NSString *)playerName{

    [self frontTemplete:playerName];
    _pController.alignment = BXL_ALIGNMENT_RIGHT;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
    [_pController printText:[NSString stringWithFormat:@"%@ / 100\n", card[@"card"]]];
    [_pController lineFeed:1];
    
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    [_pController printText:[NSString stringWithFormat:@"%@ \n",card[@"session_ko"]]];
    _pController.alignment = BXL_ALIGNMENT_CENTER;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;
//    _pController.attribute = BXL_FT_BOLD;
    [_pController lineFeed:1];
    [_pController printText:@"어린이 감독카드\n"];
//    [_pController lineFeed:1];
//    [_pController printBitmapWithImage:[UIImage imageNamed:@"78.jpg"] width:BXL_WIDTH_FULL level:1070];
    [_pController printBitmapWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",card[@"card"]]] width:BXL_WIDTH_FULL level:1035];
    [_pController lineFeed:1];
    
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@"감독\n"];
     [_pController lineFeed:1];
    _pController.attribute = BXL_FT_BOLD;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    NSString * director_name = [card[@"director_name_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n",director_name]];

    [_pController lineFeed:1];
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------\n"];

    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    
    NSLog(@"나이는 ? %@",card[@"age"]);
    
    if(![card[@"age"] isEqual:@""]){
        _pController.attribute = BXL_FT_BOLD;
        [_pController printText:@"나이: "];
        _pController.attribute = BXL_FT_DEFAULT;
        [_pController printText:[NSString stringWithFormat:@"%@ \n",card[@"age"]]];
    }

    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:@"도시/국가: "];
    _pController.attribute = BXL_FT_DEFAULT;
    [_pController printText:[NSString stringWithFormat:@"%@/%@ \n",card[@"city"],card[@"country"]]];
    
    if(![card[@"school"] isEqualToString:@""] || ![card[@"team"] isEqualToString:@""]){
        _pController.attribute = BXL_FT_BOLD;
        [_pController printText:@"소속: "];
        _pController.attribute = BXL_FT_DEFAULT;
        NSString * school = [card[@"school"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        NSString * team = [card[@"team"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        [_pController printText:[NSString stringWithFormat:@"%@ %@\n",school,team]];
    }
    [_pController lineFeed:1];
    
    
    if(![card[@"staff"] isEqualToString:@""]){
        _pController.attribute = BXL_FT_BOLD;
        [_pController printText:@"함께한 친구들\n"];
        _pController.attribute = BXL_FT_DEFAULT;
        NSString * staff = [card[@"staff"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        [_pController printText:[NSString stringWithFormat:@"%@ \n",staff]];
    }
    [_pController lineFeed:1];
    
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:@"간략한 줄거리\n"];
    _pController.attribute = BXL_FT_DEFAULT;
    NSString * synopsis = [card[@"synopsis_ko"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n\n",synopsis]];
    
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:@"연출의도\n"];
    _pController.attribute = BXL_FT_DEFAULT;
    NSString * purpose = [card[@"purpose"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [_pController printText:[NSString stringWithFormat:@"%@ \n\n",purpose]];
    
    
//    [_pController printText:@"나이: 12\n도시/국가: 부산/대한민국\n소속: 김해 봉평 초등학교\n함께한 친구들:\n감독: 이지우  촬영: 권미경  슬레이터: 조민혁, 배우 : 이승현, 김민우, 권미경, 이지우 \n\n간략한 줄거리\n학교에 도착한 현수는 자신의 휴대폰이 가방에서 사라진 걸 알게된다. 그래서 민우와 함께 자신의 휴대폰을 찾기 위해 의심이 가는 동생들을 한명씩 취조하기 시작하는데.. \n\n연출의도\n우리가 항상 쥐고 다니는 휴대폰. 그에 얽힌 재미난 이야기를 만들어보고 싶었다."];
    
    [_pController lineFeed:1];
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------\n"];
//    [_pController lineFeed:1];
    
    
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:[NSString stringWithFormat:@"영화제목 : %@ \n",card[@"title_ko"]]];
    [_pController printText:[NSString stringWithFormat:@"상영날짜 : %@월 %@일 %@\n",card[@"month"],card[@"date"],card[@"day"]]];
    [_pController printText:[NSString stringWithFormat:@"상영시간 : %@-%@ (%@분)\n",card[@"start_time"],card[@"end_time"],card[@"runtime"]]];
    [_pController printText:[NSString stringWithFormat:@"상영장소 : %@\n",card[@"theater_ko"]]];
    
    [_pController lineFeed:1];
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------\n"];
//    [_pController lineFeed:1];
    
    [_pController printBitmapWithImage:[UIImage imageNamed:@"logo.jpg"] width:BXL_WIDTH_FULL level:50];
    
    [_pController lineFeed:5];
    
    [_pController cutPaper];

}

- (void) printTodayResult:(NSArray *) activities playerName:(NSString *)playerName awardCount:(NSUInteger)count dircectorCount:(NSUInteger) directorCount{
    [_pController printBitmapWithImage:[UIImage imageNamed:@"division_top.jpg"] width:BXL_WIDTH_FULL level:50];
    
    [self frontTemplete:playerName];
    
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:playerName];
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@" 님의\n"];
    [_pController lineFeed:1];
    
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_1WIDTH | BXL_TS_1HEIGHT;

    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;

    [_pController printText:[NSString stringWithFormat:@"%@\n",dateString]];
    _pController.attribute = BXL_FT_BOLD;
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@"오늘의 활동은 다음과 같습니다.\n"];
    
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------\n"];
    [_pController lineFeed:1];
    
    for(int i=0;i<[activities count]; i++)
    {
        NSLog(@"나의 활동은 ??? %@",activities[i]);
        NSDictionary * activity = activities[i];

        if([activity[@"type"] isEqual:@"movie"]){
            _pController.alignment = BXL_ALIGNMENT_CENTER;
            _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
            [_pController printBitmapWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",activity[@"card"]]] width:BXL_WIDTH_FULL level:1035];
            _pController.alignment = BXL_ALIGNMENT_LEFT;
            [_pController printText: [NSString stringWithFormat:@"%@ \n",[self convertTimeZone:activity[@"time_stamp"]]]];
            [_pController printText:@"영화관람\n"];
            [_pController printText:[NSString stringWithFormat:@"%@ %@\n",activity[@"movie_ko"],activity[@"movie_en"]]];
            [_pController lineFeed:2];
        }
        else if([activity[@"type"] isEqual:@"floor"]){
            _pController.alignment = BXL_ALIGNMENT_CENTER;
            _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
            [_pController printBitmapWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",activity[@"card"]]] width:BXL_WIDTH_FULL level:1035];
            _pController.alignment = BXL_ALIGNMENT_LEFT;
            [_pController printText: [NSString stringWithFormat:@"%@ \n",[self convertTimeZone:activity[@"time_stamp"]]]];
            [_pController printText:@"바닥놀이\n"];
            [_pController printText:[NSString stringWithFormat:@"%@ %@\n",activity[@"name_ko"],activity[@"name_en"]]];
            [_pController lineFeed:2];

        }
        else if([activity[@"type"] isEqual:@"guestbook"]){
            _pController.alignment = BXL_ALIGNMENT_CENTER;
            _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
            HTTPClient *client = [HTTPClient httpClient];
            NSString * path = [NSString stringWithFormat:@"%@/uploads",client.address]; //@"http://192.168.1.26:8000/uploads/"; //image주소
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.jpg",path,activity[@"guestbook_img"]]];

            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            [_pController printBitmapWithImage:img width:BXL_WIDTH_FULL level:50];
//            [_pController printBitmapWithImage:[UIImage imageNamed:@"12.jpg"] width:BXL_WIDTH_FULL level:1070];
            _pController.alignment = BXL_ALIGNMENT_LEFT;
            [_pController printText: [NSString stringWithFormat:@"%@ \n",[self convertTimeZone:activity[@"time_stamp"]]]];
            [_pController printText:@"방명록 작성\n"];
//            [_pController printText:[NSString stringWithFormat:@"%@ %@\n",activity[@"name_ko"],activity[@"name_en"]]];
            [_pController lineFeed:2];
            
        }
    }
    _pController.attribute = BXL_FT_BOLD;
    _pController.alignment = BXL_ALIGNMENT_LEFT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_4HEIGHT;
    [_pController printText:@"--------------\n"];
    
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:playerName];
    _pController.attribute = BXL_FT_DEFAULT;
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@" 님의 현재점수\n"];
    [_pController lineFeed:1];
    
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@"다름카드 전체 "];
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:@"70"];
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@" 개 중\n "];
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText: [NSString stringWithFormat:@"%lu",(unsigned long)count-(unsigned long)directorCount]];
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@" 개 획득!"];
    [_pController lineFeed:1];

    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@"감독카드 전체 "];
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:@"30"];
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@" 개 중\n "];
    _pController.textSize = BXL_TS_2WIDTH | BXL_TS_2HEIGHT;
    _pController.attribute = BXL_FT_BOLD;
    [_pController printText:[NSString stringWithFormat:@"%lu",(unsigned long)directorCount]];
    _pController.textSize = BXL_TS_0WIDTH | BXL_TS_0HEIGHT;
    [_pController printText:@" 개 획득!"];
    [_pController lineFeed:2];
    
    [_pController printBitmapWithImage:[UIImage imageNamed:@"division_bottom.jpg"] width:BXL_WIDTH_FULL level:50];
    [_pController lineFeed:5 ];
    
    [_pController cutPaper];
//    NSArray * data = @[];

}

- (NSDate *) convertTime:(NSString *) time{
    NSString * timeStampString = time;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSLog(@"%@", date);
    return date;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    NSDate *rr = [NSDate time];
//    NSString *dateString = [dateFormatter stringFromDate:rr];
//    NSLog(@"%@", dateString);
}

- (void) printBalloon:(UIImage *)balloon{
    NSLog(@"print??");
    [_pController lineFeed:1];
    [_pController printBitmapWithImage:balloon width:BXL_WIDTH_FULL level:50];
    [_pController lineFeed:5];
    [_pController cutPaper];
    NSLog(@"end??");
}

@end

//
//  PlayerLogListViewController.h
//  Biky
//
//  Created by CS6 on 7/13/15.
//  Copyright (c) 2015 Nolgong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerLogListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSDictionary * playerActivities;
@property (copy, nonatomic) NSArray *playerCards;
@property (copy, nonatomic) NSArray *playerCardsPrintStats;
@property (copy, nonatomic) NSArray *playerMovies;
@end

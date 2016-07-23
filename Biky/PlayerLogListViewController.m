//
//  PlayerLogListViewController.m
//  Biky
//
//  Created by CS6 on 7/13/15.
//  Copyright (c) 2015 Nolgong. All rights reserved.
//

#import "PlayerLogListViewController.h"
#import "PlayerLogIntroViewController.h"
#import "HTTPClient.h"
#import "HomeViewController.h"

@interface PlayerLogListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cardTableView;
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;


@property (strong, atomic) NSArray *dateArray;
@property (weak, nonatomic) IBOutlet UILabel *cardKeywordLabel;
@property (weak, nonatomic) IBOutlet UILabel *seenMovieListLabel;
@end

@implementation PlayerLogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTableView.dataSource = self;
    self.movieTableView.delegate = self;
    self.cardTableView.dataSource = self;
    self.cardTableView.delegate = self;
    self.cardKeywordLabel.text = [NSString stringWithFormat:@"%@ 님이 획득한 카드의 키워드", self.playerActivities[@"player"][@"name"]];
    self.seenMovieListLabel.text = [NSString stringWithFormat:@"%@ 님이 본 영화", self.playerActivities[@"player"][@"name"]];
    self.playerCards = self.playerActivities[@"cards_keywords"];
    self.playerCardsPrintStats = self.playerActivities[@"print_stat"];
    self.playerMovies = self.playerActivities[@"session"];
    NSLog(@"serial %@", self.playerActivities[@"player"][@"serial"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView==self.cardTableView){
        return [self.playerCards count];
    }
    return [self.playerMovies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    if(tableView==self.cardTableView){
        cell.textLabel.text = [[self.playerCards objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        cell.detailTextLabel.text = [[self.playerCardsPrintStats objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    }else{
        NSLog(@"Movie Table View %@ : ", [self.playerMovies objectAtIndex:indexPath.row]);
        if([self.playerMovies count] != 0){
            cell.textLabel.text=[self.playerMovies objectAtIndex:indexPath.row][@"time"];
            cell.detailTextLabel.text = [self.playerMovies objectAtIndex:indexPath.row][@"session_ko"];
        }
    }
    return cell;
}


- (IBAction)goToHome:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    self.view.window.rootViewController = initViewController;
    
}

- (IBAction)restorePrintStatus:(id)sender {
    HTTPClient *client = [HTTPClient httpClient];
    [client barcode:self.playerActivities[@"player"][@"serial"] updatePlayerPrintStateWithCallback: ^(id response){
        NSLog(@"response-::: %@",response);
        NSLog(@"name : %@", response[@"name"]);
        if([response isEqual:@"full"]){
            NSLog(@"%@",@"good");
        }
        else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:[NSString stringWithFormat:@"%@ 님의 출력 상태를 이전으로 변경했습니다.", response[@"name"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            [alertView show];
            

        }

    
    }];
    
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

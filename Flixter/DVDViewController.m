//
//  DVDViewController.m
//  Flixter
//
//  Created by Bishwajit Aich. on 1/25/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "DVDViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieViewCell.h"
#import "SVProgressHUD.h"
#import "MovieDetailViewController.h"

@interface DVDViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* movies;
@property (strong, nonatomic) NSArray* searchResults;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *errorViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *alertImage;


@end

@implementation DVDViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"DVDs";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self onRefresh];
    
    // setup for connection error
    self.errorViewCell.hidden = YES;
    [self.alertImage setImage:[UIImage imageNamed:@"makefg"]];
    
    // setup for table view
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 128;
    self.tableView.delegate = self;
    
    // set view's background color as black
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
    // customize navigation bar's theme
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    // customize navigation bar link colors?
    self.navigationController.navigationBar.tintColor = [UIColor yellowColor];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor yellowColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieViewCell" bundle:nil] forCellReuseIdentifier:@"MovieViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewController methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieViewCell"];
    
    NSDictionary *imageDict = [NSDictionary dictionaryWithObjectsAndKeys:@"certified_fresh", @"Certified Fresh",
                               @"tomato", @"Fresh",
                               @"splat", @"Rotten",
                               @"baduserscore", @"Spilled",
                               @"popcorn_full", @"Upright", nil];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.movieTitle.text = movie[@"title"];
    cell.mpaa_ratings.text = movie[@"mpaa_rating"];
    cell.movieSynopsys.text = movie[@"synopsis"];
    [cell.movieThumbnailView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]];
    [cell.mpaa_rating_image setImage:[UIImage imageNamed:imageDict[[movie valueForKeyPath:@"ratings.critics_rating"]]]];
    [cell.user_rating_image setImage:[UIImage imageNamed:imageDict[[movie valueForKeyPath:@"ratings.audience_rating"]]]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MovieViewCell *movieCell = (MovieViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    MovieDetailViewController *mdc = [[MovieDetailViewController alloc] init];
    mdc.movie = self.movies[indexPath.row];
    mdc.smallImage = [movieCell.movieThumbnailView image];
    
    [self.navigationController pushViewController:mdc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Custom code
- (void)onRefresh {
    NSLog(@"onRefresh called");
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            self.errorViewCell.hidden = NO;
            NSLog(@"ERROR CONNECTING DATA FROM SERVER: %@", connectionError.localizedDescription);
        } else {
            self.errorViewCell.hidden = YES;
            NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDictionary[@"movies"];
            
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        
    }];
}

@end

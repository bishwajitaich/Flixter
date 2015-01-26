//
//  MovieViewController.m
//  Flixter
//
//  Created by Bishwajit Aich. on 1/23/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "MovieViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieViewCell.h"
#import "SVProgressHUD.h"
#import "MovieDetailViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* movies;
@property (strong, nonatomic) NSArray* searchResults;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *errorViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *alertImage;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property BOOL isSearch;

@end

@implementation MovieViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
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
    
    // setup for search bar
    self.searchBar.delegate = self;
    
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
    NSDictionary *movie = nil;
    
    if (self.isSearch) {
        movie = self.searchResults[indexPath.row];
    } else {
        movie = self.movies[indexPath.row];
    }
    cell.movieTitle.text = movie[@"title"];
    cell.mpaa_ratings.text = movie[@"mpaa_rating"];
    cell.movieSynopsys.text = movie[@"synopsis"];
    [cell.movieThumbnailView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]];
    [cell.mpaa_rating_image setImage:[UIImage imageNamed:imageDict[[movie valueForKeyPath:@"ratings.critics_rating"]]]];
    [cell.user_rating_image setImage:[UIImage imageNamed:imageDict[[movie valueForKeyPath:@"ratings.audience_rating"]]]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        return self.searchResults.count;
    } else {
        return self.movies.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MovieViewCell *movieCell = (MovieViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    MovieDetailViewController *mdc = [[MovieDetailViewController alloc] init];
    if (self.isSearch) {
        mdc.movie = self.searchResults[indexPath.row];
    } else {
        mdc.movie = self.movies[indexPath.row];
    }
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

#pragma mark - UISearchBar methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    self.isSearch = NO;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isSearch = NO;
        [self.tableView reloadData];
    } else {
        self.isSearch = YES;
        [self debounce:@selector(onRefresh) delay:0.25]; //debounce the request for 250ms
    }
}

#pragma mark - Custom code
- (void)onRefresh {
    NSLog(@"onRefresh called");
    
    NSURL * url = nil;
    if (self.isSearch) {
        NSString * searchText = self.searchBar.text;
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&q=%@&page_limit=1", [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [SVProgressHUD show];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            self.errorViewCell.hidden = NO;
            NSLog(@"ERROR CONNECTING DATA FROM SERVER: %@", connectionError.localizedDescription);
        } else {
            self.errorViewCell.hidden = YES;
            NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (self.isSearch) {
                self.searchResults = responseDictionary[@"movies"];
            } else {
                self.movies = responseDictionary[@"movies"];
            }
            
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        
    }];
}

- (void)debounce:(SEL)action delay:(NSTimeInterval)delay
{
    __weak typeof(self) weakSelf = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:action object:nil];
    [weakSelf performSelector:action withObject:nil afterDelay:delay];
}
@end

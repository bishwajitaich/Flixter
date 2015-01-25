//
//  MovieDetailViewController.m
//  Flixter
//
//  Created by Bishwajit Aich. on 1/24/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsis;

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIImageView *audienceRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *criticsRatingImage;
@property (weak, nonatomic) IBOutlet UILabel *casting;
@property (weak, nonatomic) IBOutlet UILabel *mpaaRating;
@property (weak, nonatomic) IBOutlet UILabel *runLength;


@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *imageDict = [NSDictionary dictionaryWithObjectsAndKeys:@"certified_fresh", @"Certified Fresh",
                               @"tomato", @"Fresh",
                               @"splat", @"Rotten",
                               @"baduserscore", @"Spilled",
                               @"popcorn_full", @"Upright", nil];
    
    
    [self.scrollView setScrollEnabled:YES];
    
    self.title = self.movie[@"title"];
    self.movieTitle.text = self.movie[@"title"];
    self.movieSynopsis.text = self.movie[@"synopsis"];
    self.mpaaRating.text = self.movie[@"mpaa_rating"];
    self.runLength.text = [self.movie[@"runtime"] stringValue];
    
    NSMutableArray *casts = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.movie[@"abridged_cast"]) {
        [casts addObject:dict[@"name"]];
    }
    self.casting.text = [casts componentsJoinedByString:@", "];
    
    [self.criticsRatingImage setImage:[UIImage imageNamed:imageDict[[self.movie valueForKeyPath:@"ratings.critics_rating"]]]];
    [self.audienceRatingImage setImage:[UIImage imageNamed:imageDict[[self.movie valueForKeyPath:@"ratings.audience_rating"]]]];
    
    [self.posterView setImage:self.smallImage];
    [self.posterView setImageWithURL:[NSURL URLWithString:[[self.movie valueForKeyPath:@"posters.detailed"] stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"]]];
    
    self.movieSynopsis.numberOfLines = 0;
    [self.movieSynopsis sizeToFit];
    [self.casting sizeToFit];
    
    float scrollHeight = 359 + self.detailsView.bounds.size.height;
    [self.scrollView setContentSize:CGSizeMake(320, scrollHeight)];
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

//
//  MovieViewCell.h
//  Flixter
//
//  Created by Bishwajit Aich. on 1/24/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieThumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsys;
@property (weak, nonatomic) IBOutlet UILabel *mpaa_ratings;
@property (weak, nonatomic) IBOutlet UIImageView *mpaa_rating_image;
@property (weak, nonatomic) IBOutlet UIImageView *user_rating_image;

@end

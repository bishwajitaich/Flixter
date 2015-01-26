//
//  MovieViewCell.m
//  Flixter
//
//  Created by Bishwajit Aich. on 1/24/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "MovieViewCell.h"

@implementation MovieViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [UIColor yellowColor];
        self.movieTitle.textColor = [UIColor blackColor];
        self.movieSynopsys.textColor = [UIColor blackColor];
        self.mpaa_ratings.textColor = [UIColor blackColor];
    } else {
        self.backgroundColor = [UIColor blackColor];
        self.movieTitle.textColor = [UIColor whiteColor];
        self.movieSynopsys.textColor = [UIColor whiteColor];
        self.mpaa_ratings.textColor = [UIColor whiteColor];
    }
}

@end

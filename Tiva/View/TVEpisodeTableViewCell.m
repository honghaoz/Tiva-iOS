//
//  TVEpisodeTableViewCell.m
//  Tiva
//
//  Created by Zhang Honghao on 6/24/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVEpisodeTableViewCell.h"
#import "TVMainViewController.h"
#import "TVShowStore.h"

#define CELL_INSET_WIDTH

@implementation TVEpisodeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier cellWidth:320 cellHeight:44];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)width cellHeight:(CGFloat)height {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellWidth = width;
        _cellHeight = height;
        [self.contentView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _cellWidth, _cellHeight)];
        // Initialization code
        [self.contentView setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:1]];
//        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
//        
        CGFloat showTitleLabelX = 10;
        CGFloat showTitleLabelY = 10;
        CGFloat showTitleLabelWidth = 150;
        CGFloat showTitleLabelHeight = 34;
        CGRect showTitleLabelFrame = CGRectMake(showTitleLabelX, showTitleLabelY, showTitleLabelWidth, showTitleLabelHeight);
        _showTitleLabel = [[UILabel alloc] initWithFrame:showTitleLabelFrame];
        [_showTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [_showTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        [_showTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_showTitleLabel setTextColor:[UIColor blackColor]];
        
        
        CGFloat showAiredTimeLabelX = showTitleLabelX + showTitleLabelWidth + 10;
        CGFloat showAiredTimeLabelY = showTitleLabelY;
        CGFloat showAiredTimeLabelWidth = 150;
        CGFloat showAiredTimeLabelHeight = 34;
        CGRect showAiredTimeLabelFrame = CGRectMake(showAiredTimeLabelX, showAiredTimeLabelY, showAiredTimeLabelWidth, showAiredTimeLabelHeight);
        _showAiredTimeLabel = [[UILabel alloc] initWithFrame:showAiredTimeLabelFrame];
        [_showAiredTimeLabel setTextAlignment:NSTextAlignmentLeft];
        [_showAiredTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
        [_showAiredTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_showAiredTimeLabel setTextColor:[UIColor darkGrayColor]];
        
        [self.contentView addSubview:_showTitleLabel];
        [self.contentView addSubview:_showAiredTimeLabel];
        self.backgroundView = [UIView new];
        self.selectedBackgroundView = [UIView new];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowTitle:(NSString *)showTitle airedTime:(NSDate *)airedTime {
    [_showTitleLabel setText:showTitle];
    NSDateFormatter *formater = [TVShowStore localDateFormatter];
    [formater setDateFormat:@"hh:mm aa"];
    
    [_showAiredTimeLabel setText:[formater stringFromDate:airedTime]];
}

@end

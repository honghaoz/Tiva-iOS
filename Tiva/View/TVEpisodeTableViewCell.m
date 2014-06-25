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
#import "TVHelperMethods.h"

#define CELL_GAP_WIDTH 5.0

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
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(CELL_GAP_WIDTH, CELL_GAP_WIDTH / 2, _cellWidth - 2 * CELL_GAP_WIDTH, _cellHeight - CELL_GAP_WIDTH)];
        [containerView setBackgroundColor:[UIColor whiteColor]];
        [TVHelperMethods setMaskTo:containerView byRoundingCorners:UIRectCornerAllCorners withRadius:2.0];
        
        [self.contentView addSubview:containerView];

        CGFloat showTitleLabelWidth = containerView.bounds.size.width - 20;
        CGFloat showTitleLabelHeight = containerView.bounds.size.height - 20;
        CGFloat showTitleLabelX = 10;
        CGFloat showTitleLabelY = 2.5;
        CGRect showTitleLabelFrame = CGRectMake(showTitleLabelX, showTitleLabelY, showTitleLabelWidth, showTitleLabelHeight);
        _showTitleLabel = [[UILabel alloc] initWithFrame:showTitleLabelFrame];
        [_showTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [_showTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        [_showTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_showTitleLabel setTextColor:LABEL_COLOR];
        
        CGFloat showAiredTimeLabelX = showTitleLabelX;
        CGFloat showAiredTimeLabelY = showTitleLabelY + showTitleLabelHeight - 2;
        CGFloat showAiredTimeLabelWidth = containerView.bounds.size.width - 20;
        CGFloat showAiredTimeLabelHeight = 20;//containerView.bounds.size.height - showTitleLabelHeight - 2.5 * 3;
        NSLog(@"%f",containerView.bounds.size.height - showTitleLabelHeight - 2.5 * 3);
        CGRect showAiredTimeLabelFrame = CGRectMake(showAiredTimeLabelX, showAiredTimeLabelY, showAiredTimeLabelWidth, showAiredTimeLabelHeight);
        _showAiredTimeLabel = [[UILabel alloc] initWithFrame:showAiredTimeLabelFrame];
        [_showAiredTimeLabel setTextAlignment:NSTextAlignmentLeft];
        [_showAiredTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [_showAiredTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_showAiredTimeLabel setTextColor:[UIColor lightGrayColor]];
        
        [containerView addSubview:_showTitleLabel];
        [containerView addSubview:_showAiredTimeLabel];
//        self.backgroundView = [UIView new];
        NSLog(@"content: %@", NSStringFromCGRect(self.contentView.bounds));
        NSLog(@"contaioner: %@", NSStringFromCGRect(containerView.bounds));
        
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
//        [self.selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    [formater setDateFormat:@"cccc hh:mm aa"];
    
    [_showAiredTimeLabel setText:[formater stringFromDate:airedTime]];
}

@end

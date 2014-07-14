//
//  TVEpisodeTableViewCell.h
//  Tiva
//
//  Created by Zhang Honghao on 6/24/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVEpisodeTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) UILabel *showTitleLabel;
@property (nonatomic, strong) UILabel *showAiredTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)width cellHeight:(CGFloat)height;

- (void)setShowTitle:(NSString *)showTitle
           airedTime:(NSDate *)airedTime;

- (void)setShowTitle:(NSString *)showTitle detailText:(NSString *)detail;


@end

//
//  TVEpisode.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TVShow;
@class PFObject;

@interface TVEpisode : NSObject

@property (nonatomic, assign) NSInteger season;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *overview;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, strong) NSDate *airedDateUTC;
@property (nonatomic, strong) NSDate *airedDateLocal;
@property (nonatomic, copy) NSURL *screenImageURL;
@property (nonatomic, strong) UIImage *screenImage;
@property (nonatomic, weak) TVShow *show;
//@property (nonatomic, strong)

- (instancetype)initWithParseEpisodeObject:(id)object parentShow:(TVShow *)show;

@end

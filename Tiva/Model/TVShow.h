//
//  TVShow.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVEpisode.h"

@class PFObject;

@interface TVShow : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, strong) NSDate *firstAiredDateUTC;
//@property (nonatomic, strong) NSDate *firstAiredDateLocal;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *overview;
@property (nonatomic, assign) double runtime;
@property (nonatomic, copy) NSString *network;
@property (nonatomic, copy) NSString *certification;
@property (nonatomic, copy) NSString *imdb_id;
@property (nonatomic, copy) NSString *tvdb_id;
@property (nonatomic, copy) NSString *tvrage_id;

@property (nonatomic, copy) NSURL *bannerURL;
@property (nonatomic, strong) UIImage *bannerImage;
@property (nonatomic, copy) NSURL *posterURL;
@property (nonatomic, strong) UIImage *posterImage;
@property (nonatomic, copy) NSURL *fanartURL;
@property (nonatomic, strong) UIImage *fanartImage;

@property (nonatomic, strong) NSArray *genres;

@property (nonatomic, strong) NSArray *episodes;

- (instancetype)initWithParseShowObject:(PFObject *)object;

- (void)loadImage:(UIImage *)image withURL:(NSURL *)url;

@end

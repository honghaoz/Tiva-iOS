//
//  TVShow.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVShow : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, assign) double runtime;
@property (nonatomic, strong) NSString *network;
@property (nonatomic, strong) NSString *certification;
@property (nonatomic, strong) NSString *imdb_id;
@property (nonatomic, strong) NSString *tvdb_id;
@property (nonatomic, strong) NSString *tvrage_id;

@property (nonatomic, strong) NSURL *bannerURL;
@property (nonatomic, strong) UIImage *bannerImage;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) UIImage *posterImage;
@property (nonatomic, strong) NSURL *fanartURL;
@property (nonatomic, strong) UIImage *fanartImage;

@property (nonatomic, strong) NSArray *genres;

@end

//
//  TVShow.m
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVShow.h"
#import <AFHTTPRequestOperation.h>

@implementation TVShow

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                         year:(NSNumber *)year
                    URLString:(NSString *)url
            firstAiredDateUTC:(NSDate *)firstAiredDateUTC
                      country:(NSString *)country
                     overview:(NSString *)overview
                      runtime:(NSNumber *)runtime
                      network:(NSString *)network
                certification:(NSString *)certification
                      imdb_id:(NSString *)imdb_id
                      tvdb_id:(NSString *)tvdb_id
                    tvrage_id:(NSString *)tvrage_id
                    bannerURL:(NSString *)bannerURL
                    posterURL:(NSString *)posterURL
                    fanartURL:(NSString *)fanartURL
                       genres:(NSArray *)genres
                     episodes:(NSArray *)episodes {
    self = [super init];
    if (self) {
        self.title = title;
        self.year = [year integerValue];
        self.URL = [NSURL URLWithString:url];
        self.firstAiredDateUTC = firstAiredDateUTC;
        self.country = country;
        self.overview = overview;
        self.runtime = [runtime doubleValue];
        self.network = network;
        self.certification = certification;
        self.imdb_id = imdb_id;
        self.tvdb_id = tvdb_id;
        self.tvrage_id = tvrage_id;
        self.bannerURL = [NSURL URLWithString:bannerURL];
        self.posterURL = [NSURL URLWithString:posterURL];
        self.fanartURL = [NSURL URLWithString:fanartURL];
        self.genres = genres;
        self.episodes = episodes;
    }
    return self;
}

#pragma mark - Helper methods

- (void)loadImage:(UIImage *)image withURL:(NSURL *)url {
    if (url == nil || image == nil) {
        return;
    }
    __block UIImage *theImage = image;
    NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:imageRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        theImage = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}
@end

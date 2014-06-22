//
//  TVEpisode.m
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVEpisode.h"
#import "TVShow.h"
#import "TVShowStore.h"

@implementation TVEpisode

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithParseEpisodeObject:(id)object parentShow:(TVShow *)show {
    return [self initWithSeason:object[@"Season"]
                         number:object[@"Mumber"]
                          title:object[@"Title"]
                       overview:object[@"Overview"]
                            URL:object[@"URL"]
                   airedDateUTC:object[@"Air_Date_UTC"]
                 screenImageURL:object[@"Screen"]
                           show:show];
}

- (instancetype)initWithSeason:(NSNumber *)season
                        number:(NSNumber *)number
                         title:(NSString *)title
                      overview:(NSString *)overview
                           URL:(NSString *)url
                  airedDateUTC:(NSDate *)airedDateUTC
                screenImageURL:(NSString *)screenImageURL
                          show:(TVShow *)show{
    self = [super init];
    if (self) {
        self.season = [season integerValue];
        self.number = [number integerValue];
        self.title = title;
        self.overview = overview;
        self.URL = [NSURL URLWithString:url];
        self.airedDateUTC = airedDateUTC;
        self.screenImageURL = [NSURL URLWithString:screenImageURL];
        self.show = show;
    }
    return self;
}

@end

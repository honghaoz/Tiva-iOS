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
#import <Parse/Parse.h>

static NSComparator episodeUniqueComparator = ^(id e1, id e2) {
    TVEpisode *ep1 = (TVEpisode *)e1;
    TVEpisode *ep2 = (TVEpisode *)e2;
    // Compare show.tvdb_id, airedDateUTC
    if ([ep1.show.tvdb_id isEqualToString:ep2.show.tvdb_id]) {
        return [ep1.airedDateUTC compare:ep2.airedDateUTC];
    } else {
        return NSOrderedAscending;
    }
};

static NSComparator episodeOrderComparator = ^(id e1, id e2) {
    TVEpisode *ep1 = (TVEpisode *)e1;
    TVEpisode *ep2 = (TVEpisode *)e2;
    return [ep1.airedDateUTC compare:ep2.airedDateUTC];
};

@implementation TVEpisode

+ (NSComparator)episodeUniqueComparator {
    return episodeUniqueComparator;
}

+ (NSComparator)episodeOrderComparator {
    return episodeOrderComparator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithParseEpisodeObject:(PFObject *)object parentShow:(TVShow *)show {
    return [self initWithSeason:object[@"Season"]
                         number:object[@"Mumber"]
                          title:object[@"Title"]
                       overview:object[@"Overview"]
                            URL:object[@"URL"]
                   airedDateUTC:object[@"Air_Date_UTC"]
                 screenImageURL:object[@"Screen"]
                           show:show
                       objectID:object.objectId];
}

- (instancetype)initWithSeason:(NSNumber *)season
                        number:(NSNumber *)number
                         title:(NSString *)title
                      overview:(NSString *)overview
                           URL:(NSString *)url
                  airedDateUTC:(NSDate *)airedDateUTC
                screenImageURL:(NSString *)screenImageURL
                          show:(TVShow *)show
                      objectID:(NSString *)objectID{
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
        self.objectID = objectID;
    }
    return self;
}

@end

//
//  TVShow.m
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <AFHTTPRequestOperation.h>
#import <Parse/Parse.h>

#import "TVShow.h"
#import "TVEpisode.h"
#import "TVShowStore.h"

static NSComparator showUniqueComparator = ^(id s1, id s2) {
    TVShow *show1 = (TVShow *)s1;
    TVShow *show2 = (TVShow *)s2;
    // Compare tvdb_id
    return [show1.tvdb_id compare:show2.tvdb_id];
};

static NSComparator showOrderComparator = ^(id s1, id s2) {
    TVShow *show1 = (TVShow *)s1;
    TVShow *show2 = (TVShow *)s2;
    // Compare tvdb_id
    return [show1.title compare:show2.title];
};

@implementation TVShow

+ (NSComparator)showUniqueComparator {
    return showUniqueComparator;
}

+ (NSComparator)showOrderComparator {
    return showOrderComparator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)episodes {
    if (_episodes == nil) {
        _episodes = [NSMutableArray new];
    }
    return _episodes;
}

- (instancetype)initWithParseShowObject:(PFObject *)object {
    // First get the episodes for this show
    __block NSMutableArray *episodes = [[NSMutableArray alloc] init];
    PFRelation *childrenRelation = object[@"Children"];
    PFQuery *queryForEpisodes = [childrenRelation query];
    [queryForEpisodes setCachePolicy:kPFCachePolicyNetworkElseCache];
    [queryForEpisodes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // objects are episodes
            for (PFObject *eachEpisode in objects) {
                TVEpisode *newEpisode = [[TVEpisode alloc] initWithParseEpisodeObject:eachEpisode parentShow:self];
                [episodes addObject:newEpisode];
                [[TVShowStore sharedStore].episodes addObject:newEpisode];
            }
//            NSLog(@"Query Episodes Succeed: %d", [objects count]);
        } else {
//            NSLog(@"Query Episodes Error: %@ %@", error, [error localizedDescription]);
        }
    }];
    
    // Initiate
    return [self initWithTitle:object[@"Title"]
                          year:object[@"Year"]
                     URLString:object[@"URL"]
             firstAiredDateUTC:object[@"First_Aired_UTC"]
                       country:object[@"Country"]
                      overview:object[@"Overview"]
                       runtime:object[@"Runtime"]
                       network:object[@"Network"]
                 certification:object[@"Certification"]
                       imdb_id:object[@"imdb_id"]
                       tvdb_id:object[@"tvdb_id"]
                     tvrage_id:object[@"tvrage_id"]
                     bannerURL:object[@"Banner"]
                     posterURL:object[@"Poster"]
                     fanartURL:object[@"Fanart"]
                        genres:object[@"Genres"]
                      episodes:episodes
                      objectID:object.objectId];
}

- (instancetype)initWithParseShowObjectNoEpisodes:(PFObject *)object {
    return [self initWithTitle:object[@"Title"]
                          year:object[@"Year"]
                     URLString:object[@"URL"]
             firstAiredDateUTC:object[@"First_Aired_UTC"]
                       country:object[@"Country"]
                      overview:object[@"Overview"]
                       runtime:object[@"Runtime"]
                       network:object[@"Network"]
                 certification:object[@"Certification"]
                       imdb_id:object[@"imdb_id"]
                       tvdb_id:object[@"tvdb_id"]
                     tvrage_id:object[@"tvrage_id"]
                     bannerURL:object[@"Banner"]
                     posterURL:object[@"Poster"]
                     fanartURL:object[@"Fanart"]
                        genres:object[@"Genres"]
                      episodes:nil
                      objectID:object.objectId];
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
                     episodes:(NSMutableArray *)episodes
                     objectID:(NSString *)objectID{
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
        self.objectID = objectID;
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

//
//  TVShowStore.m
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVShowStore.h"
#import "TVShow.h"
#import <Parse/Parse.h>

@implementation TVShowStore

+ (TVShowStore *)sharedStore {
    LogMethod;
    static TVShowStore *_sharedStore = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedStore = [[self alloc] init];
    });
    return _sharedStore;
}

- (instancetype)init {
    LogMethod;
    self = [super init];
    if (self) {
        _shows = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)retrieveShows {
    LogMethod;
    PFQuery *query = [PFQuery queryWithClassName:@"Show"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d shows.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                TVShow *newShow = [[TVShow alloc] initWithTitle:object[@"Title"]
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
                                                        episodes:nil];//object[@"Episodes"]];
                [self.shows addObject:newShow];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
        }
    }];
}

@end

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
#import "NSMutableArray+InsertInOrder.h"
#import "TVHelperMethods.h"

@implementation TVShowStore

+ (TVShowStore *)sharedStore {
    static TVShowStore *_sharedStore = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedStore = [[self alloc] init];
    });
    return _sharedStore;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shows = [[NSMutableArray alloc] init];
        _episodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *)episodesDictionaryKeys {
    if (_episodesDictionaryKeys == nil) {
        _episodesDictionaryKeys = [[NSMutableArray alloc] init];
        LogMethod;
    }
    return _episodesDictionaryKeys;
}

- (NSMutableDictionary *)episodesDictionary {
    if (_episodesDictionary == nil) {
        _episodesDictionary = [[NSMutableDictionary alloc] init];
        LogMethod;
    }
    return _episodesDictionary;
}

- (void)retrieveShows {
    PFQuery *query = [PFQuery queryWithClassName:@"Show"];
    query.limit = 1000;
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Query Shows Succeed: %d", [objects count]);
            // Do something with the found objects
            for (PFObject *object in objects) {
                TVShow *newShow = [[TVShow alloc] initWithParseShowObject:object];
                [self.shows addObject:newShow];
//                NSLog(@"Post ShowStoreUpdated");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStoreUpdated" object:self userInfo:@{@"ShowIndex": [NSNumber numberWithInteger:[self.shows indexOfObject:newShow]]}];
            }
        } else {
            // Log details of the failure
            NSLog(@"Query Shows Error: %@ %@", error, [error localizedDescription]);
        }
    }];
}

- (void)processEpisodesDictionary {
    if (_episodes) {
        [_episodesDictionary removeAllObjects];
        [_episodesDictionaryKeys removeAllObjects];
        NSMutableSet *keySet = [[NSMutableSet alloc] init];
        NSComparator dateComparator = ^(NSDate *d1, NSDate *d2) {
            return [d1 compare:d2];
        };
        NSComparator epComparator = ^(TVEpisode *ep1, TVEpisode *ep2) {
            return [ep1.airedDateUTC compare:ep2.airedDateUTC];
        };
        for (TVEpisode *eachEpisode in _episodes) {
            // Add keys
            NSDate *onlyDay = [TVHelperMethods dateWithOutTime:eachEpisode.airedDateUTC];
            [keySet addObject:onlyDay];
            NSMutableArray *episodesOfOneDay = [self.episodesDictionary objectForKey:onlyDay];
            // First entry
            if (!episodesOfOneDay) {
                episodesOfOneDay = [[NSMutableArray alloc] init];
                [episodesOfOneDay addObject:eachEpisode];
                [self.episodesDictionary setObject:episodesOfOneDay forKey:onlyDay];
            }
            // Add to old array
            else {
                [episodesOfOneDay insertObject:eachEpisode usingComparator:epComparator];
            }
        }
        _episodesDictionaryKeys = [[NSMutableArray alloc] initWithArray:[[keySet allObjects] sortedArrayUsingComparator:dateComparator]];
    }
//    // Output dictionary
//    NSDateFormatter *formater = [TVShowStore localDateFormatter];
//    [formater setDateFormat:@"MMM d, HH:ss"];
//    
//    for (NSDate *eachKey in self.episodesDictionaryKeys) {
//        NSMutableArray *showsOfAday = self.episodesDictionary[eachKey];
//        NSLog(@"%@:", [formater stringFromDate:eachKey]);
//        for (TVEpisode *eachEP in showsOfAday) {
//            NSLog(@"  %@ %@", [formater stringFromDate:eachEP.airedDateUTC], eachEP.title);
//        }
//    }
//    if ([_episodesDictionary count] == 0) {
//        NSLog(@"works");
////        [_episodesDictionary removeAllObjects];
////        [_episodesDictionaryKeys removeAllObjects];
//        NSMutableSet *keySet = [[NSMutableSet alloc] init];
//        NSComparator dateComparator = ^(NSDate *d1, NSDate *d2) {
//            return [d1 compare:d2];
//        };
//        NSComparator epComparator = ^(TVEpisode *ep1, TVEpisode *ep2) {
//            return [ep1.airedDateUTC compare:ep2.airedDateUTC];
//        };
//        for (TVEpisode *eachEpisode in _episodes) {
//            // Add keys
//            NSDate *onlyDay = [self dateWithOutTime:eachEpisode.airedDateUTC];
//            [keySet addObject:onlyDay];
//            NSMutableArray *episodesOfOneDay = [self.episodesDictionary objectForKey:onlyDay];
//            // First entry
//            if (!episodesOfOneDay) {
//                episodesOfOneDay = [[NSMutableArray alloc] init];
//                [episodesOfOneDay addObject:eachEpisode];
//                [self.episodesDictionary setObject:episodesOfOneDay forKey:onlyDay];
//            }
//            // Add to old array
//            else {
//                [episodesOfOneDay insertObject:eachEpisode usingComparator:epComparator];
//            }
//        }
//        _episodesDictionaryKeys = [[NSMutableArray alloc] initWithArray:[[keySet allObjects] sortedArrayUsingComparator:dateComparator]];
//    }
//    //    // Output dictionary
//    //    NSDateFormatter *formater = [TVShowStore localDateFormatter];
//    //    [formater setDateFormat:@"MMM d, HH:ss"];
//    //
//    //    for (NSDate *eachKey in self.episodesDictionaryKeys) {
//    //        NSMutableArray *showsOfAday = self.episodesDictionary[eachKey];
//    //        NSLog(@"%@:", [formater stringFromDate:eachKey]);
//    //        for (TVEpisode *eachEP in showsOfAday) {
//    //            NSLog(@"  %@ %@", [formater stringFromDate:eachEP.airedDateUTC], eachEP.title);
//    //        }
//    //    }
}

#pragma mark - Helper methods

@end

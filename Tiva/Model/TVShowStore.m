//
//  TVShowStore.m
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVShowStore.h"
#import "TVShow.h"
#import "TVEpisode.h"
#import <Parse/Parse.h>
#import "NSMutableArray+InsertInOrder.h"
#import "TVHelperMethods.h"
#import "NSMutableArray+AddUnique.h"

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
        
    }
    return self;
}

- (NSMutableArray *)shows {
    if (_shows == nil) {
        _shows = [[NSMutableArray alloc] init];
    }
    return _shows;
}

- (NSMutableArray *)episodes {
    if (_episodes == nil) {
        _episodes = [[NSMutableArray alloc] init];
    }
    return _episodes;
}

- (NSMutableArray *)todayEpisodes {
    if (_todayEpisodes == nil) {
        _todayEpisodes = [[NSMutableArray alloc] init];
    }
    return _todayEpisodes;
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

//- (void)retrieveShows {
//    PFQuery *query = [PFQuery queryWithClassName:@"Show"];
//    query.limit = 1000;
//    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Query Shows Succeed: %d", [objects count]);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                TVShow *newShow = [[TVShow alloc] initWithParseShowObject:object];
//                [self.shows addObject:newShow];
////                NSLog(@"Post ShowStoreUpdated");
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStoreUpdated" object:self userInfo:@{@"ShowIndex": [NSNumber numberWithInteger:[self.shows indexOfObject:newShow]]}];
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Query Shows Error: %@ %@", error, [error localizedDescription]);
//        }
//    }];
//}

- (void)retrieveEpisodesFromDay:(NSDate *)day1 toDay:(NSDate *)day2 {
//    LogMethod;
    PFQuery *queryForEpisode = [PFQuery queryWithClassName:@"Episode"];
    queryForEpisode.limit = 1000;
    [queryForEpisode setCachePolicy:kPFCachePolicyNetworkElseCache];
    NSDate *beginDate = [TVHelperMethods dateWithOutTime:day1];
    NSDate *endDate = [TVHelperMethods dateWithOutTime:[day2 dateByAddingTimeInterval:60 * 60 * 24]];
    
    BOOL isToday = NO;
    // If day is today, change episode array to be added to self.todayEpisodes
    if ([[TVHelperMethods dateWithOutTime:[NSDate date]] isEqualToDate:[TVHelperMethods dateWithOutTime:day1]] && [[TVHelperMethods dateWithOutTime:[NSDate date]] isEqualToDate:[TVHelperMethods dateWithOutTime:day2]]) {
        isToday = YES;
    }
    
    [queryForEpisode whereKey:@"Air_Date_UTC" greaterThanOrEqualTo:beginDate];
    [queryForEpisode whereKey:@"Air_Date_UTC" lessThan:endDate];
    [queryForEpisode includeKey:@"Parent"];
    [queryForEpisode orderByAscending:@"Air_Date_UTC"];
    [queryForEpisode findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *episode in objects) {
                // Becarful retain cycle
                // Show has strong pointers to episodes
                // Episode has weak pointer to show
                PFObject *show = episode[@"Parent"];
                TVShow *newShow = [[TVShow alloc] initWithParseShowObjectNoEpisodes:show];
                
                BOOL addResult = [self.shows addUniqueObject:newShow
                                       usingUniqueComparator:[TVShow showUniqueComparator]
                                             orderComparator:[TVShow showOrderComparator]];
                // If the show is existed, link this episode to the existed show;
                if (addResult == NO) {
                    for (TVShow *eachShow in self.shows) {
                        if ([TVShow showUniqueComparator](eachShow, newShow) == NSOrderedSame) {
                            newShow = eachShow;
                            break;
                        }
                    }
                }
                
                TVEpisode *newEp = [[TVEpisode alloc] initWithParseEpisodeObject:episode parentShow:newShow];
                [newShow.episodes addObject:newEp];
                
                // Added to episodes
                [self.episodes addUniqueObject:newEp
                         usingUniqueComparator:[TVEpisode episodeUniqueComparator]
                               orderComparator:[TVEpisode episodeOrderComparator]];
                // Check Whether need to add to todayEpisodes
                if (isToday) {
                    //                    NSLog(@"isToday");
                    [self.todayEpisodes addUniqueObject:newEp
                                  usingUniqueComparator:[TVEpisode episodeUniqueComparator]
                                        orderComparator:[TVEpisode episodeOrderComparator]];
                }
            }
            NSLog(@"shows: %d, epi: %d", [self.shows count], [self.episodes count]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStoreUpdated" object:self userInfo:@{@"DataKind" : @"Episodes", @"BeginDay" : [TVHelperMethods dateWithOutTime:day1], @"EndDay" : [TVHelperMethods dateWithOutTime:day2]}];
        } else {
            NSLog(@"Query episode error");
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

//
//  TVShowStore.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TVShow;
@class TVUser;

@interface TVShowStore : NSObject

@property (nonatomic, strong) NSMutableArray *shows;
@property (nonatomic, strong) NSMutableArray *episodes;
//@property (nonatomic, strong) TVUser *user;
@property (nonatomic, strong) NSMutableArray *comments;

@property (nonatomic, strong) NSMutableArray *episodesDictionaryKeys;
@property (nonatomic, strong) NSMutableDictionary *episodesDictionary;

@property (nonatomic, strong) NSMutableArray *todayEpisodes;

+ (TVShowStore *)sharedStore;

// Retrive episodes from day1 to day2 (inclusive), init episodes and shows
- (void)retrieveEpisodesFromDay:(NSDate *)day1 toDay:(NSDate *)day2;

/**
 *  Seperate episodes into different days (local time zone)
 *  Process episodesDictionaryKeys and episodesDictionary
 *  episodesDictionaryKeys will contains keys for episodesDictionary
 *  episodesDictionary: keys are NSDate objects, values are NSMutableArray of Episodes
 */
- (void)processEpisodesDictionary;

- (void)retrieveComments;
@end

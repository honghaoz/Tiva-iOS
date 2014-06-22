//
//  TVShowStore.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TVShow;
@class TVTraktUser;

@interface TVShowStore : NSObject

@property (nonatomic, strong) NSMutableArray *shows;
@property (nonatomic, strong) NSMutableArray *episodes;
@property (nonatomic, strong) TVTraktUser *traktUser;

@property (nonatomic, strong) NSMutableArray *episodesDictionaryKeys;
@property (nonatomic, strong) NSMutableDictionary *episodesDictionary;

+ (TVShowStore *)sharedStore;


/**
 *  Retrieve data from Parse to initiate shows and episodes
 */
- (void)retrieveShows;

/**
 *  Seperate episodes into different days (local time zone)
 *  Process episodesDictionaryKeys and episodesDictionary
 *  episodesDictionaryKeys will contains keys for episodesDictionary
 *  episodesDictionary: keys are NSDate objects, values are NSMutableArray of Episodes
 */
- (void)processEpisodesDictionary;

/**
 *  Get NSDateFormatter for eastern time zone
 *
 *  @return NSDateFormatter object
 */
+ (NSDateFormatter *)estDateFormatter;

/**
 *  Get NSDateFormatter for local time zone
 *
 *  @return NSDateFormatter object
 */
+ (NSDateFormatter *)localDateFormatter;

@end

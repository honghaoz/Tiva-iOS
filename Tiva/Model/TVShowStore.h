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
@property (nonatomic, strong) TVTraktUser *traktUser;

+ (TVShowStore *)sharedStore;

- (void)retrieveShows;

@end

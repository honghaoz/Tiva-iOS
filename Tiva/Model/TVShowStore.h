//
//  TVShowStore.h
//  Tiva
//
//  Created by Zhang Honghao on 6/20/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TVShow;

@interface TVShowStore : NSObject

@property (nonatomic, strong) NSMutableArray *shows;

+ (TVShowStore *)sharedStore;
- (void)retrieveShows;

@end

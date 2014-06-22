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
    }
    return self;
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

@end

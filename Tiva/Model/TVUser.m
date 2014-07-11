//
//  TVUser.m
//  Tiva
//
//  Created by Zhang Honghao on 6/21/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVUser.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import <Parse/Parse.h>
#import "TVShow.h"

@implementation TVUser

+ (TVUser *)sharedUser {
    static TVUser *sharedUser = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedUser = [[self alloc] init];
    });
    return sharedUser;
}

- (NSMutableArray *)favouriteShows {
    if (_favouriteShows == nil) {
        _favouriteShows = [[NSMutableArray alloc] init];
    }
    return _favouriteShows;
}

//- (id)init {
//    self = [super init];
//    if (self) {
//        _favouriteShows = [[NSMutableArray alloc] init];
//    }
//    return self;
//}

- (void)setUsername:(NSString *)username andPassword:(NSString *)password {
    _username = username;
    _password = password;
    _passwordSha1 = [password sha1];
}

- (void)login {
    [PFUser logInWithUsernameInBackground:_username password:_password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"login succeed");
                                            _currentPFUser = user;
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"login failed");
                                            _currentPFUser = nil;
                                        }
    }];
}

- (void)retrieveUserData {
    LogMethod;
    _currentPFUser = [PFUser currentUser];
    if (!_currentPFUser) {
        [self login];
    } else {
        NSLog(@"user!!!!");
//        _currentUser
//        NSLog(@"111 %@", _currentUser[@"email"]);
        PFRelation *favouriteShows = _currentPFUser[@"FavouriteShows"];
        PFQuery *queryForFavourite = [favouriteShows query];
        [queryForFavourite setCachePolicy:kPFCachePolicyNetworkElseCache];
        [queryForFavourite findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Query Shows Succeed: %d", [objects count]);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    TVShow *newShow = [[TVShow alloc] initWithParseShowObject:object];
                    [self.favouriteShows addObject:newShow];
//                    NSLog(@"%@ %d", newShow.title, [self.favouriteShows count]);
                    //                NSLog(@"Post ShowStoreUpdated");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FavouriteShowUpdated" object:self userInfo:@{@"ShowIndex": [NSNumber numberWithInteger:[self.favouriteShows indexOfObject:newShow]]}];
                }
            } else {
                // Log details of the failure
                NSLog(@"Query Shows Error: %@ %@", error, [error localizedDescription]);
            }
        }];
    }
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
//                //                NSLog(@"Post ShowStoreUpdated");
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStoreUpdated" object:self userInfo:@{@"ShowIndex": [NSNumber numberWithInteger:[self.shows indexOfObject:newShow]]}];
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Query Shows Error: %@ %@", error, [error localizedDescription]);
//        }
//    }];
}

@end

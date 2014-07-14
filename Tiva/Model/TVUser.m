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
#import <objc/runtime.h>

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

- (NSMutableArray *)recommendations {
    if (_recommendations == nil) {
        _recommendations = [[NSMutableArray alloc] init];
    }
    return _recommendations;
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

- (void)signUp {
    LogMethod;
    if (_currentPFUser != nil) {
        return;
    } else if (_username != nil && _password != nil) {
        [self login];
        return;
    }
    if (_fbID == nil) {
        return;
    }
    _username = _fbID;
    _password = _fbID;
    
    PFUser *user = [PFUser user];
    user.username = _username;
    user.password = _password;
    user[@"fbID"] = _fbID;
    user[@"fbFirstName"] = _fbFirstName;
    user[@"fbLastName"] = _fbLastName;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"Sign Up succeed");
            [self login];
        } else {
//            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            [self login];
        }
    }];
}

- (void)login {
    LogMethod;
    // Added
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"fbID"] = _fbID;
    NSMutableSet *channelsSet =  [NSMutableSet setWithArray:currentInstallation[@"channels"]];
    [channelsSet addObject:[@"fbID" stringByAppendingString:_fbID]];
    currentInstallation[@"channels"] = [NSArray arrayWithArray:[channelsSet allObjects]];
    [currentInstallation saveEventually];
    
    [PFUser logInWithUsernameInBackground:_username password:_password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"login succeed");
                                            _currentPFUser = user;
//                                            user[@"fbID"] = self.fbID;
//                                            user[@"fbFirstName"] = self.fbFirstName;
//                                            user[@"fbLastName"] = self.fbLastName;
//                                            [user saveEventually];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSucceed" object:nil];
                                            [self retrieveRecommendations];
                                            [self retrieveFavorites];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"login failed");
                                            _currentPFUser = nil;
                                        }
    }];
}


- (BOOL)isLoggedIn
{
    if (_currentPFUser != nil && _fbID != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)retrieveFavorites {
    LogMethod;
    _currentPFUser = [PFUser currentUser];
//    _favouriteShows = [NSMutableArray new];
    [self.favouriteShows removeAllObjects];
    if (!_currentPFUser) {
        [self login];
    } else {
        NSLog(@"user!!!!");
//        _currentUser
//        NSLog(@"111 %@", _currentUser[@"email"]);
        PFRelation *favouriteShows = _currentPFUser[@"FavouriteShows"];
        PFQuery *queryForFavourite = [favouriteShows query];
        [queryForFavourite setCachePolicy:kPFCachePolicyNetworkElseCache];
        [queryForFavourite orderByDescending:@"createdAt"];
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



- (void)retrieveRecommendations
{
    if (_currentPFUser == nil) {
        return;
    }
//    _recommendations = [NSMutableArray new];
    [self.recommendations removeAllObjects];
    PFQuery *queryForRecommendation = [PFQuery queryWithClassName:@"Recommendation"];
    queryForRecommendation.limit = 1000;
    [queryForRecommendation setCachePolicy:kPFCachePolicyNetworkElseCache];
    
    PFQuery *queryForUser = [PFUser query];
    [queryForUser whereKey:@"fbID" equalTo:[TVUser sharedUser].fbID];

    [queryForRecommendation whereKey:@"recommendee" matchesQuery:queryForUser];
    [queryForRecommendation orderByDescending:@"createdAt"];
    [queryForRecommendation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%d recommendations", [objects count]);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (PFObject *object in objects) {
                    PFObject *showObject = object[@"showID"];
                    PFObject *recommender = object[@"recommender"];
                    [showObject fetchIfNeeded];
                    [recommender fetchIfNeeded];
                    TVShow *aShow = [[TVShow alloc] initWithParseShowObjectNoEpisodes:showObject];
                    NSLog(@"%@", aShow.title);
                    NSLog(@"%@", recommender[@"fbFirstName"]);
                    objc_setAssociatedObject(aShow, @"Recommender", recommender, OBJC_ASSOCIATION_RETAIN);
                    [_recommendations addObject:aShow];
                    
                }
                NSLog(@"Total recommendations: %d", [_recommendations count]);
                NSLog(@"Post recommendation updated");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RecommendationUpdated" object:self userInfo:nil];
                });
            });
        } else {
            NSLog(@"Query recommendations failed");
        }
    }];
}

@end

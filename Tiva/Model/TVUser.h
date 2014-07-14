//
//  TVUser.h
//  Tiva
//
//  Created by Zhang Honghao on 6/21/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;
@class PFInstallation;

@interface TVUser : NSObject

//@property (nonatomic, strong) PFInstallation *currentInstallation;
@property (nonatomic, strong) PFUser *currentPFUser;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordSha1;

@property (strong, nonatomic) NSString *fbID;
@property (nonatomic, strong) NSString *fbFirstName;
@property (nonatomic, strong) NSString *fbLastName;
//@property (nonatomic, strong) NSString *fbEmail;

@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSMutableArray *favouriteShows;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *recommendations;

+ (TVUser *)sharedUser;
- (BOOL)isLoggedIn;
- (void)setUsername:(NSString *)username andPassword:(NSString *)password;
- (void)signUp;
- (void)login;

- (void)retrieveFavorites;
- (void)retrieveRecommendations;

@end

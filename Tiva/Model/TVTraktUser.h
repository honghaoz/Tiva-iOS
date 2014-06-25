//
//  TVTraktUser.h
//  Tiva
//
//  Created by Zhang Honghao on 6/21/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;

@interface TVTraktUser : NSObject

@property (nonatomic, strong) PFUser *currentUser;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordSha1;

@property (nonatomic, strong) NSMutableArray *favouriteShows;
@property (nonatomic, strong) NSMutableArray *friends;

+ (TVTraktUser *)sharedUser;
- (void)setUsername:(NSString *)username andPassword:(NSString *)password;
- (void)login;
- (void)retrieveUserData;

@end

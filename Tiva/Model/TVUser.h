//
//  TVUser.h
//  Tiva
//
//  Created by Zhang Honghao on 6/21/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;

@interface TVUser : NSObject

@property (nonatomic, strong) PFUser *currentPFUser;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordSha1;

@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSMutableArray *favouriteShows;
@property (nonatomic, strong) NSMutableArray *friends;

+ (TVUser *)sharedUser;
- (void)setUsername:(NSString *)username andPassword:(NSString *)password;
- (void)login;
- (void)retrieveUserData;

@end

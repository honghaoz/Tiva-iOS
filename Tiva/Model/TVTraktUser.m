//
//  TVTraktUser.m
//  Tiva
//
//  Created by Zhang Honghao on 6/21/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVTraktUser.h"
#import <NSString-Hashes/NSString+Hashes.h>

@implementation TVTraktUser

+ (TVTraktUser *)sharedUser {
    static TVTraktUser *sharedUser = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedUser = [[self alloc] init];
    });
    return sharedUser;
}

- (void)setUsername:(NSString *)username andPassword:(NSString *)password {
    _username = username;
    _password = password;
    _passwordSha1 = [password sha1];
}

@end

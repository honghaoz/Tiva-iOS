//
//  NSMutableArray+InsertInOrder.h
//  Tiva
//
//  Created by Zhang Honghao on 6/22/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (InsertInOrder)

- (void)insertObject:(id)anObject usingComparator:(NSComparator)comparator;

@end

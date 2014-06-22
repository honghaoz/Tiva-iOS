//
//  NSMutableArray+InsertInOrder.m
//  Tiva
//
//  Created by Zhang Honghao on 6/22/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "NSMutableArray+InsertInOrder.h"

@implementation NSMutableArray (InsertInOrder)

- (void)insertObject:(id)anObject usingComparator:(NSComparator)comparator {
    NSUInteger newIndex = [self indexOfObject:anObject
                                 inSortedRange:(NSRange){0, [self count]}
                                       options:NSBinarySearchingInsertionIndex
                               usingComparator:comparator];
    [self insertObject:anObject atIndex:newIndex];
}

@end

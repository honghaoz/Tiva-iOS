//
//  NSMutableArray+AddUnique.m
//  Tiva
//
//  Created by Honghao on 7/11/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "NSMutableArray+AddUnique.h"

@implementation NSMutableArray (AddUnique)

- (BOOL)isUnique:(id)object uniqueComparator:(NSComparator)uniqueComparator {
    for (id each in self) {
        if (uniqueComparator(each, object) == NSOrderedSame) return NO;
    }
    return YES;
}

- (BOOL)addUniqueObject:(id)object usingUniqueComparator:(NSComparator)uniqueComparator {
    if (![self isUnique:object uniqueComparator:uniqueComparator])
        return NO;
    [self addObject:object];
    return YES;
}

- (BOOL)addUniqueObject:(id)object usingUniqueComparator:(NSComparator)uniqueComparator orderComparator:(NSComparator)orderComparator {
    if (![self isUnique:object uniqueComparator:uniqueComparator])
        return NO;
    NSUInteger newIndex = [self indexOfObject:object
                                inSortedRange:(NSRange){0, [self count]}
                                      options:NSBinarySearchingInsertionIndex| NSBinarySearchingLastEqual
                              usingComparator:orderComparator];
    [self insertObject:object atIndex:newIndex];
    return YES;
}

@end

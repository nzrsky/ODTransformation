//
//  ODXCore_Test.m
//  ODX.Core
//
//  Created by Alex Nazaroff on 12.01.10.
//  Copyright © 2009-2015 AJR. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ODXCore.h"

@interface ODTransformation_Array_Test : XCTestCase
@end

@implementation ODTransformation_Array_Test

- (void)testEvery {
    XCTAssert([(@[ @0, @1, @2 ]) od_everyObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue >= 0;
    }]);
    
    XCTAssert(![(@[ @0, @1, @2 ]) od_everyObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 0;
    }]);
    
    XCTAssert( [@[ @1 ] od_everyObject:nil] == YES );
    XCTAssert( [@[] od_everyObject:^BOOL(id obj, NSUInteger idx) {
        return YES;
    }] == YES );
}

- (void)testSome {
    XCTAssert([(@[ @0, @1, @2 ]) od_someObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 0;
    }]);
    
    XCTAssert(![(@[ @0, @1, @2 ]) od_someObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue < 0;
    }]);
    
    XCTAssert( [@[ @1 ] od_someObject:nil] == NO );
    XCTAssert( [@[] od_someObject:^BOOL(id obj, NSUInteger idx) {
        return YES;
    }] == NO );
}

- (void)testFilterObject {
    XCTAssert([[(@[ @0, @1, @2 ]) od_filterObject:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 1;
    }] intValue] == 2);
    
    XCTAssert([(@[ @0, @1, @2 ]) od_filterObject:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);
    
    XCTAssert([(@[]) od_filterObject:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);
    XCTAssert([@[@1] od_filterObject:nil] == nil);
}

- (void)testFilterObjects {
    XCTAssert([[(@[ @0, @1, @2 ]) od_filterObjects:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 1;
    }] count] == 1);
    
    XCTAssert([(@[ @0, @1, @2 ]) od_filterObjects:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 2;
    }].count == 0);
    
    XCTAssert([@[@1] od_filterObjects:nil] == nil);
    XCTAssert([@[] od_filterObjects:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) { return YES; }].count == 0);
}

- (void)testMap {
    XCTAssert([[(@[ @0, @1, @2 ]) od_mapObjects:^id(id obj, NSUInteger idx) {
        return [obj stringValue];
    }] isEqualToArray:(@[ @"0", @"1", @"2" ])]);
    
    XCTAssert([[(@[ @0, @1, @2 ]) od_mapObjects:^id(id obj, NSUInteger idx) {
        return nil;
    }] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null] ])]);
    
    XCTAssert([[@[@1] od_mapObjects:nil] isEqualToArray:@[ @1 ]]);
    XCTAssert([@[] od_mapObjects:^id(id obj, NSUInteger idx) { return @"a"; }].count == 0);
}

- (void)testReduce {
    XCTAssert([[(@[ @0, @1, @2 ]) od_reduceObjects:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue] == 3);
    
    XCTAssert([[(@[ @0, @1, @2 ]) od_reduceObjects:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue] == 4);
    
    XCTAssert([(@[ @0, @1]) od_reduceObjects:nil] == nil);
    XCTAssert([(@[]) od_reduceObjects:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    }] == nil);
}

- (void)testMapDict {
    XCTAssert([[(@[ @0, @1]) od_dictionaryWithMappedKeys:^id(id obj, NSUInteger idx) {
        return [[obj stringValue] stringByAppendingString:@"_"];
    }] isEqualToDictionary:(@{ @"0_": @0, @"1_": @1 })]);
    
    XCTAssert([[(@[ @0 ]) od_dictionaryWithMappedKeys:nil] isEqualToDictionary:(@{ @0: @0})]);
    XCTAssert([[(@[]) od_dictionaryWithMappedKeys:^id(id obj, NSUInteger idx) {
        return [[obj stringValue] stringByAppendingString:@"_"];
    }] isEqualToDictionary:(@{})]);
    
    XCTAssert([[(@[ @0, @1]) od_dictionaryWithMappedKeys:^id(id obj, NSUInteger idx) {
        return nil;
    }] isEqualToDictionary:(@{ [NSNull null]: @0 })]);
}

@end


@interface ODTransformation_Set_Test : XCTestCase
@end

@implementation ODTransformation_Set_Test

- (void)testEvery {
    XCTAssert([([NSSet setWithObjects:@0, @1, @2, nil]) od_everyObject:^BOOL(NSNumber *obj) {
        return obj.intValue >= 0;
    }]);
    
    XCTAssert(![([NSSet setWithObjects: @0, @1, @2, nil]) od_everyObject:^BOOL(NSNumber *obj) {
        return obj.intValue > 0;
    }]);
    
    XCTAssert( [([NSSet setWithObjects: @1, nil]) od_everyObject:nil] == YES );
    XCTAssert( [[NSSet set] od_everyObject:^BOOL(id obj) {
        return YES;
    }] == YES );
}

- (void)testSome {
    XCTAssert([([NSSet setWithObjects: @0, @1, @2, nil]) od_someObject:^BOOL(NSNumber *obj) {
        return obj.intValue > 0;
    }]);
    
    XCTAssert(![([NSSet setWithObjects: @0, @1, @2, nil]) od_someObject:^BOOL(NSNumber *obj) {
        return obj.intValue < 0;
    }]);
    
    XCTAssert( [([NSSet setWithObjects: @1, nil]) od_someObject:nil] == NO );
    XCTAssert( [[NSSet set] od_someObject:^BOOL(id obj) {
        return YES;
    }] == NO );
}

- (void)testFilterObject {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil]) od_filterObject:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] intValue] == 2);
    
    XCTAssert([([NSSet setWithObjects: @0, @1, @2, nil]) od_filterObject:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);
    
    XCTAssert([([NSSet set]) od_filterObject:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);
    
    XCTAssert([([NSSet setWithObjects:@1, nil]) od_filterObject:nil] == nil);
}

- (void)testFilterObjects {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil]) od_filterObjects:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] count] == 1);
    
    XCTAssert([([NSSet setWithObjects: @0, @1, @2, nil ]) od_filterObjects:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }].count == 0);
    
    XCTAssert([([NSSet setWithObjects:@1, nil]) od_filterObjects:nil] == nil);
    XCTAssert([[NSSet set] od_filterObjects:^BOOL(NSNumber *obj, BOOL *stop) { return YES; }].count == 0);
}

- (void)testMap {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil ]) od_mapObjects:^id(id obj) {
        return [obj stringValue];
    }] isEqualToSet:([NSSet setWithObjects: @"0", @"1", @"2", nil])]);
    
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil]) od_mapObjects:^id(id obj) {
        return nil;
    }] isEqualToSet:([NSSet setWithObjects: [NSNull null], [NSNull null], [NSNull null], nil])]);
    
    XCTAssert([[([NSSet setWithObjects:@1, nil]) od_mapObjects:nil] isEqualToSet:([NSSet setWithObjects: @1, nil])]);
    XCTAssert([[NSSet set] od_mapObjects:^id(id obj) { return @"a"; }].count == 0);
}

- (void)testReduce {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2 , nil]) od_reduceObjects:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue] == 3);
    
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil ]) od_reduceObjects:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue] == 4);
    
    XCTAssert([([NSSet setWithObjects: @0, @1, nil]) od_reduceObjects:nil] == nil);
    XCTAssert([([NSSet set]) od_reduceObjects:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] == nil);
}

@end


@interface ODTransformation_Dictionary_Test : XCTestCase
@end

@implementation ODTransformation_Dictionary_Test

- (void)testEvery {
    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) od_everyObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue >= 0;
    }]);
    
    XCTAssert(![(@{@0: @0, @1: @1, @2: @2}) od_everyObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 0;
    }]);
    
    XCTAssert( [(@{@1: @1}) od_everyObject:nil] == YES );
    XCTAssert( [@{} od_everyObject:^BOOL(id key, id obj) {
        return YES;
    }] == YES );
}

- (void)testSome {
    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) od_someObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 0;
    }]);
    
    XCTAssert(![(@{@0: @0, @1: @1, @2: @2}) od_someObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue < 0;
    }]);
    
    XCTAssert( [(@{@1: @1}) od_someObject:nil] == NO );
    XCTAssert( [@{} od_someObject:^BOOL(id key, id obj) {
        return YES;
    }] == NO );
}

- (void)testFilterObject {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) od_filterObject:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] intValue] == 2);
    
    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) od_filterObject:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);
    
    XCTAssert([(@{}) od_filterObject:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);
    
    XCTAssert([(@{@1: @1}) od_filterObject:nil] == nil);
}

- (void)testFilterObjects {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) od_filterObjects:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] count] == 1);
    
    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) od_filterObjects:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }].count == 0);
    
    XCTAssert([(@{@1: @1}) od_filterObjects:nil] == nil);
    XCTAssert([@{} od_filterObjects:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) { return YES; }].count == 0);
}

- (void)testMap {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) od_mapObjects:^id(id key, id obj) {
        return [obj stringValue];
    }] isEqualToDictionary:(@{@0:@"0", @1:@"1", @2:@"2"})]);
    
    XCTAssert([[(@{@0:@0, @1:@1, @2:@2}) od_mapObjects:^id(id key, id obj) {
        return nil;
    }] isEqualToDictionary:(@{@0:[NSNull null], @1:[NSNull null], @2:[NSNull null]})]);
    
    XCTAssert([[(@{@1:@1}) od_mapObjects:nil] isEqualToDictionary:(@{@1:@1})]);
    XCTAssert([@{} od_mapObjects:^id(id key, id obj) { return @"a"; }].count == 0);
    
    
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) od_mapKeys:^id(id key, id obj) {
        return [obj stringValue];
    }] isEqualToDictionary:(@{@"0": @0, @"1":@1, @"2":@2})]);
    
    XCTAssert([(@{@0:@0, @1:@1, @2:@2}) od_mapKeys:^id(id key, id obj) {
        return nil;
    }].count == 1 );
    
    XCTAssert([[(@{@1:@1}) od_mapKeys:nil] isEqualToDictionary:(@{@1:@1})]);
    XCTAssert([@{} od_mapKeys:^id(id key, id obj) { return @"a"; }].count == 0);
}

- (void)testReduce {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2 }) od_reduceObjects:^id(NSNumber *value, NSNumber *key, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue] == 3);
    
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) od_reduceObjects:^id(NSNumber *value, NSNumber *key, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue] == 4);
    
    XCTAssert([(@{@0: @0, @1: @1}) od_reduceObjects:nil] == nil);
    XCTAssert([(@{}) od_reduceObjects:^id(NSNumber *key, NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] == nil);
}

@end
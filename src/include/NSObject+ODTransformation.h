//
// NSObject+ODTransformation.h
//
// Copyright (c) 2009-2015 Alexey Nazaroff, AJR
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (ODXCore_Transformation)
- (BOOL)od_everyObject:(BOOL (^)(ObjectType obj, NSUInteger idx))predicate NS_AVAILABLE(10_6, 4_0);
- (BOOL)od_someObject:(BOOL (^)(ObjectType obj, NSUInteger idx))predicate NS_AVAILABLE(10_6, 4_0);

- (NSArray<ObjectType> *)od_filterObjects:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (ObjectType)od_filterObject:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);

- (NSArray *)od_mapObjects:(id (^)(ObjectType obj, NSUInteger idx))predicate NS_AVAILABLE(10_6, 4_0);

- (id)od_reduceObjects:(ObjectType (^)(ObjectType value, ObjectType obj, NSUInteger idx))predicate NS_AVAILABLE(10_6, 4_0);
- (id)od_reduceObjects:(ObjectType (^)(ObjectType value, ObjectType obj, NSUInteger idx))predicate initial:(ObjectType)initial NS_AVAILABLE(10_6, 4_0);

- (NSDictionary *)od_dictionaryWithMappedKeys:(id (^)(ObjectType obj, NSUInteger idx))predicate NS_AVAILABLE(10_6, 4_0);
@end

@interface NSSet<ObjectType> (ODXCore_Transformation)
- (BOOL)od_everyObject:(BOOL (^)(ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);
- (BOOL)od_someObject:(BOOL (^)(ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);

- (NSArray<ObjectType> *)od_filterObjects:(BOOL (^)(ObjectType obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (ObjectType)od_filterObject:(BOOL (^)(ObjectType obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);

- (NSSet *)od_mapObjects:(id (^)(ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);

- (id)od_reduceObjects:(id (^)(id value, ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);
- (id)od_reduceObjects:(id (^)(id value, ObjectType obj))predicate initial:(id)initial NS_AVAILABLE(10_6, 4_0);
@end

@interface NSDictionary<KeyType, ObjectType> (ODXCore_Transformation)
- (BOOL)od_everyObject:(BOOL (^)(KeyType key, ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);
- (BOOL)od_someObject:(BOOL (^)(KeyType key, ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);

- (NSArray<ObjectType> *)od_filterObjects:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (ObjectType)od_filterObject:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);

- (NSDictionary *)od_mapObjects:(id (^)(KeyType key, ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);
- (NSDictionary *)od_mapKeys:(id (^)(KeyType key, ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);

- (id)od_reduceObjects:(id (^)(id value, KeyType key, ObjectType obj))predicate NS_AVAILABLE(10_6, 4_0);
- (id)od_reduceObjects:(id (^)(id value, KeyType key, ObjectType obj))predicate initial:(id)initial NS_AVAILABLE(10_6, 4_0);
@end

NS_INLINE NSComparator ODComparatorWithBlock(BOOL (^less)(id a, id b)) {
    return ^(id a, id b) {
        return less(a, b) ? NSOrderedAscending : (less(b, a) ? NSOrderedDescending : NSOrderedSame);
    };
}
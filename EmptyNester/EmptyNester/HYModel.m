//
//  HYModel.m
//  FMDB_DEMO
//
//  Created by 上官惠阳 on 16/4/7.
//  Copyright © 2016年 上官惠阳. All rights reserved.
//

#import "HYModel.h"

@implementation HYModel

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.modelId = [aDecoder decodeObjectForKey:@"modelId"];
        self.attribute1 = [aDecoder decodeObjectForKey:@"attribute1"];
        self.attribute2 = [aDecoder decodeObjectForKey:@"attribute2"];
        self.attribute3 = [aDecoder decodeObjectForKey:@"attribute3"];
        self.attribute4 = [aDecoder decodeObjectForKey:@"attribute4"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.modelId forKey:@"modelId"];
    [aCoder encodeObject:self.attribute1 forKey:@"attribute1"];
    [aCoder encodeObject:self.attribute2 forKey:@"attribute2"];
    [aCoder encodeObject:self.attribute3 forKey:@"attribute3"];
    [aCoder encodeObject:self.attribute4 forKey:@"attribute4"];
}

@end

//
//  Country.m
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "Country.h"

@implementation Country

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.countryName = [aDecoder decodeObjectForKey:@"countryName"];
    self.continent = [aDecoder decodeObjectForKey:@"continent"];
    self.countryDescription = [aDecoder decodeObjectForKey:@"countryDescription"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.countryName forKey:@"countryName"];
    [aCoder encodeObject:self.continent forKey:@"continent"];
    [aCoder encodeObject:self.countryDescription forKey:@"countryDescription"];
}

@end

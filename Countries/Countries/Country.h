//
//  Country.h
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject <NSCoding>

@property(nonatomic)NSString *countryName;
@property(nonatomic)NSString *countryDescription;
@property(nonatomic)NSString *continent;

@end

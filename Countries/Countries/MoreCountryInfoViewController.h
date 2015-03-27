//
//  MoreCountryInfoViewController.h
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "EditCountryViewController.h"

@interface MoreCountryInfoViewController : UIViewController

@property(nonatomic)Country *country;
@property(nonatomic)NSArray *continentsNames;
@property(nonatomic)id rootController;

@end

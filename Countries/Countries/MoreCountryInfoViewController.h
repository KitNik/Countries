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

@protocol MoreCountryInfoViewControllerDelegate <NSObject>

@optional
//- (void)saveCountryChanges:(Country *)country;
//- (void)deleteCountryWithChanges:(Country *)country;

@end

@interface MoreCountryInfoViewController : UIViewController <EditCountryViewControllerDelegate>

@property(nonatomic)Country *country;
@property(nonatomic)NSArray *continentsNames;
@property(nonatomic, strong)id <MoreCountryInfoViewControllerDelegate> delegate;

@end

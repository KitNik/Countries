//
//  EditCountryViewController.h
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@protocol EditCountryViewControllerDelegate <NSObject>

@optional
- (void)saveCountry:(Country *)newCountry;
- (void)deleteCountry:(Country *)country;

@end

@interface EditCountryViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, strong)id <EditCountryViewControllerDelegate> delegate;
@property(nonatomic)Country *country;
@property(nonatomic)NSArray *continents;

@end

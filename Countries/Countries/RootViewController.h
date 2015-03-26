//
//  ViewController.h
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCountryViewController.h"
#import "MoreCountryInfoViewController.h"

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditCountryViewControllerDelegate, MoreCountryInfoViewControllerDelegate>

@end


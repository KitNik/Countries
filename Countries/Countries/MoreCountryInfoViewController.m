//
//  MoreCountryInfoViewController.m
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "MoreCountryInfoViewController.h"

@interface MoreCountryInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *continentLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionCountryLabel;

@end

@implementation MoreCountryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.country) {
        self.countryLabel.text = self.country.countryName;
        self.continentLabel.text = self.country.continent;
        self.descriptionCountryLabel.text = self.country.countryDescription;
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editCountryInfo)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)editCountryInfo {
    UIStoryboard *storyboard = self.storyboard;
    EditCountryViewController *editCountry = [storyboard instantiateViewControllerWithIdentifier:@"EditCountryViewController"];
    editCountry.country = self.country;
    editCountry.continents = self.continentsNames;
    editCountry.delegate = self;
    
    [self.navigationController pushViewController:editCountry animated:YES];
}

//#pragma mark - EditCountryViewControllerDelegate
//
//- (void)saveCountry:(Country *)newCountry {
//    if ([self.delegate respondsToSelector:@selector(saveCountryChanges:)]) {
//        [self.delegate saveCountryChanges:newCountry];
//    }
//}
//
//- (void)deleteCountry:(Country *)country {
//    if ([self.delegate respondsToSelector:@selector(deleteCountryWithChanges:)]) {
//        [self.delegate deleteCountryWithChanges:country];
//    }
//}


@end

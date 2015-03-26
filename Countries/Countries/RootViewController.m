//
//  ViewController.m
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "RootViewController.h"

#import "ConstContinents.h"
#import "Country.h"

@interface RootViewController ()

@property(nonatomic)NSMutableArray *listCountries;
@property(nonatomic)NSDictionary *continents;
@property(nonatomic)NSArray *continentsNameKey;
@property(nonatomic)NSMutableArray *continentsToShow;
@property (weak, nonatomic) IBOutlet UITableView *countriesTable;

@end

@implementation RootViewController

- (void)viewDidLoad {
    Country *countryUK = [[Country alloc] init];
    countryUK.countryName = @"Ukraine";
    countryUK.continent = EUROPE;
    countryUK.countryDescription = @"Beautiful country!";
    
    Country *countryBN = [[Country alloc] init];
    countryBN.countryName = @"Benin";
    countryBN.continent = AFRICA;
    countryBN.countryDescription = @"Description country!";
    
    Country *countryCG = [[Country alloc] init];
    countryCG.countryName = @"Congo";
    countryCG.continent = AFRICA;
    countryCG.countryDescription = @"Description country!";
    
    //self.listCountries = [[NSMutableArray alloc] init];
    self.continentsToShow = [NSMutableArray new];
    self.continentsNameKey = [NSArray arrayWithObjects:AFRICA, ASIA, EUROPE, NORTH_AMERICA, OCEANIA, SOUTH_AMERICA, nil];
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    
    for(NSInteger i = 0; i < self.continentsNameKey.count; i++) {
        NSMutableArray *countries = [[NSMutableArray alloc] init];
        [tempDictionary setObject:countries forKey:self.continentsNameKey[i]];
    }
    
    self.continents = [NSDictionary dictionaryWithDictionary:tempDictionary];
    
    NSMutableArray *tempArr = [self.continents objectForKey:EUROPE];
    [tempArr addObject:countryUK];
    tempArr = [self.continents objectForKey:AFRICA];
    [tempArr addObject:countryBN];
    [tempArr addObject:countryCG];
    
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addCountry)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self reloadShowSection];
    [self.countriesTable reloadData];
}

- (void)reloadShowSection {
    for (NSInteger i = 0; i < self.continentsNameKey.count; i++) {
        NSArray *tempArr = [self.continents objectForKey:self.continentsNameKey[i]];
        if (tempArr.count > 0) {
            if (![self.continentsToShow containsObject:self.continentsNameKey[i]]) {
                [self.continentsToShow addObject:self.continentsNameKey[i]];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerSection;
    headerSection = [self.continentsToShow objectAtIndex:section];
    
    return headerSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.continentsToShow count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowsCount = 0;

    NSArray *tempArr = [self.continents objectForKey:self.continentsToShow[section]];
    if (tempArr.count > 0) {
        rowsCount = tempArr.count;
    }

    return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger section = indexPath.section;
    NSString *continent = self.continentsToShow[section];
    Country *country = [self.continents objectForKey:continent][indexPath.row];
    if (country) {
        cell.textLabel.text = country.countryName;
    }
    
    return cell;
}

#pragma mark - UITableViewdelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = self.storyboard;
    MoreCountryInfoViewController *moreInfo = [storyboard instantiateViewControllerWithIdentifier:@"MoreCountryInfoViewController"];
    moreInfo.title = @"More Info";
    NSMutableArray *tempArr = [self.continents objectForKey:self.continentsToShow[indexPath.section]];
    moreInfo.country = tempArr[indexPath.row];
    moreInfo.continentsNames = self.continentsNameKey;
    moreInfo.delegate = self;
    
    [self.navigationController pushViewController:moreInfo animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - EditCountryViewControllerDelegate

- (void)saveCountry:(Country *)newCountry {
    [self saveNewCountry:newCountry];
}

- (void)deleteCountry:(Country *)country {
    [self removeCountry:country];
}

#pragma mark - MoreCountryInfoViewControllerDelegate

- (void)saveCountryChanges:(Country *)country {
    [self saveCountryChanges:country];
}

- (void)deleteCountryWithChanges:(Country *)country {
    [self removeCountry:country];
}


#pragma mark - Actions

- (void)addCountry {
    UIStoryboard *storyboard = self.storyboard;
    EditCountryViewController *editCountry = [storyboard instantiateViewControllerWithIdentifier:@"EditCountryViewController"];
    editCountry.continents = self.continentsNameKey;
    editCountry.delegate = self;

    [self.navigationController pushViewController:editCountry animated:YES];
}

#pragma mark - ChangeContinentsDataMethods

- (void)saveNewCountry:(Country *)newCountry {
    [[self.continents objectForKey:newCountry.continent] addObject:newCountry];
    if ([self.continentsToShow containsObject:newCountry.continent]) {
        [self reloadShowSection];
        NSInteger reloadContinentIndex = [self.continentsToShow indexOfObject:newCountry.continent];
        [self.countriesTable reloadSections:[NSIndexSet indexSetWithIndex:reloadContinentIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self reloadShowSection];
    }
}

- (void)saveChangesInCountry:(Country *)country {
    [self removeCountry:country];
    [self saveNewCountry:country];
}

- (void)removeCountry:(Country *)country {
    NSMutableArray *tempArr = [self.continents objectForKey:country.continent];
    for (NSInteger i = 0; i < tempArr.count; i++) {
        Country *tempCountry = [tempArr objectAtIndex:i];
        if ([tempCountry.countryName isEqualToString:country.countryName]) {
            [tempArr removeObjectAtIndex:i];
            break;
        }
    }
}

@end

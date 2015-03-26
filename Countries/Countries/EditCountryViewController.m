//
//  EditCountryViewController.m
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "EditCountryViewController.h"

@interface EditCountryViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIPickerView *continentsPickerView;
@property (weak, nonatomic) IBOutlet UITextField *countryNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionCountryTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation EditCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.continentsPickerView.delegate = self;
    self.continentsPickerView.dataSource = self;
    if (self.country) {
        self.deleteButton.hidden = NO;
        self.countryNameTextField.text = self.country.countryName;
        self.descriptionCountryTextView.text = self.country.countryDescription;
        
        for (NSInteger i = 0; i < self.continents.count; i++) {
            //NSString *nameContinent = [self.continents objectAtIndex:i];
            if ([self.country.continent isEqualToString:self.continents[i]]) {
                //[self.continentsPickerView selectedRowInComponent:i];
                [self.continentsPickerView reloadAllComponents];
                [self.continentsPickerView selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    } else {
        self.deleteButton.hidden = YES;
    }
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.countryNameTextField.delegate = self;
    self.descriptionCountryTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.continents.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.continents[row];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.countryNameTextField resignFirstResponder];
    [self.countryNameTextField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.countryNameTextField endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.descriptionCountryTextView endEditing:YES];
}



#pragma mark - Actions

- (IBAction)deleteCountry:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteCountry:)]) {
        Country *country = [[Country alloc] init];
        country.countryName = self.countryNameTextField.text;
        country.countryDescription = self.descriptionCountryTextView.text;
        country.continent = self.continents[[self.continentsPickerView selectedRowInComponent:0]];
        [self.delegate deleteCountry:country];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    if ([self.delegate respondsToSelector:@selector(saveCountry:)]) {
        Country *country = [[Country alloc] init];
        country.countryName = self.countryNameTextField.text;
        country.countryDescription = self.descriptionCountryTextView.text;
        country.continent = self.continents[[self.continentsPickerView selectedRowInComponent:0]];
        [self.delegate saveCountry:country];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

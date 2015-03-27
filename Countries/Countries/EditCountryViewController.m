//
//  EditCountryViewController.m
//  Countries
//
//  Created by Nikita on 26.03.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "EditCountryViewController.h"

#define KEYBOARD_OFFSET 200
#define SCROLL_ANIMATED 0.2

@interface EditCountryViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIPickerView *continentsPickerView;
@property (weak, nonatomic) IBOutlet UITextField *countryNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionCountryTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic) BOOL textViewSelected;

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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.countryNameTextField]) {
        self.textViewSelected = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.countryNameTextField endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView isEqual:self.descriptionCountryTextView]) {
        self.textViewSelected = YES;
        if  (self.view.frame.origin.y >= 0) {
            [self moveView:YES];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.descriptionCountryTextView endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)save {
    if ([self.countryNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!"
                                                        message:@"Enter the name of the country!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    Country *country = [[Country alloc] init];
    country.countryName = self.countryNameTextField.text;
    country.countryDescription = self.descriptionCountryTextView.text;
    country.continent = self.continents[[self.continentsPickerView selectedRowInComponent:0]];
    
    if (self.country) {
        if ([self.delegate respondsToSelector:@selector(saveChangesIn:orReplaceBy:)]) {
            [self.delegate saveChangesIn:self.country orReplaceBy:country];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(saveCountry:)]) {
            [self.delegate saveCountry:country];
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma  mark - MoveUIViewWithKeyboard

-(void)moveView:(BOOL)move {
    if (!self.textViewSelected) {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:SCROLL_ANIMATED];
    
    CGRect rect = self.view.frame;
    if (move) {
        rect.origin.y -= KEYBOARD_OFFSET;
        rect.size.height += KEYBOARD_OFFSET;
    } else {
        rect.origin.y += KEYBOARD_OFFSET;
        rect.size.height -= KEYBOARD_OFFSET;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)keyboardWillShow {
    if (self.view.frame.origin.y >= 0) {
        [self moveView:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self moveView:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0) {
        [self moveView:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self moveView:NO];
    }
}

@end

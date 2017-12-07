//
//  ViewController.m
//  Example
//
//  Created by pronebird on 6/13/16.
//  Copyright © 2016 pronebird. All rights reserved.
//

#import <POLocalizedString/POLocalizedString.h>
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (strong, nonatomic) NSBundle *bundle;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bundle = [NSBundle bundleWithIdentifier:@"com.hulab.POLocalizedString.example.l18n"];
    
    /// Title label
    self.titleLabel.text = POLocalizedStringInBundle(self.bundle, @"Choose number of apples");
    
    self.subTitleLabel.text = nil;
}

- (IBAction)sliderValueDidChange:(id)sender {
    /// Sub-title with number of apples
    NSString *format = POLocalizedPluralStringInBundle(self.bundle, @"%@ apple", @"%@ apples", self.slider.value);
    
    self.subTitleLabel.text = [NSString stringWithFormat:format, [NSNumber numberWithInteger:self.slider.value]];
}

@end

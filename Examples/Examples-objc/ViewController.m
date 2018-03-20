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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// Title label
    self.titleLabel.text = POLocalizedString(@"Choose number of apples");
    
    self.subTitleLabel.text = nil;
    
    NSString *systemVersion = UIDevice.currentDevice.systemVersion;
    self.versionLabel.text = [NSString stringWithFormat:POLocalizedString(@"iOS %s"), systemVersion];
}

- (IBAction)sliderValueDidChange:(id)sender {
    /// Sub-title with number of apples
    NSString *format = POLocalizedPluralFormat(@"%i apple", @"%i apples", self.slider.value);
    
    self.subTitleLabel.text = [NSString stringWithFormat:format, (int)self.slider.value];
}

@end

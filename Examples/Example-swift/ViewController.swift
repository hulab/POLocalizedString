//
//  ViewController.swift
//  Example-Swift
//
//  Created by pronebird on 6/13/16.
//  Copyright © 2016 pronebird. All rights reserved.
//

import UIKit
import POLocalizedString

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var bundle: Bundle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bundle = Bundle(identifier: "com.hulab.POLocalizedString.example.l18n")!
        
        /// Title label
        titleLabel.text = POLocalizedStringInBundle(bundle, "Choose number of apples")
        
        subTitleLabel.text = " "
    }

    @IBAction func sliderValueDidChange(_ sender: AnyObject) {
        let count = Int(slider.value)
        
        /// Sub-title with number of apples
        let format = POLocalizedPluralStringInBundle(bundle, "%@ apple", "%@ apples", count)
        
        subTitleLabel.text = String(format: format, NSNumber(value: count))
    }
    
}


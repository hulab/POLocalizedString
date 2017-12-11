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
    @IBOutlet weak var versionLabel: UILabel!
    
    var bundle: Bundle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bundle = Bundle(identifier: "com.hulab.POLocalizedString.example.L10n")!
        
        /// Title label
        titleLabel.text = "Choose number of apples".localized(in: bundle)
        
        subTitleLabel.text = nil

        versionLabel.text = "iOS %s".localized(in: bundle, with: UIDevice.current.systemVersion.ascii)
    }

    @IBAction func sliderValueDidChange(_ sender: AnyObject) {
        let count = Int(slider.value)
        
        /// Sub-title with number of apples
        subTitleLabel.text = "%i apple".localized(plural: "%i apples", n: count, in: bundle, with: count)
    }
    
}


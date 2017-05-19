//
//  NavigationController.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

  override var shouldAutorotate : Bool {
    // Disabling autoritation in iOS before 8.0 due to limitation of size classes, please see my email
    let versionString : NSString = UIDevice.current.systemVersion as NSString
    let versionNumber = versionString.floatValue
    print("version number is \(versionNumber)")
    if versionNumber < 8.0 {
      return false
    } else {
      return true
    }
  }

} // End

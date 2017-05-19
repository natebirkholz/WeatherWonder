//
//  DetailViewController.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {

  @IBOutlet weak var detailImageView: UIImageView!
  @IBOutlet weak var detailDayLabel: UILabel!
  @IBOutlet weak var detailHumidityLabel: UILabel!
  @IBOutlet weak var detailHighLabel: UILabel!
  @IBOutlet weak var detailLowLabel: UILabel!

  var forecastForDetail : Forecast!
  var forecastDetailImage : UIImage!

  override func viewDidLoad() {
      super.viewDidLoad()

      let humidityLabelText = "Humidity: \(self.forecastForDetail.forecastHumidity.description) %"
      let highLabelText = "High: \(self.forecastForDetail.forecastMaxTemp.description)°"
      let lowLabelText = "Low: \(self.forecastForDetail.forecastMinTemp.description)°"

      self.detailImageView.image = self.forecastDetailImage
      self.detailDayLabel.text = self.forecastForDetail.forecastDay
      self.detailHumidityLabel.text = humidityLabelText
      self.detailHighLabel.text = highLabelText
      self.detailLowLabel.text = lowLabelText

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

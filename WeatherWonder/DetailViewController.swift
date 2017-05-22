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

    var forecastForDetail: Forecast!
    var forecastDetailImage: UIImage!

    /// Recognizes left-direction swipes to dismiss the DetailViewController
    var swipeRecognizerLeft: UISwipeGestureRecognizer!
    /// Recognizes right-direction swipes to dismiss the DetailViewController
    var swipeRecognizerRight: UISwipeGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        let humidityLabelText = "Humidity: \(forecastForDetail.forecastHumidity.description) %"
        let highLabelText = "High: \(forecastForDetail.forecastMaxTemp.description)°"
        let lowLabelText = "Low: \(forecastForDetail.forecastMinTemp.description)°"

        detailImageView.image = forecastDetailImage
        detailDayLabel.text = forecastForDetail.forecastDay
        detailHumidityLabel.text = humidityLabelText
        detailHighLabel.text = highLabelText
        detailLowLabel.text = lowLabelText

        swipeRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRecognizerLeft.direction = .left
        swipeRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRecognizerRight.direction = .right
        view.addGestureRecognizer(swipeRecognizerLeft)
        view.addGestureRecognizer(swipeRecognizerRight)
    }

    /// Swipe left or right to dismiss the DetailViewController
    ///
    /// - Parameter sender: The activated UISwipeGestureRecognizer
    fileprivate dynamic func didSwipe(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
}

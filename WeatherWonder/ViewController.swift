//
//  ViewController.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    // MARK: Properties

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var forecasts: [Forecast]?
    let networkController = NetworkController()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource =  self
        tableView.delegate = self
        navigationController?.delegate = self
        tableView.register((UINib(nibName: "WeatherCell", bundle: Bundle.main)), forCellReuseIdentifier: "FORECAST_CELL")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        networkController.locationController.updadeLocation { [unowned self] in
            self.networkController.getForecasts({ [unowned self] (maybeForecasts, maybeError) in
                self.activityIndicator.stopAnimating()

                guard maybeError == nil else {
                    self.handleError(error: maybeError!)
                    return
                }

                guard let isForecasts = maybeForecasts else {
                    assertionFailure("Should never get here, please ensure that forecasts are always returned if error is nil.")
                    self.handleError(error: .unknownError)
                    return
                }

                self.forecasts = isForecasts
                self.tableView.reloadData()
            })
        }
    }

    // MARK: UITableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecastForRow = forecasts?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FORECAST_CELL", for: indexPath) as! WeatherCell

        // Keep images consistent in tableView
        let currentTag = cell.tag + 1
        cell.tag = currentTag

        if let forecastType = forecastForRow?.forecastType, let day = forecastForRow?.forecastDay {
            cell.forecastImage.image = getImageForCell(withForecast: forecastType)
            cell.forecastLabel.text = day

            switch forecastType {
            case .sunny:
                cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.35)
            case .cloudy:
                cell.backgroundColor = UIColor.blue.withAlphaComponent(0.35)
            case .rainy:
                cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.35)
            }
        } else {
            cell.forecastImage.image = getImageForCell(withForecast: .sunny)
            cell.forecastLabel.text = "Funday!"
            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.35)
        }

        return cell
    }

    func getImageForCell(withForecast forecastType: ForecastType) -> UIImage {
        switch forecastType {
        case .rainy:
            return UIImage(named: "Rainy")!
        case .cloudy:
            return UIImage(named: "Cloudy")!
        case .sunny:
            return UIImage(named: "Sunny")!
        }
    }

    // MARK: Transition

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SHOW_DETAIL", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SHOW_DETAIL" {
            guard let indexPathForForecast = tableView.indexPathForSelectedRow else { return }
            let detailVC = segue.destination as! DetailViewController
            let detailForecast = forecasts?[indexPathForForecast.row]
            let cell = tableView.cellForRow(at: indexPathForForecast) as! WeatherCell
            let image = cell.forecastImage.image
            detailVC.forecastForDetail = detailForecast
            detailVC.forecastDetailImage = image
        }
    }

    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        super.performSegue(withIdentifier: identifier, sender: sender)
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC == self && toVC.isKind(of: DetailViewController.self) {
            let transitionVC = AnimateToDetailVCController()
            return transitionVC
        } else {
            return nil
        }
    }
}

// MARK: Error Handling

extension ViewController {
    func handleError(error: NetworkControllerError) {
        switch error {
        case .failedResponse:
            showError(message: "The request to ther server was unrecognized.")
        case .noData:
            showError(message: "The server failed to return data.")
        case .noResponse:
            showError(message: "The server failed to respond.")
        case .parseError:
            showError(message: "The server returned unrecognized data.")
        case .unknownError:
            showError(message: "An unknown error occurred.")
        case .badURL:
            showError(message: "The request to the server failed to begin.")
        }
    }

    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: "\(message) Please verify your Internet connection and try again in a moment.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


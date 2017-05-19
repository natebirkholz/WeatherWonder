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

    @IBOutlet weak var tableView: UITableView!

    var forecasts : [Forecast]?
    var networkController : NetworkController!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource =  self
        tableView.delegate = self
        navigationController?.delegate = self
        networkController = NetworkController()
        tableView.register((UINib(nibName: "WeatherCell", bundle: Bundle.main)), forCellReuseIdentifier: "FORECAST_CELL")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        networkController.locationController.updadeLocation { _ in
            self.networkController.getJSONForForecasts({ (maybeForecasts, maybeError) in
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
        return self.forecasts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecastForRow = self.forecasts?[(indexPath as NSIndexPath).row] as Forecast!
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FORECAST_CELL", for: indexPath) as! WeatherCell
        // Keep images consistent in tableView
        let currentTag = cell.tag + 1
        cell.tag = currentTag
        cell.forecastImage.image = self.getImageForCell((forecastForRow?.forecastType)!)
        cell.forecastLabel.text = forecastForRow?.forecastDay
        return cell
    }

    func getImageForCell(_ weatherString: String) -> UIImage {
        switch weatherString {
        case "rainy":
            return UIImage(named: "Rainy")!
        case "cloudy":
            return UIImage(named: "Cloudy")!
        case "sunny":
            return UIImage(named: "Sunny")!
        default:
            return UIImage(named: "Sunny")!
        }
    }

    // MARK: Transition

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SHOW_DETAIL", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SHOW_DETAIL" {
            let detailVC = segue.destination as! DetailViewController
            let indexPathForForecast = self.tableView.indexPathForSelectedRow as IndexPath!
            let detailForecast = self.forecasts?[(indexPathForForecast?.row)!]
            let cell = self.tableView.cellForRow(at: indexPathForForecast!) as! WeatherCell
            let image = cell.forecastImage.image
            detailVC.forecastForDetail = detailForecast
            detailVC.forecastDetailImage = image
        }
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
        }
    }

    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: "\(message) Please verify your Internet connection and try again in a moment.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


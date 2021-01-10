//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,UITextFieldDelegate, onDataReady, CLLocationManagerDelegate {
    func onData(d: Welcome?)
    {
        if d != nil{
         updateWeather(degree: d!)
          }
    }
    
    func onError(er: Error)
    {
        let alert = UIAlertController(title: "error", message: "\(er.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    // built by mRQenawi

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var manger = MangerWeather()
    let locationManger = CLLocationManager()
    
    @IBAction func searchButtonAction(_ sender: UIButton){
       search()
    }
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization() // super fuckin clean
        locationManger.requestLocation()
        self.searchField.delegate = self
        self.manger.callBack = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print(textField.text!)
        return true
    }
    func search()
    {
        self.view.endEditing(true)
        manger.city = self.searchField.text ?? ""
        manger.getUrl()

    }
    private func updateWeather(degree:Welcome)
    {
        let weth = degree.weather
        let current = weth?.first
      DispatchQueue.main.async{
        self.cityLabel.text = degree.name
        self.temperatureLabel.text = String(format: "%.0f", degree.main?.feelsLike ?? 0)
        self.conditionImageView.image = UIImage(systemName:current?.getWeatherType() ?? "cloud")
        
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.manger.latLng = locations.last?.coordinate
        self.manger.getUrlLatLng()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
    }

}


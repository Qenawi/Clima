//
//  manger.swift
//  Clima
//
//  Created by Qenawi on 12/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//


import CoreLocation
struct Welcome: Decodable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct Clouds: Decodable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Decodable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Decodable {
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int?
    let main, weatherDescription, icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    func getWeatherType() -> String
    {
        let track = self.id ?? 0
        switch track {
        case  200..<232 :
            return "cloud.bolt"
        case  300..<321 :
            return "cloud.drizzle"
        case  500..<531 :
            return "cloud.rain"
        case  600..<622 :
            return "ckoud.snow"
        case  700..<781 :
            return "cloud.fog"
        case  800:
            return "sun.max"
        case  801..<804:
            return "cloud.bolt"
        default:
          return  "cloud"
        }
    }
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
}

import UIKit

protocol onDataReady {
    func onData(d:Welcome?)
    func onError(er:Error)
}
struct MangerWeather {
    
    var callBack:onDataReady? = nil
    let key = "2390678036b3c373cb5ba3b987747f4f"
    var city = "Cairo"
    var latLng:CLLocationCoordinate2D? = nil
    
    
    func getUrl() {
        let URL="https://api.openweathermap.org/data/2.5/weather?q=\(self.city)&units=metric&appid=\(key)"
        preformRequest(st: URL)
    }
    func getUrlLatLng() {
        let URL="https://api.openweathermap.org/data/2.5/weather?lat=\(self.latLng?.latitude ?? 0.0)&lon=\(self.latLng?.longitude ?? 0.0)&units=metric&appid=\(key)"
        preformRequest(st: URL)
       }
    func preformRequest(st:String) {
        let url = URL(string: st)
        let setion = URLSession(configuration: .default)
        let task = setion.dataTask(with: url! , completionHandler: handle(d:url:error:))
        task.resume()
    }
  
    
    func handle(d:Data?,url:URLResponse?,error:Error?){
        if error != nil{
            print(error!)
            return
        }
        if let safeData = d {
            
            parseJSON(weData: safeData)
            
        }
    }
    
    
   
    func parseJSON(weData:Data)  {
        print(weData)
        let decoder = JSONDecoder()
        do{
            let decodedDaat = try decoder.decode(Welcome.self, from: weData)
            callBack?.onData(d: decodedDaat)
        }catch
        {
            print(error)
        }
        
    }
}

//
//  DetailViewController.swift
//  WeathrMe
//
//  Created by Justin Doan on 9/5/17.
//  Copyright © 2017 Justin Doan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var weatherDetailView = UITextView()
    var weatherString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherDetailView.frame = view.frame
        weatherDetailView.textAlignment = .center
        view.addSubview(weatherDetailView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        getWeather()
    }
    
    func getWeather() {
        print("Getting Weather")
        let lat = currentLocation.latitude
        let lon = currentLocation.longitude
        
        let request = NSMutableURLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)")!)
        request.httpMethod = "GET"
        //let postString = "lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        //request.httpBody = postString.data(using: String.Encoding.utf8)
        //lines commented out above resulted in "invalid API Key" response
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print("Response: " + responseString!)
            } else {
                let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let dict = json as! [String:Any]
                print(dict)
                self.displayData(dict)
            }
        }
        task.resume()
    }
    
    func displayData(_ dict: [String : Any]) {
        weatherString = "WEATHER\n"
        
        if let sys = dict["sys"] as? [String : Any] {
            if let city = dict["name"] as? String, let country = sys["country"] as? String {
                weatherString += "For: \(city), \(country)\n"
            }
        }
        
        if let weather = dict["weather"] as? [[String:Any]], !weather.isEmpty {
            if let main = weather[0]["main"] as? String {
                weatherString += "\(main)\n"
            }

            if let description = weather[0]["description"] as? String {
                weatherString += "\(description)\n"
            }
        } else {
            print("NO WEATHER")
        }
        
        if let main = dict["main"] as? [String : Any] {
            if let kelvin = main["temp"] as? Double {
                let f = (kelvin * 9 / 5) - 459.67
                //weatherString += "\(f)\u{00B0}\n"
                weatherString += String(format: "%.2f\u{00B0}\n", f)
            }
            if let hum = main["humidity"] as? Int {
                weatherString += "Humidity: \(hum)%\n"
            }
        } else {
            print("NO MAIN")
        }
        
        if let clouds = dict["clouds"] as? [String : Any] {
            if let percent = clouds["all"] as? Int {
                weatherString += "Cloud coverage: \(percent)%\n"
            }
        } else {
            print("NO CLOUDS")
        }
        
        if let rain = dict["rain"] as? [String : Any] {
            if let h3 = rain["3h"] as? Int {
                weatherString += "Rainfall last 3 hours: \(h3)\n"
            }
        } else {
            print("NO RAIN")
        }
        
        if let snow = dict["snow"] as? [String : Any] {
            if let h3 = snow["3h"] as? Int {
                weatherString += "Snowfall last 3 hours: \(h3)\n"
            }
        } else {
            print("NO SNOW")
        }
        
        DispatchQueue.main.async {
            self.weatherDetailView.text = self.weatherString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

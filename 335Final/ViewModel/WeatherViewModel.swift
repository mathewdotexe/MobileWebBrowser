//
//  WeatherViewModel.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/27/22.
//

import SwiftUI

class WeatherViewModel: ObservableObject
{
    
    @Published var weatherData = WeatherData(elevation: 0, lng: 0.0, observation: "", ICAO: "", clouds: "", dewPoint: "", cloudsCode: "", datetime: "", seaLevelPressure: 0.0, countryCode: "", temperature: "", humidity: 0, stationName: "", weatherCondition: "", windDirection: 0, windSpeed: "", lat: 0.0)
    @Published var convertedTemp = ""
    @Published var weatherImage = ""
    
    func fetch(lat: Double, lon: Double, username: String)
    {
        
        let theUrl = "http://api.geonames.org/findNearByWeatherJSON?" + "&lat=" + "\(lat)" + "&lng=" + "\(lon)" + "&username=" + username
                
        guard let url = URL(string: theUrl) else
        {
            
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else
            {
                
            
                return
                
            }
            
            print("--> data: \(String(data: data, encoding: .utf8))")
            
            do
            {
                
                let answerCreateResponse = try JSONDecoder().decode(Root.self, from: data).weatherObservation
                
                DispatchQueue.main.async {
                    self?.weatherData = answerCreateResponse
                    
                    let theDouble = self?.weatherData.temperature!
                    let actualDouble = Double(theDouble!)
                    let theConversion = Int((actualDouble! * 9/5) + 32)
                    
                    self?.convertedTemp = "\(theConversion)" + "°F"
                    
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    
                    let clouds = self?.weatherData.clouds!
                    
                    if(clouds!.contains("clouds") && hour <= 18 && hour >= 7)
                    {
                        
                        self?.weatherImage = "cloud.sun"
                        
                    }
                    else if(clouds!.contains("clouds") && (hour >= 18 || hour <= 7))
                    {
                        
                        self?.weatherImage = "cloud.moon"
                        
                    }
                    else if(clouds!.contains("n/a") && hour <= 18 && hour >= 7)
                    {
                        
                        self?.weatherImage = "sun.max"
                        
                    }
                    else if(clouds!.contains("n/a") && (hour >= 18 || hour <= 7))
                    {
                        
                        self?.weatherImage = "moon"
                        
                    }
                    else if(clouds!.contains("overcast"))
                    {
                        
                        self?.weatherImage = "cloud"
                        
                    }
                    
                }
                
            }
            catch
            {
                
                print(error)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
}


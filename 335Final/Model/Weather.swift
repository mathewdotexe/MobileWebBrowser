//
//  Weather.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/27/22.
//

import SwiftUI

struct WeatherData : Hashable, Codable
{
    
    let elevation: Int?
    let lng: Double?
    let observation: String?
    let ICAO: String?
    let clouds: String?
    let dewPoint: String?
    let cloudsCode: String?
    let datetime: String?
    let seaLevelPressure: Double?
    let countryCode: String?
    let temperature: String?
    let humidity: Int?
    let stationName: String?
    let weatherCondition: String?
    let windDirection: Int?
    let windSpeed: String?
    let lat: Double?
    
}

struct Root: Decodable
{
    
    let weatherObservation: WeatherData
    
}

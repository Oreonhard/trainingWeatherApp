//
//  enum.swift
//  trainingWeatherApp
//
//  Created by 최준찬 on 2021/02/22.
//  Copyright © 2021 최준찬. All rights reserved.
//

import Foundation

public enum WeatherStatus {
    case Thunder
    case Drizzle
    case Rain
    case Snow
    case Atmosphere
    case Clear
    case Clouds
}

func WeatherStatusGet(weatherID:Int) -> WeatherStatus {
    switch weatherID {
    case 200...232:
        return .Thunder
    case 300...321:
        return .Drizzle
    case 500...531:
        return .Rain
    case 600...622:
        return .Snow
    case 701...781:
        return .Atmosphere
    case 800:
        return .Clear
    case 801...804:
        return .Clouds
    default:
        return .Clear
    }
}

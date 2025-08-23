//
//  LocationDistance.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import Foundation
import Domain
import CoreLocation

extension LocationEntity {
    func distance(to otherLocation: LocationEntity) -> CLLocationDistance {
        let myLocation = CLLocation(latitude: Double(self.latitude), longitude: Double(self.longitude))
        let otherLocationCoordinate = CLLocation(latitude: Double(otherLocation.latitude), longitude: Double(otherLocation.longitude))
        
        return myLocation.distance(from: otherLocationCoordinate)
    }
    
    func formattedDistance(to otherLocation: LocationEntity) -> String {
        let distanceInMeters = distance(to: otherLocation)
        
        if distanceInMeters < 1000 {
            return "\(Int(distanceInMeters))m"
        } else {
            let distanceInKm = distanceInMeters / 1000
            if distanceInKm < 10 {
                return String(format: "%.1fkm", distanceInKm)
            } else {
                return "\(Int(distanceInKm))km"
            }
        }
    }
}
//
//  DateFormatter+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/15/25.
//

import Foundation

let dateFormatter: ISO8601DateFormatter =  {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return dateFormatter
}()

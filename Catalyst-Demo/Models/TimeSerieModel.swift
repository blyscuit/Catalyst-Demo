//
//  TimeSerieModel.swift
//  Catalyst-Demo
//
//  Created by Bliss on 12/2/21.
//

import Foundation

struct TimeSerieModel: Decodable {

    let confirmed: Int
    let deaths: Int
    let recovered: Int
    let date: String
}

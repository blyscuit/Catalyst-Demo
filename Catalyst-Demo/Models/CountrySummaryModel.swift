//
//  CountrySummaryModel.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//

import Foundation

struct SummaryModel: Decodable {

    let global: GlobalSummaryModel
    let countries: [CountrySummaryModel]
    let date: String
}

struct CountrySummaryModel: Decodable {

    let country: String
    let newConfirmed, totalConfirmed: Int
    let date: String
}

struct GlobalSummaryModel: Decodable {

    let newConfirmed, totalConfirmed: Int
}

//  swiftlint:disable:this file_name
//  BaseModels.swift
//  DeeMoney
//
//  Created by Nutan Niraula on 17/12/20.
//  Copyright © 2020 Nimble. All rights reserved.
//

struct DataWrappedResponse<Response: Decodable>: Decodable {
    let data: Response
}

struct DataMetaWrappedResponse<Response: Decodable, Meta: Decodable>: Decodable {
    let data: Response
    let meta: Meta
}

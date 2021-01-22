//
//  DecoderFactory.swift
//  DeeMoney
//
//  Created by Nutan Niraula on 17/12/20.
//  Copyright © 2020 Nimble. All rights reserved.
//

import Foundation

struct AnyCodingKey : CodingKey {

    var stringValue: String
    var intValue: Int?

    init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}

extension JSONDecoder.KeyDecodingStrategy {

    static var convertFromUpperCamelCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in

            var key = AnyCodingKey(codingKeys.last!)

            // lowercase first letter
            if let firstChar = key.stringValue.first {
                let i = key.stringValue.startIndex
                key.stringValue.replaceSubrange(
                    i ... i, with: String(firstChar).lowercased()
                )
            }
            return key
        }
    }
}

enum DecoderFactory {

    static func defaultJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromUpperCamelCase
        return decoder
    }
}

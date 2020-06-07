//
//  URLQueryParameter.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 7/6/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

typealias URLQueryParameter = (key: String, value: String)

extension Array where Element == URLQueryParameter {
    func makeQueryString() -> String {
        return
            map {
                let encodedValue = $1.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved) ?? ""
                return "\($0)=\(encodedValue)"
            }.joined(separator: "&")
    }
}

extension CharacterSet {
    /// https://stackoverflow.com/a/41568692/4366470F
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}

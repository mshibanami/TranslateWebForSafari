// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

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

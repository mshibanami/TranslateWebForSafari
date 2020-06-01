// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import XCTest
@testable import TranslateWebForSafari

class TranslateWebForSafariTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBaiduTranslationURL() throws {
        let sourceLanguage = Language(id: "en", localizedName: L10n.english)
        let targetLanguage = Language(id: "jp", localizedName: L10n.japanese)
        let media = TranslationMedia.text("hello", sourceLanguage)
        let url = media.makeURL(for: .baidu, targetLanguage: targetLanguage)!
        XCTAssertEqual(url.absoluteString, "https://fanyi.baidu.com/#en/jp/hello")
    }
    
    func testPageTranslationURLIncludingMultiWidthCharacters() throws {
        let sourceLanguage = Language(id: "en", localizedName: L10n.english)
        let media = TranslationMedia.page(
            URL(string: "https://ja.wikipedia.org/wiki/%E3%82%AD%E3%82%A2%E3%83%8C%E3%83%BB%E3%83%AA%E3%83%BC%E3%83%96%E3%82%B9")!,
            sourceLanguage)
        
        let googleURL = media.makeURL(
            for: .google,
            targetLanguage: Language(id: "en", localizedName: L10n.english))!
        XCTAssertEqual(googleURL.absoluteString, "https://translate.google.com/translate?tl=en&sl=en&u=https%3A%2F%2Fja.wikipedia.org%2Fwiki%2F%E3%82%AD%E3%82%A2%E3%83%8C%E3%83%BB%E3%83%AA%E3%83%BC%E3%83%96%E3%82%B9")
        
        let bingURL = media.makeURL(
            for: .bing,
            targetLanguage: Language(id: "en", localizedName: L10n.english))!
        print("""
            \(bingURL.absoluteString)
            https://www.translatetheweb.com/?to=en&a=https%3A%2F%2Fja.wikipedia.org%2Fwiki%2F%25E3%2582%25AD%25E3%2582%25A2%25E3%2583%258C%25E3%2583%25BB%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%2596%25E3%2582%25B9
            """)
        XCTAssertEqual(bingURL.absoluteString, "https://www.translatetheweb.com/?to=en&from=en&a=https%3A%2F%2Fja.wikipedia.org%2Fwiki%2F%25E3%2582%25AD%25E3%2582%25A2%25E3%2583%258C%25E3%2583%25BB%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%2596%25E3%2582%25B9")
    }
    
    func testTextTranslationURLIncludingMultiWidthCharacters() throws {
        let sourceLanguage = Language(id: "en", localizedName: L10n.english)
        let targetLanguage = Language(id: "ja", localizedName: L10n.japanese)
        let media = TranslationMedia.text("abc あいうえお def", sourceLanguage)
        let url = media.makeURL(for: .google, targetLanguage: targetLanguage)!
        XCTAssertEqual(url.absoluteString, "https://translate.google.com/?tl=ja&sl=en&text=abc%20%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A%20def")
    }
}

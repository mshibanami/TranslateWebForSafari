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

    func testTranslationURL() throws {
        let language = Language(id: "jp", localizedName: L10n.japanese)
        let media = TranslationMedia.text("hello")
        let url = media.makeURL(for: .baidu, langauge: language)
        XCTAssertEqual(url.absoluteString, "https://fanyi.baidu.com/#auto/jp/hello")
    }

}

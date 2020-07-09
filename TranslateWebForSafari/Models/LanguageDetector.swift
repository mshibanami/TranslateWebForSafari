// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import NaturalLanguage

@available(OSX 10.14, *)
class LanguageDetector {
    private let recognizer = NLLanguageRecognizer()
    
    func detect(text: String, for translationService: TranslationService) -> Language? {
        recognizer.reset()
        let recognizer = NLLanguageRecognizer()
        Log.info("text: \(text)")
        recognizer.processString(text)
        let detecteds = recognizer
            .languageHypotheses(withMaximum: 2)
            .sorted(by: { keyValue1, keyValue2 in
                keyValue1.value > keyValue2.value
            })
        Log.info("Possible Languages: \(detecteds)")
        guard let mostPossibleLanguage = detecteds.first else {
            return nil
        }
        let isHighProbability = (mostPossibleLanguage.value) > 0.94
        let noOtherLanguagesFound = (mostPossibleLanguage.value) > 0.75 && (detecteds[optional: 1]?.value ?? 0) < 0.5
        guard isHighProbability || noOtherLanguagesFound else {
            return nil
        }
        guard let transformed = translationService.language(fromSystemLanguageCode: mostPossibleLanguage.key.rawValue) else {
            return nil
        }
        return transformed
    }
}

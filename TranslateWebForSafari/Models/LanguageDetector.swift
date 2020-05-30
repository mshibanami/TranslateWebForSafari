//
//  LanguageDetector.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 30/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import NaturalLanguage

class LanguageDetector {
    private let recognizer = NLLanguageRecognizer()
    
    func detect(text: String, for translationService: TranslationService) -> Language? {
        recognizer.reset()
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        let detecteds = recognizer
            .languageHypotheses(withMaximum: 2)
            .sorted(by: { keyValue1, keyValue2 in
                keyValue1.value > keyValue2.value
            })
        guard let mostPossibleLanguage = detecteds.first else {
            return nil
        }
        let isHighProbability = (mostPossibleLanguage.value) > 0.94
        let noOtherLanguagesFound = (mostPossibleLanguage.value) > 0.8 && (detecteds[optional: 1]?.value ?? 0) < 0.5
        guard isHighProbability || noOtherLanguagesFound else {
            return nil
        }
        guard let transformed = translationService.language(fromSystemLanguageCode: mostPossibleLanguage.key.rawValue) else {
            return nil
        }
        return transformed
    }
}

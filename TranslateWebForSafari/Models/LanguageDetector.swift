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
        guard
            let language = recognizer.languageHypotheses(withMaximum: 1).first,
            language.value > 0.95 else {
                return nil
        }
        guard let detected = translationService.language(fromSystemLanguageCode: language.key.rawValue) else {
            return nil
        }
        return detected
    }
}

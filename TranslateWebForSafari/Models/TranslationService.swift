// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation

enum TranslationService: String, CaseIterable {
    case baidu = "baidu"
    case bing = "bing"
    case deepL = "deepL"
    case google = "google"
    
    var localizedName: String {
        switch self {
        case .baidu:
            return L10n.baidu
        case .bing:
            return L10n.bing
        case .deepL:
            return L10n.deepL
        case .google:
            return L10n.google
        }
    }
    
    var supportsPageTranslation: Bool {
        switch self {
        case .baidu, .deepL:
            return false
        case .bing, .google:
            return true
        }
    }
    
    func supportedLanguages() -> [Language] {
        switch self {
        case .google:
            return supportedLanguagesInGoogle()
        case .bing:
            return supportedLanguagesInBing()
        case .deepL:
            return supportedLanguagesInDeepL()
        case .baidu:
            return supportedLanguagesInBaidu()
        }
    }
    
    func defaultLanguage() -> Language {
        let defaultLanguage = Bundle.main.defaultLanguageForTranslation
        let languages = supportedLanguages()
        return languages
            .first(where: { $0.id == defaultLanguage })
            ?? languages.first(where: { $0.id == "en" })!
    }
    
    func language(fromSystemLanguageCode systemLanguageCode: String) -> Language? {
        let serviceCode: String
        if let code = systemLanguageCodesTable().first(where: { $0.systemCode == systemLanguageCode }) {
            serviceCode = code.serviceCode
        } else {
            serviceCode = systemLanguageCode
        }
        return supportedLanguages().first(where: { $0.id == serviceCode })
    }
    
}

private extension Bundle {
    var defaultLanguageForTranslation: String {
        return Bundle.main.preferredLocalizations.first ?? "en"
    }
}

private extension TranslationService {
    func supportedLanguagesInGoogle() -> [Language] {
        return [
            Language(id: "af", localizedName: L10n.afrikaans),
            Language(id: "am", localizedName: L10n.amharic),
            Language(id: "ar", localizedName: L10n.arabic),
            Language(id: "az", localizedName: L10n.azerbaijani),
            Language(id: "be", localizedName: L10n.belarusian),
            Language(id: "bg", localizedName: L10n.bulgarian),
            Language(id: "bn", localizedName: L10n.bengali),
            Language(id: "bs", localizedName: L10n.bosnian),
            Language(id: "ca", localizedName: L10n.catalan),
            Language(id: "ceb", localizedName: L10n.cebuano),
            Language(id: "co", localizedName: L10n.corsican),
            Language(id: "cs", localizedName: L10n.czech),
            Language(id: "cy", localizedName: L10n.welsh),
            Language(id: "da", localizedName: L10n.danish),
            Language(id: "de", localizedName: L10n.german),
            Language(id: "el", localizedName: L10n.greek),
            Language(id: "en", localizedName: L10n.english),
            Language(id: "eo", localizedName: L10n.esperanto),
            Language(id: "es", localizedName: L10n.spanish),
            Language(id: "et", localizedName: L10n.estonian),
            Language(id: "eu", localizedName: L10n.basque),
            Language(id: "fa", localizedName: L10n.persian),
            Language(id: "fi", localizedName: L10n.finnish),
            Language(id: "fr", localizedName: L10n.french),
            Language(id: "fy", localizedName: L10n.frisian),
            Language(id: "ga", localizedName: L10n.irish),
            Language(id: "gd", localizedName: L10n.scotsGaelic),
            Language(id: "gl", localizedName: L10n.galician),
            Language(id: "gu", localizedName: L10n.gujarati),
            Language(id: "ha", localizedName: L10n.hausa),
            Language(id: "haw", localizedName: L10n.hawaiian),
            Language(id: "hi", localizedName: L10n.hindi),
            Language(id: "hmn", localizedName: L10n.hmong),
            Language(id: "hr", localizedName: L10n.croatian),
            Language(id: "ht", localizedName: L10n.haitianCreole),
            Language(id: "hu", localizedName: L10n.hungarian),
            Language(id: "hy", localizedName: L10n.armenian),
            Language(id: "id", localizedName: L10n.indonesian),
            Language(id: "ig", localizedName: L10n.igbo),
            Language(id: "is", localizedName: L10n.icelandic),
            Language(id: "it", localizedName: L10n.italian),
            Language(id: "iw", localizedName: L10n.hebrew),
            Language(id: "ja", localizedName: L10n.japanese),
            Language(id: "jw", localizedName: L10n.javanese),
            Language(id: "ka", localizedName: L10n.georgian),
            Language(id: "kk", localizedName: L10n.kazakh),
            Language(id: "km", localizedName: L10n.khmer),
            Language(id: "kn", localizedName: L10n.kannada),
            Language(id: "ko", localizedName: L10n.korean),
            Language(id: "ku", localizedName: L10n.kurdishKurmanji),
            Language(id: "ky", localizedName: L10n.kyrgyz),
            Language(id: "la", localizedName: L10n.latin),
            Language(id: "lb", localizedName: L10n.luxembourgish),
            Language(id: "lo", localizedName: L10n.lao),
            Language(id: "lt", localizedName: L10n.lithuanian),
            Language(id: "lv", localizedName: L10n.latvian),
            Language(id: "mg", localizedName: L10n.malagasy),
            Language(id: "mi", localizedName: L10n.maori),
            Language(id: "mk", localizedName: L10n.macedonian),
            Language(id: "ml", localizedName: L10n.malayalam),
            Language(id: "mn", localizedName: L10n.mongolian),
            Language(id: "mr", localizedName: L10n.marathi),
            Language(id: "ms", localizedName: L10n.malay),
            Language(id: "mt", localizedName: L10n.maltese),
            Language(id: "my", localizedName: L10n.myanmarBurmese),
            Language(id: "ne", localizedName: L10n.nepali),
            Language(id: "nl", localizedName: L10n.dutch),
            Language(id: "no", localizedName: L10n.norwegian),
            Language(id: "ny", localizedName: L10n.chichewa),
            Language(id: "or", localizedName: L10n.odiaOriya),
            Language(id: "pa", localizedName: L10n.punjabi),
            Language(id: "pl", localizedName: L10n.polish),
            Language(id: "ps", localizedName: L10n.pashto),
            Language(id: "pt", localizedName: L10n.portuguese),
            Language(id: "ro", localizedName: L10n.romanian),
            Language(id: "ru", localizedName: L10n.russian),
            Language(id: "rw", localizedName: L10n.kinyarwanda),
            Language(id: "sd", localizedName: L10n.sindhi),
            Language(id: "si", localizedName: L10n.sinhala),
            Language(id: "sk", localizedName: L10n.slovak),
            Language(id: "sl", localizedName: L10n.slovenian),
            Language(id: "sm", localizedName: L10n.samoan),
            Language(id: "sn", localizedName: L10n.shona),
            Language(id: "so", localizedName: L10n.somali),
            Language(id: "sq", localizedName: L10n.albanian),
            Language(id: "sr", localizedName: L10n.serbian),
            Language(id: "st", localizedName: L10n.sesotho),
            Language(id: "su", localizedName: L10n.sundanese),
            Language(id: "sv", localizedName: L10n.swedish),
            Language(id: "sw", localizedName: L10n.swahili),
            Language(id: "ta", localizedName: L10n.tamil),
            Language(id: "te", localizedName: L10n.telugu),
            Language(id: "tg", localizedName: L10n.tajik),
            Language(id: "th", localizedName: L10n.thai),
            Language(id: "tk", localizedName: L10n.turkmen),
            Language(id: "tl", localizedName: L10n.filipino),
            Language(id: "tr", localizedName: L10n.turkish),
            Language(id: "tt", localizedName: L10n.tatar),
            Language(id: "ug", localizedName: L10n.uyghur),
            Language(id: "uk", localizedName: L10n.ukrainian),
            Language(id: "ur", localizedName: L10n.urdu),
            Language(id: "uz", localizedName: L10n.uzbek),
            Language(id: "vi", localizedName: L10n.vietnamese),
            Language(id: "xh", localizedName: L10n.xhosa),
            Language(id: "yi", localizedName: L10n.yiddish),
            Language(id: "yo", localizedName: L10n.yoruba),
            Language(id: "zh-CN", localizedName: L10n.chineseSimplified),
            Language(id: "zh-TW", localizedName: L10n.chineseTraditional),
            Language(id: "zu", localizedName: L10n.zulu),
        ]
    }
    
    func supportedLanguagesInBing() -> [Language] {
        return [
            Language(id: "af", localizedName: L10n.afrikaans),
            Language(id: "ar", localizedName: L10n.arabic),
            Language(id: "bg", localizedName: L10n.bulgarian),
            Language(id: "bn-BD", localizedName: L10n.bangla),
            Language(id: "bs-Latn", localizedName: L10n.bosnianLatin),
            Language(id: "ca", localizedName: L10n.catalan),
            Language(id: "cs", localizedName: L10n.czech),
            Language(id: "cy", localizedName: L10n.welsh),
            Language(id: "da", localizedName: L10n.danish),
            Language(id: "de", localizedName: L10n.german),
            Language(id: "el", localizedName: L10n.greek),
            Language(id: "en", localizedName: L10n.english),
            Language(id: "es", localizedName: L10n.spanish),
            Language(id: "et", localizedName: L10n.estonian),
            Language(id: "fa", localizedName: L10n.persian),
            Language(id: "fi", localizedName: L10n.finnish),
            Language(id: "fil", localizedName: L10n.filipino),
            Language(id: "fj", localizedName: L10n.fijian),
            Language(id: "fr", localizedName: L10n.french),
            Language(id: "ga", localizedName: L10n.irish),
            Language(id: "gu", localizedName: L10n.gujarati),
            Language(id: "he", localizedName: L10n.hebrew),
            Language(id: "hi", localizedName: L10n.hindi),
            Language(id: "hr", localizedName: L10n.croatian),
            Language(id: "ht", localizedName: L10n.haitianCreole),
            Language(id: "hu", localizedName: L10n.hungarian),
            Language(id: "id", localizedName: L10n.indonesian),
            Language(id: "is", localizedName: L10n.icelandic),
            Language(id: "it", localizedName: L10n.italian),
            Language(id: "ja", localizedName: L10n.japanese),
            Language(id: "kn", localizedName: L10n.kannada),
            Language(id: "ko", localizedName: L10n.korean),
            Language(id: "lt", localizedName: L10n.lithuanian),
            Language(id: "lv", localizedName: L10n.latvian),
            Language(id: "mg", localizedName: L10n.malagasy),
            Language(id: "mi", localizedName: L10n.maori),
            Language(id: "ml", localizedName: L10n.malayalam),
            Language(id: "mr", localizedName: L10n.marathi),
            Language(id: "ms", localizedName: L10n.malayLatin),
            Language(id: "mt", localizedName: L10n.maltese),
            Language(id: "mww", localizedName: L10n.hmongDaw),
            Language(id: "nb", localizedName: L10n.norwegianBokmal),
            Language(id: "nl", localizedName: L10n.dutch),
            Language(id: "otq", localizedName: L10n.querétaroOtomi),
            Language(id: "pa", localizedName: L10n.punjabiGurmukhi),
            Language(id: "pl", localizedName: L10n.polish),
            Language(id: "pt", localizedName: L10n.portugueseBrazil),
            Language(id: "pt-pt", localizedName: L10n.portuguesePortugal),
            Language(id: "ro", localizedName: L10n.romanian),
            Language(id: "ru", localizedName: L10n.russian),
            Language(id: "sk", localizedName: L10n.slovak),
            Language(id: "sl", localizedName: L10n.slovenian),
            Language(id: "sm", localizedName: L10n.samoan),
            Language(id: "sr-Cyrl", localizedName: L10n.serbianCyrillic),
            Language(id: "sr-Latn", localizedName: L10n.serbianLatin),
            Language(id: "sv", localizedName: L10n.swedish),
            Language(id: "sw", localizedName: L10n.kiswahili),
            Language(id: "ta", localizedName: L10n.tamil),
            Language(id: "te", localizedName: L10n.telugu),
            Language(id: "th", localizedName: L10n.thai),
            Language(id: "tlh", localizedName: L10n.klingon),
            Language(id: "to", localizedName: L10n.tongan),
            Language(id: "tr", localizedName: L10n.turkish),
            Language(id: "ty", localizedName: L10n.tahitian),
            Language(id: "uk", localizedName: L10n.ukrainian),
            Language(id: "ur", localizedName: L10n.urdu),
            Language(id: "vi", localizedName: L10n.vietnamese),
            Language(id: "yua", localizedName: L10n.yucatecMaya),
            Language(id: "yue", localizedName: L10n.cantoneseTraditional),
            Language(id: "zh-Hans", localizedName: L10n.chineseSimplified),
            Language(id: "zh-Hant", localizedName: L10n.chineseTraditional),
        ]
    }
    
    func supportedLanguagesInDeepL() -> [Language] {
        return [
            Language(id: "de", localizedName: L10n.german),
            Language(id: "en", localizedName: L10n.english),
            Language(id: "es", localizedName: L10n.spanish),
            Language(id: "fr", localizedName: L10n.french),
            Language(id: "it", localizedName: L10n.italian),
            Language(id: "ja", localizedName: L10n.japanese),
            Language(id: "nl", localizedName: L10n.dutch),
            Language(id: "pl", localizedName: L10n.polish),
            Language(id: "pt", localizedName: L10n.portuguese),
            Language(id: "ru", localizedName: L10n.russian),
            Language(id: "zh", localizedName: L10n.chineseSimplified),
        ]
    }
    
    func supportedLanguagesInBaidu() -> [Language] {
        return [
            Language(id: "ach", localizedName: L10n.achinese),
            Language(id: "afr", localizedName: L10n.afrikaans),
            Language(id: "aka", localizedName: L10n.akan),
            Language(id: "alb", localizedName: L10n.albanian),
            Language(id: "amh", localizedName: L10n.amharic),
            Language(id: "ara", localizedName: L10n.arabic),
            Language(id: "arg", localizedName: L10n.aragonese),
            Language(id: "arm", localizedName: L10n.armenian),
            Language(id: "arq", localizedName: L10n.algerianArabic),
            Language(id: "asm", localizedName: L10n.assamese),
            Language(id: "ast", localizedName: L10n.asturian),
            Language(id: "aym", localizedName: L10n.aymara),
            Language(id: "aze", localizedName: L10n.azerbaijani),
            Language(id: "bak", localizedName: L10n.bashkir),
            Language(id: "bal", localizedName: L10n.baluchi),
            Language(id: "baq", localizedName: L10n.basque),
            Language(id: "bel", localizedName: L10n.belarusian),
            Language(id: "bem", localizedName: L10n.bemba),
            Language(id: "ben", localizedName: L10n.bengali),
            Language(id: "ber", localizedName: L10n.berberLanguages),
            Language(id: "bho", localizedName: L10n.bhojpuri),
            Language(id: "bis", localizedName: L10n.bislama),
            Language(id: "bli", localizedName: L10n.blin),
            Language(id: "bos", localizedName: L10n.bosnian),
            Language(id: "bre", localizedName: L10n.breton),
            Language(id: "bul", localizedName: L10n.bulgarian),
            Language(id: "bur", localizedName: L10n.burmese),
            Language(id: "cat", localizedName: L10n.catalan),
            Language(id: "ceb", localizedName: L10n.cebuano),
            Language(id: "chr", localizedName: L10n.cherokee),
            Language(id: "cht", localizedName: L10n.chineseTraditional),
            Language(id: "chv", localizedName: L10n.chuvash),
            Language(id: "cor", localizedName: L10n.cornish),
            Language(id: "cos", localizedName: L10n.corsican),
            Language(id: "cre", localizedName: L10n.creek),
            Language(id: "cri", localizedName: L10n.crimeanTatar),
            Language(id: "cs", localizedName: L10n.czech),
            Language(id: "dan", localizedName: L10n.danish),
            Language(id: "de", localizedName: L10n.german),
            Language(id: "div", localizedName: L10n.divehi),
            Language(id: "el", localizedName: L10n.greek),
            Language(id: "en", localizedName: L10n.english),
            Language(id: "eno", localizedName: L10n.oldEnglish),
            Language(id: "epo", localizedName: L10n.esperanto),
            Language(id: "est", localizedName: L10n.estonian),
            Language(id: "fao", localizedName: L10n.faroese),
            Language(id: "fil", localizedName: L10n.filipino),
            Language(id: "fin", localizedName: L10n.finnish),
            Language(id: "fra", localizedName: L10n.french),
            Language(id: "fri", localizedName: L10n.friulian),
            Language(id: "frm", localizedName: L10n.middleFrench),
            Language(id: "frn", localizedName: L10n.canadianFrench),
            Language(id: "fry", localizedName: L10n.westernFrisian),
            Language(id: "ful", localizedName: L10n.fulani),
            Language(id: "geo", localizedName: L10n.georgian),
            Language(id: "gla", localizedName: L10n.gaelic),
            Language(id: "gle", localizedName: L10n.irish),
            Language(id: "glg", localizedName: L10n.galician),
            Language(id: "glv", localizedName: L10n.manx),
            Language(id: "gra", localizedName: L10n.ancientGreek),
            Language(id: "grn", localizedName: L10n.guarani),
            Language(id: "guj", localizedName: L10n.gujarati),
            Language(id: "hak", localizedName: L10n.hakhaChin),
            Language(id: "hau", localizedName: L10n.hausa),
            Language(id: "haw", localizedName: L10n.hawaiian),
            Language(id: "heb", localizedName: L10n.hebrew),
            Language(id: "hi", localizedName: L10n.hindi),
            Language(id: "hil", localizedName: L10n.hiligaynon),
            Language(id: "hkm", localizedName: L10n.khmer),
            Language(id: "hrv", localizedName: L10n.croatian),
            Language(id: "ht", localizedName: L10n.haitianCreole),
            Language(id: "hu", localizedName: L10n.hungarian),
            Language(id: "hup", localizedName: L10n.hupa),
            Language(id: "ibo", localizedName: L10n.igbo),
            Language(id: "ice", localizedName: L10n.icelandic),
            Language(id: "id", localizedName: L10n.indonesian),
            Language(id: "ido", localizedName: L10n.ido),
            Language(id: "iku", localizedName: L10n.inuktitut),
            Language(id: "ina", localizedName: L10n.interlingua),
            Language(id: "ing", localizedName: L10n.ingush),
            Language(id: "it", localizedName: L10n.italian),
            Language(id: "jav", localizedName: L10n.javanese),
            Language(id: "jp", localizedName: L10n.japanese),
            Language(id: "kab", localizedName: L10n.kabyle),
            Language(id: "kah", localizedName: L10n.kashubian),
            Language(id: "kal", localizedName: L10n.kalaallisut),
            Language(id: "kan", localizedName: L10n.kannada),
            Language(id: "kas", localizedName: L10n.kashmiri),
            Language(id: "kau", localizedName: L10n.kanuri),
            Language(id: "kaz", localizedName: L10n.kazakh),
            Language(id: "kin", localizedName: L10n.kinyarwanda),
            Language(id: "kir", localizedName: L10n.kyrgyz),
            Language(id: "kli", localizedName: L10n.klingon),
            Language(id: "kok", localizedName: L10n.konkani),
            Language(id: "kon", localizedName: L10n.kongo),
            Language(id: "kor", localizedName: L10n.korean),
            Language(id: "kur", localizedName: L10n.kurdish),
            Language(id: "lag", localizedName: L10n.latgalian),
            Language(id: "lao", localizedName: L10n.lao),
            Language(id: "lat", localizedName: L10n.latin),
            Language(id: "lav", localizedName: L10n.latvian),
            Language(id: "lim", localizedName: L10n.limburgish),
            Language(id: "lin", localizedName: L10n.lingala),
            Language(id: "lit", localizedName: L10n.lithuanian),
            Language(id: "log", localizedName: L10n.lowGerman),
            Language(id: "loj", localizedName: L10n.lojban),
            Language(id: "los", localizedName: L10n.lowerSorbian),
            Language(id: "ltz", localizedName: L10n.luxembourgish),
            Language(id: "lug", localizedName: L10n.luganda),
            Language(id: "mac", localizedName: L10n.macedonian),
            Language(id: "mah", localizedName: L10n.marshallese),
            Language(id: "mai", localizedName: L10n.maithili),
            Language(id: "mal", localizedName: L10n.malayalam),
            Language(id: "mao", localizedName: L10n.maori),
            Language(id: "mar", localizedName: L10n.marathi),
            Language(id: "mau", localizedName: L10n.mauritianCreole),
            Language(id: "may", localizedName: L10n.malay),
            Language(id: "mg", localizedName: L10n.malagasy),
            Language(id: "mlt", localizedName: L10n.maltese),
            Language(id: "mot", localizedName: L10n.montenegrin),
            Language(id: "nbl", localizedName: L10n.southernNdebele),
            Language(id: "nea", localizedName: L10n.neapolitan),
            Language(id: "nep", localizedName: L10n.nepali),
            Language(id: "nl", localizedName: L10n.dutch),
            Language(id: "nno", localizedName: L10n.nynorsk),
            Language(id: "nob", localizedName: L10n.bokmål),
            Language(id: "nor", localizedName: L10n.norwegian),
            Language(id: "nqo", localizedName: L10n.nKo),
            Language(id: "nya", localizedName: L10n.chichewa),
            Language(id: "oci", localizedName: L10n.occitan),
            Language(id: "oji", localizedName: L10n.ojibwa),
            Language(id: "ori", localizedName: L10n.oriya),
            Language(id: "orm", localizedName: L10n.oromo),
            Language(id: "oss", localizedName: L10n.ossetian),
            Language(id: "pam", localizedName: L10n.pampanga),
            Language(id: "pan", localizedName: L10n.punjabi),
            Language(id: "pap", localizedName: L10n.papiamento),
            Language(id: "ped", localizedName: L10n.northernSotho),
            Language(id: "per", localizedName: L10n.persian),
            Language(id: "pl", localizedName: L10n.polish),
            Language(id: "pot", localizedName: L10n.brazilianPortuguese),
            Language(id: "pt", localizedName: L10n.portuguese),
            Language(id: "pus", localizedName: L10n.pashto),
            Language(id: "que", localizedName: L10n.quechua),
            Language(id: "ro", localizedName: L10n.romany),
            Language(id: "roh", localizedName: L10n.romansh),
            Language(id: "rom", localizedName: L10n.romanian),
            Language(id: "ru", localizedName: L10n.russian),
            Language(id: "ruy", localizedName: L10n.rusyn),
            Language(id: "san", localizedName: L10n.sanskrit),
            Language(id: "sco", localizedName: L10n.scots),
            Language(id: "sec", localizedName: L10n.serboCroatian),
            Language(id: "sha", localizedName: L10n.shan),
            Language(id: "sil", localizedName: L10n.silesian),
            Language(id: "sin", localizedName: L10n.sinhala),
            Language(id: "sk", localizedName: L10n.slovak),
            Language(id: "slo", localizedName: L10n.slovenian),
            Language(id: "sm", localizedName: L10n.samoan),
            Language(id: "sme", localizedName: L10n.northernSami),
            Language(id: "sna", localizedName: L10n.shona),
            Language(id: "snd", localizedName: L10n.sindhi),
            Language(id: "sol", localizedName: L10n.songhaiLanguages),
            Language(id: "som", localizedName: L10n.somali),
            Language(id: "sot", localizedName: L10n.southernSotho),
            Language(id: "spa", localizedName: L10n.spanish),
            Language(id: "srd", localizedName: L10n.sardinian),
            Language(id: "srp", localizedName: L10n.serbian),
            Language(id: "swa", localizedName: L10n.swahili),
            Language(id: "swe", localizedName: L10n.swedish),
            Language(id: "syr", localizedName: L10n.syriac),
            Language(id: "tam", localizedName: L10n.tamil),
            Language(id: "tat", localizedName: L10n.tatar),
            Language(id: "tel", localizedName: L10n.telugu),
            Language(id: "tet", localizedName: L10n.tetum),
            Language(id: "tgk", localizedName: L10n.tajik),
            Language(id: "tgl", localizedName: L10n.tagalog),
            Language(id: "th", localizedName: L10n.thai),
            Language(id: "tir", localizedName: L10n.tigrinya),
            Language(id: "tr", localizedName: L10n.turkish),
            Language(id: "tso", localizedName: L10n.tsonga),
            Language(id: "tua", localizedName: L10n.tunisianArabic),
            Language(id: "tuk", localizedName: L10n.turkmen),
            Language(id: "twi", localizedName: L10n.twi),
            Language(id: "ukr", localizedName: L10n.ukrainian),
            Language(id: "ups", localizedName: L10n.upperSorbian),
            Language(id: "urd", localizedName: L10n.urdu),
            Language(id: "uzb", localizedName: L10n.uzbek),
            Language(id: "ven", localizedName: L10n.venda),
            Language(id: "vie", localizedName: L10n.vietnamese),
            Language(id: "wel", localizedName: L10n.welsh),
            Language(id: "wln", localizedName: L10n.walloon),
            Language(id: "wol", localizedName: L10n.wolof),
            Language(id: "wyw", localizedName: L10n.classicalChinese),
            Language(id: "xho", localizedName: L10n.xhosa),
            Language(id: "yid", localizedName: L10n.yiddish),
            Language(id: "yor", localizedName: L10n.yoruba),
            Language(id: "yue", localizedName: L10n.cantonese),
            Language(id: "zaz", localizedName: L10n.zaza),
            Language(id: "zh", localizedName: L10n.chinese),
            Language(id: "zul", localizedName: L10n.zulu),
        ]
    }
    
    func systemLanguageCodesTable() -> [(systemCode: String, serviceCode: String)] {
        switch self {
        case .baidu:
            return [
                ("ar", "ar"),
                ("ca", "cat"),
                ("cy", "wel"),
                ("da", "dan"),
                ("es", "spa"),
                ("et", "est"),
                ("fa", "per"),
                ("fr", "fra"),
                ("ga", "gle"),
                ("he", "heb"),
                ("ja", "jp"),
                ("jw", "jav"),
                ("ko", "kor"),
                ("mk", "mac"),
                ("ms", "may"),
                ("ne", "nep"),
                ("ro", "rom"),
                ("sv", "swe"),
                ("sr", "srp"),
                ("ta", "tam"),
                ("vi", "vie"),
                ("zh-Hans", "zh"),
                ("zh-Hant", "cht")
            ]
        case .bing:
            return []
        case .deepL:
            return [
                ("zh-Hans", "zh"),
                ("zh-Hant", "zh"),
            ]
        case .google:
            return [
                ("he", "iw"),
                ("zh-Hans", "zh-CN"),
                ("zh-Hant", "zh-TW"),
            ]
        }
    }
}

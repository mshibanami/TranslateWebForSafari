//
//  L10n.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 14/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

class L10n {
    // MARK: General
    
    static let appName = "Translate Web for Safari"
    static func appVersion(version: String, buildVersion: String) -> String {
         return String(
            format: NSLocalizedString("Version %@ (%@)", comment: ""),
            version,
            buildVersion)
    }
    
    // MARK: Extension
    
    static let toolbarItemTranslatePage = NSLocalizedString("Translate the current page", comment: "")
    static let contextMenuTranslatePage = NSLocalizedString("Translate this page", comment: "")
    static func menuTranslateText(with text: String) -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString("Translate \"%@\"", comment: ""),
            text)
    }
    
    // MARK: Settings
    
    static let menuItemHideApp = String(format: NSLocalizedString("Hide %@", comment: ""), appName)
    static let menuItemHideOthers = NSLocalizedString("Hide Others", comment: "")
    static let menuItemShowAll = NSLocalizedString("Show All", comment: "")
    static let menuItemQuitApp = String(format: NSLocalizedString("Quit %@", comment: ""), appName)
    static let menuItemWindow = NSLocalizedString("Window", comment: "")
    static let menuItemClose = NSLocalizedString("Close", comment: "")
    static let pageTranslation = NSLocalizedString("Page Translation", comment: "")
    static let textTranslation = NSLocalizedString("Text Translation", comment: "")
    static let translateTo = NSLocalizedString("Translate to", comment: "")
    static let toolbarItemBehavior = NSLocalizedString("Toolbar button behavior", comment: "")
    static let alwaysTranslatePage = NSLocalizedString("Always translate the current page", comment: "")
    static let alwaysTranslateSelectedText = NSLocalizedString("Always translate the selected text", comment: "")
    static let translateTextIfSelected = NSLocalizedString("If text is selected, translate it, otherwise translate the current page", comment: "")
    static let openSafariPreferences = NSLocalizedString("Open Safari Preferences…", comment: "")
    static let aboutThisExtension = NSLocalizedString("About this extension", comment: "")
    static let recommended = NSLocalizedString("(recommended)", comment: "")
    static func textAndRecommended(text: String) -> String {
        return String(
            format: NSLocalizedString("%@ %@", comment: "<Text for settings etc.> <(recommended)>"),
            text,
            recommended)
    }
    
    // MARK: Translation Service
    
    static let baidu = "Baidu"
    static let bing = "Bing"
    static let deepL = "DeepL"
    static let google = "Google"
    
    // MARK: Languages the translation services support
    
    static let achinese = "Achinese"
    static let afrikaans = "Afrikaans"
    static let akan = "Akan"
    static let albanian = "Albanian"
    static let algerianArabic = "Algerian Arabic"
    static let amharic = "Amharic"
    static let ancientGreek = "Ancient Greek"
    static let arabic = NSLocalizedString("Arabic", comment: "")
    static let aragonese = "Aragonese"
    static let armenian = "Armenian"
    static let assamese = "Assamese"
    static let asturian = "Asturian"
    static let aymara = "Aymara"
    static let azerbaijani = "Azerbaijani"
    static let baluchi = "Baluchi"
    static let bangla = "Bangla"
    static let bashkir = "Bashkir"
    static let basque = "Basque"
    static let belarusian = "Belarusian"
    static let bemba = "Bemba"
    static let bengali = "Bengali"
    static let berberLanguages = "Berber languages"
    static let bhojpuri = "Bhojpuri"
    static let bislama = "Bislama"
    static let blin = "Blin"
    static let bokmål = "Bokmål"
    static let bosnian = "Bosnian"
    static let bosnianLatin = "Bosnian (Latin)"
    static let brazilianPortuguese = "Brazilian Portuguese"
    static let breton = "Breton"
    static let bulgarian = "Bulgarian"
    static let burmese = "Burmese"
    static let canadianFrench = "Canadian French"
    static let cantonese = NSLocalizedString("Cantonese", comment: "")
    static let cantoneseTraditional = "Cantonese (Traditional)"
    static let catalan = "Catalan"
    static let cebuano = "Cebuano"
    static let cherokee = "Cherokee"
    static let chichewa = "Chichewa"
    static let chinese = NSLocalizedString("Chinese", comment: "")
    static let chineseSimplified = NSLocalizedString("Chinese (Simplified)", comment: "")
    static let chineseTraditional = NSLocalizedString("Chinese (Traditional)", comment: "")
    static let chuvash = "Chuvash"
    static let classicalChinese = "Classical Chinese"
    static let cornish = "Cornish"
    static let corsican = "Corsican"
    static let creek = "Creek"
    static let crimeanTatar = "Crimean Tatar"
    static let croatian = "Croatian"
    static let czech = "Czech"
    static let danish = NSLocalizedString("Danish", comment: "")
    static let divehi = "Divehi"
    static let dutch = NSLocalizedString("Dutch", comment: "")
    static let english = NSLocalizedString("English", comment: "")
    static let esperanto = "Esperanto"
    static let estonian = NSLocalizedString("Estonian", comment: "")
    static let faroese = "Faroese"
    static let fijian = "Fijian"
    static let filipino = "Filipino"
    static let finnish = NSLocalizedString("Finnish", comment: "")
    static let french = NSLocalizedString("French", comment: "")
    static let frisian = "Frisian"
    static let friulian = "Friulian"
    static let fulani = "Fulani"
    static let gaelic = "Gaelic"
    static let galician = "Galician"
    static let georgian = "Georgian"
    static let german = NSLocalizedString("German", comment: "")
    static let greek = NSLocalizedString("Greek", comment: "")
    static let guarani = "Guarani"
    static let gujarati = "Gujarati"
    static let haitianCreole = "Haitian Creole"
    static let hakhaChin = "Hakha Chin"
    static let hausa = "Hausa"
    static let hawaiian = "Hawaiian"
    static let hebrew = NSLocalizedString("Hebrew", comment: "")
    static let hiligaynon = "Hiligaynon"
    static let hindi = NSLocalizedString("Hindi", comment: "")
    static let hmong = "Hmong"
    static let hmongDaw = "Hmong Daw"
    static let hungarian = "Hungarian"
    static let hupa = "Hupa"
    static let icelandic = "Icelandic"
    static let ido = "Ido"
    static let igbo = "Igbo"
    static let indonesian = NSLocalizedString("Indonesian", comment: "")
    static let ingush = "Ingush"
    static let interlingua = "Interlingua "
    static let inuktitut = "Inuktitut"
    static let irish = NSLocalizedString("Irish", comment: "")
    static let italian = NSLocalizedString("Italian", comment: "")
    static let japanese = NSLocalizedString("Japanese", comment: "")
    static let javanese = NSLocalizedString("Javanese", comment: "")
    static let kabyle = "Kabyle"
    static let kalaallisut = "Kalaallisut"
    static let kannada = "Kannada"
    static let kanuri = "Kanuri"
    static let kashmiri = "Kashmiri"
    static let kashubian = "Kashubian"
    static let kazakh = "Kazakh"
    static let khmer = "Khmer"
    static let kinyarwanda = "Kinyarwanda"
    static let kiswahili = "Kiswahili"
    static let klingon = "Klingon"
    static let kongo = "Kongo"
    static let konkani = "Konkani"
    static let korean = NSLocalizedString("Korean", comment: "")
    static let kurdish = "Kurdish"
    static let kurdishKurmanji = "Kurdish (Kurmanji)"
    static let kyrgyz = "Kyrgyz"
    static let lao = "Lao"
    static let latgalian = "Latgalian"
    static let latin = NSLocalizedString("Latin", comment: "")
    static let latvian = "Latvian"
    static let limburgish = "Limburgish"
    static let lingala = "Lingala"
    static let lithuanian = "Lithuanian"
    static let lojban = "Lojban"
    static let lowerSorbian = "Lower Sorbian"
    static let lowGerman = "Low German"
    static let luganda = "Luganda"
    static let luxembourgish = "Luxembourgish"
    static let macedonian = "Macedonian"
    static let maithili = "Maithili"
    static let malagasy = "Malagasy"
    static let malay = NSLocalizedString("Malay", comment: "")
    static let malayalam = "Malayalam"
    static let malayLatin = "Malay (Latin)"
    static let maltese = "Maltese"
    static let manx = "Manx"
    static let maori = "Maori"
    static let marathi = "Marathi"
    static let marshallese = "Marshallese"
    static let mauritianCreole = "Mauritian Creole"
    static let middleFrench = "Middle French"
    static let mongolian = NSLocalizedString("Mongolian", comment: "")
    static let montenegrin = "Montenegrin"
    static let myanmarBurmese = "Myanmar (Burmese)"
    static let neapolitan = "Neapolitan"
    static let nepali = "Nepali"
    static let nKo = "N'Ko"
    static let northernSami = "Northern Sami"
    static let northernSotho = "Northern Sotho"
    static let norwegian = NSLocalizedString("Norwegian", comment: "")
    static let norwegianBokmål = "Norwegian Bokmål"
    static let nynorsk = "Nynorsk"
    static let occitan = "Occitan"
    static let odiaOriya = "Odia (Oriya)"
    static let ojibwa = "Ojibwa"
    static let oldEnglish = NSLocalizedString("Old English", comment: "")
    static let oriya = "Oriya"
    static let oromo = "Oromo"
    static let ossetian = "Ossetian"
    static let pampanga = "Pampanga"
    static let papiamento = "Papiamento"
    static let pashto = "Pashto"
    static let persian = NSLocalizedString("Persian", comment: "")
    static let polish = NSLocalizedString("Polish", comment: "")
    static let portuguese = NSLocalizedString("Portuguese", comment: "")
    static let portugueseBrazil = NSLocalizedString("Portuguese (Brazil)", comment: "")
    static let portuguesePortugal = NSLocalizedString("Portuguese (Portugal)", comment: "")
    static let punjabi = "Punjabi"
    static let punjabiGurmukhi = "Punjabi (Gurmukhi)"
    static let quechua = "Quechua"
    static let querétaroOtomi = "Querétaro Otomi"
    static let romanian = "Romanian"
    static let romansh = "Romansh"
    static let romany = "Romany"
    static let russian = NSLocalizedString("Russian", comment: "")
    static let rusyn = "Rusyn"
    static let samoan = "Samoan"
    static let sanskrit = NSLocalizedString("Sanskrit", comment: "")
    static let sardinian = "Sardinian"
    static let scots = "Scots"
    static let scotsGaelic = "Scots Gaelic"
    static let serbian = NSLocalizedString("Serbian", comment: "")
    static let serbianCyrillic = NSLocalizedString("Serbian (Cyrillic)", comment: "")
    static let serbianLatin = NSLocalizedString("Serbian (Latin)", comment: "")
    static let serboCroatian = "Serbo-Croatian"
    static let sesotho = "Sesotho"
    static let shan = "Shan"
    static let shona = "Shona"
    static let silesian = "Silesian"
    static let sindhi = "Sindhi"
    static let sinhala = "Sinhala"
    static let slovak = "Slovak"
    static let slovenian = "Slovenian"
    static let somali = "Somali"
    static let songhaiLanguages = "Songhai languages"
    static let southernNdebele = "Southern Ndebele"
    static let southernSotho = "Southern Sotho"
    static let spanish = NSLocalizedString("Spanish", comment: "")
    static let sundanese = "Sundanese"
    static let swahili = NSLocalizedString("Swahili", comment: "")
    static let swedish = NSLocalizedString("Swedish", comment: "")
    static let syriac = "Syriac"
    static let tagalog = "Tagalog"
    static let tahitian = "Tahitian"
    static let tajik = "Tajik"
    static let tamil = NSLocalizedString("Tamil", comment: "")
    static let tatar = "Tatar"
    static let telugu = "Telugu"
    static let tetum = "Tetum"
    static let thai = NSLocalizedString("Thai", comment: "")
    static let tigrinya = "Tigrinya"
    static let tongan = "Tongan"
    static let tsonga = "Tsonga"
    static let tunisianArabic = "Tunisian Arabic"
    static let turkish = NSLocalizedString("Turkish", comment: "")
    static let turkmen = "Turkmen"
    static let twi = "Twi"
    static let ukrainian = "Ukrainian"
    static let upperSorbian = "Upper Sorbian"
    static let urdu = "Urdu"
    static let uyghur = NSLocalizedString("Uyghur", comment: "")
    static let uzbek = "Uzbek"
    static let venda = "Venda"
    static let vietnamese = "Vietnamese"
    static let walloon = "Walloon"
    static let welsh = NSLocalizedString("Welsh", comment: "")
    static let westernFrisian = "Western Frisian"
    static let wolof = "Wolof"
    static let xhosa = "Xhosa"
    static let yiddish = "Yiddish"
    static let yoruba = "Yoruba"
    static let yucatecMaya = "Yucatec Maya"
    static let zaza = "Zaza"
    static let zulu = "Zulu"
}

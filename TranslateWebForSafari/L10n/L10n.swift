//
//  L10n.swift
//  TranslateWebForSafari
//
//  Created by Manabu Nakazawa on 14/5/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

class L10n {
    static let appName = "Translate Web for Safari"
    static let openSafariPreferences = NSLocalizedString("Open Safari Preferences…", comment: "")
    static let aboutThisExtension = NSLocalizedString("About this extension", comment: "")
    static let menuItemHideApp = String(format: NSLocalizedString("Hide %@", comment: ""), appName)
    static let menuItemHideOthers = NSLocalizedString("Hide Others", comment: "")
    static let menuItemShowAll = NSLocalizedString("Show All", comment: "")
    static let menuItemQuitApp = String(format: NSLocalizedString("Quit %@", comment: ""), appName)
    static let menuItemWindow = NSLocalizedString("Window", comment: "")
    static let menuItemClose = NSLocalizedString("Close", comment: "")
    static let toolbarItemTranslatePage = NSLocalizedString("Translate the current page", comment: "")
    static let contextMenuTranslatePage = NSLocalizedString("Translate this page", comment: "")
    static func contextMenuTranslateText(with text: String) -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString("Translate \"%@\"", comment: ""),
            text)
    }
    static func toolbarItemTranslateText(with text: String) -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString("Translate \"%@\"", comment: ""),
            text)
    }
    static let translateTo = NSLocalizedString("Translate to", comment: "")
    
    static let baidu = NSLocalizedString("Baidu", comment: "")
    static let bing = NSLocalizedString("Bing", comment: "")
    static let deepL = NSLocalizedString("DeepL", comment: "")
    static let google = NSLocalizedString("Google", comment: "")
    
    static let achinese = NSLocalizedString("Achinese", comment: "")
    static let afrikaans = NSLocalizedString("Afrikaans", comment: "")
    static let akan = NSLocalizedString("Akan", comment: "")
    static let albanian = NSLocalizedString("Albanian", comment: "")
    static let algerianArabic = NSLocalizedString("Algerian Arabic", comment: "")
    static let amharic = NSLocalizedString("Amharic", comment: "")
    static let ancientGreek = NSLocalizedString("Ancient Greek", comment: "")
    static let arabic = NSLocalizedString("Arabic", comment: "")
    static let aragonese = NSLocalizedString("Aragonese", comment: "")
    static let armenian = NSLocalizedString("Armenian", comment: "")
    static let assamese = NSLocalizedString("Assamese", comment: "")
    static let asturian = NSLocalizedString("Asturian", comment: "")
    static let aymara = NSLocalizedString("Aymara", comment: "")
    static let azerbaijani = NSLocalizedString("Azerbaijani", comment: "")
    static let baluchi = NSLocalizedString("Baluchi", comment: "")
    static let bangla = NSLocalizedString("Bangla", comment: "")
    static let bashkir = NSLocalizedString("Bashkir", comment: "")
    static let basque = NSLocalizedString("Basque", comment: "")
    static let belarusian = NSLocalizedString("Belarusian", comment: "")
    static let bemba = NSLocalizedString("Bemba", comment: "")
    static let bengali = NSLocalizedString("Bengali", comment: "")
    static let berberLanguages = NSLocalizedString("Berber languages", comment: "")
    static let bhojpuri = NSLocalizedString("Bhojpuri", comment: "")
    static let bislama = NSLocalizedString("Bislama", comment: "")
    static let blin = NSLocalizedString("Blin", comment: "")
    static let bokmål = NSLocalizedString("Bokmål", comment: "")
    static let bosnian = NSLocalizedString("Bosnian", comment: "")
    static let bosnianLatin = NSLocalizedString("Bosnian (Latin)", comment: "")
    static let brazilianPortuguese = NSLocalizedString("Brazilian Portuguese", comment: "")
    static let breton = NSLocalizedString("Breton", comment: "")
    static let bulgarian = NSLocalizedString("Bulgarian", comment: "")
    static let burmese = NSLocalizedString("Burmese", comment: "")
    static let canadianFrench = NSLocalizedString("Canadian French", comment: "")
    static let cantonese = NSLocalizedString("Cantonese", comment: "")
    static let cantoneseTraditional = NSLocalizedString("Cantonese (Traditional)", comment: "")
    static let catalan = NSLocalizedString("Catalan", comment: "")
    static let cebuano = NSLocalizedString("Cebuano", comment: "")
    static let cherokee = NSLocalizedString("Cherokee", comment: "")
    static let chichewa = NSLocalizedString("Chichewa", comment: "")
    static let chinese = NSLocalizedString("Chinese", comment: "")
    static let chineseSimplified = NSLocalizedString("Chinese (Simplified)", comment: "")
    static let chineseTraditional = NSLocalizedString("Chinese (Traditional)", comment: "")
    static let chuvash = NSLocalizedString("Chuvash", comment: "")
    static let classicalChinese = NSLocalizedString("Classical Chinese", comment: "")
    static let cornish = NSLocalizedString("Cornish", comment: "")
    static let corsican = NSLocalizedString("Corsican", comment: "")
    static let creek = NSLocalizedString("Creek", comment: "")
    static let crimeanTatar = NSLocalizedString("Crimean Tatar", comment: "")
    static let croatian = NSLocalizedString("Croatian", comment: "")
    static let czech = NSLocalizedString("Czech", comment: "")
    static let danish = NSLocalizedString("Danish", comment: "")
    static let divehi = NSLocalizedString("Divehi", comment: "")
    static let dutch = NSLocalizedString("Dutch", comment: "")
    static let english = NSLocalizedString("English", comment: "")
    static let esperanto = NSLocalizedString("Esperanto", comment: "")
    static let estonian = NSLocalizedString("Estonian", comment: "")
    static let faroese = NSLocalizedString("Faroese", comment: "")
    static let fijian = NSLocalizedString("Fijian", comment: "")
    static let filipino = NSLocalizedString("Filipino", comment: "")
    static let finnish = NSLocalizedString("Finnish", comment: "")
    static let french = NSLocalizedString("French", comment: "")
    static let frisian = NSLocalizedString("Frisian", comment: "")
    static let friulian = NSLocalizedString("Friulian", comment: "")
    static let fulani = NSLocalizedString("Fulani", comment: "")
    static let gaelic = NSLocalizedString("Gaelic", comment: "")
    static let galician = NSLocalizedString("Galician", comment: "")
    static let georgian = NSLocalizedString("Georgian", comment: "")
    static let german = NSLocalizedString("German", comment: "")
    static let greek = NSLocalizedString("Greek", comment: "")
    static let guarani = NSLocalizedString("Guarani", comment: "")
    static let gujarati = NSLocalizedString("Gujarati", comment: "")
    static let haitianCreole = NSLocalizedString("Haitian Creole", comment: "")
    static let hakhaChin = NSLocalizedString("Hakha Chin", comment: "")
    static let hausa = NSLocalizedString("Hausa", comment: "")
    static let hawaiian = NSLocalizedString("Hawaiian", comment: "")
    static let hebrew = NSLocalizedString("Hebrew", comment: "")
    static let hiligaynon = NSLocalizedString("Hiligaynon", comment: "")
    static let hindi = NSLocalizedString("Hindi", comment: "")
    static let hmong = NSLocalizedString("Hmong", comment: "")
    static let hmongDaw = NSLocalizedString("Hmong Daw", comment: "")
    static let hungarian = NSLocalizedString("Hungarian", comment: "")
    static let hupa = NSLocalizedString("Hupa", comment: "")
    static let icelandic = NSLocalizedString("Icelandic", comment: "")
    static let ido = NSLocalizedString("Ido", comment: "")
    static let igbo = NSLocalizedString("Igbo", comment: "")
    static let indonesian = NSLocalizedString("Indonesian", comment: "")
    static let ingush = NSLocalizedString("Ingush", comment: "")
    static let interlingua = NSLocalizedString("Interlingua ", comment: "")
    static let inuktitut = NSLocalizedString("Inuktitut", comment: "")
    static let irish = NSLocalizedString("Irish", comment: "")
    static let italian = NSLocalizedString("Italian", comment: "")
    static let japanese = NSLocalizedString("Japanese", comment: "")
    static let javanese = NSLocalizedString("Javanese", comment: "")
    static let kabyle = NSLocalizedString("Kabyle", comment: "")
    static let kalaallisut = NSLocalizedString("Kalaallisut", comment: "")
    static let kannada = NSLocalizedString("Kannada", comment: "")
    static let kanuri = NSLocalizedString("Kanuri", comment: "")
    static let kashmiri = NSLocalizedString("Kashmiri", comment: "")
    static let kashubian = NSLocalizedString("Kashubian", comment: "")
    static let kazakh = NSLocalizedString("Kazakh", comment: "")
    static let khmer = NSLocalizedString("Khmer", comment: "")
    static let kinyarwanda = NSLocalizedString("Kinyarwanda", comment: "")
    static let kiswahili = NSLocalizedString("Kiswahili", comment: "")
    static let klingon = NSLocalizedString("Klingon", comment: "")
    static let kongo = NSLocalizedString("Kongo", comment: "")
    static let konkani = NSLocalizedString("Konkani", comment: "")
    static let korean = NSLocalizedString("Korean", comment: "")
    static let kurdish = NSLocalizedString("Kurdish", comment: "")
    static let kurdishKurmanji = NSLocalizedString("Kurdish (Kurmanji)", comment: "")
    static let kyrgyz = NSLocalizedString("Kyrgyz", comment: "")
    static let lao = NSLocalizedString("Lao", comment: "")
    static let latgalian = NSLocalizedString("Latgalian", comment: "")
    static let latin = NSLocalizedString("Latin", comment: "")
    static let latvian = NSLocalizedString("Latvian", comment: "")
    static let limburgish = NSLocalizedString("Limburgish", comment: "")
    static let lingala = NSLocalizedString("Lingala", comment: "")
    static let lithuanian = NSLocalizedString("Lithuanian", comment: "")
    static let lojban = NSLocalizedString("Lojban", comment: "")
    static let lowerSorbian = NSLocalizedString("Lower Sorbian", comment: "")
    static let lowGerman = NSLocalizedString("Low German", comment: "")
    static let luganda = NSLocalizedString("Luganda", comment: "")
    static let luxembourgish = NSLocalizedString("Luxembourgish", comment: "")
    static let macedonian = NSLocalizedString("Macedonian", comment: "")
    static let maithili = NSLocalizedString("Maithili", comment: "")
    static let malagasy = NSLocalizedString("Malagasy", comment: "")
    static let malay = NSLocalizedString("Malay", comment: "")
    static let malayalam = NSLocalizedString("Malayalam", comment: "")
    static let malayLatin = NSLocalizedString("Malay (Latin)", comment: "")
    static let maltese = NSLocalizedString("Maltese", comment: "")
    static let manx = NSLocalizedString("Manx", comment: "")
    static let maori = NSLocalizedString("Maori", comment: "")
    static let marathi = NSLocalizedString("Marathi", comment: "")
    static let marshallese = NSLocalizedString("Marshallese", comment: "")
    static let mauritianCreole = NSLocalizedString("Mauritian Creole", comment: "")
    static let middleFrench = NSLocalizedString("Middle French", comment: "")
    static let mongolian = NSLocalizedString("Mongolian", comment: "")
    static let montenegrin = NSLocalizedString("Montenegrin", comment: "")
    static let myanmarBurmese = NSLocalizedString("Myanmar (Burmese)", comment: "")
    static let neapolitan = NSLocalizedString("Neapolitan", comment: "")
    static let nepali = NSLocalizedString("Nepali", comment: "")
    static let nKo = NSLocalizedString("N'Ko", comment: "")
    static let northernSami = NSLocalizedString("Northern Sami", comment: "")
    static let northernSotho = NSLocalizedString("Northern Sotho", comment: "")
    static let norwegian = NSLocalizedString("Norwegian", comment: "")
    static let norwegianBokmål = NSLocalizedString("Norwegian Bokmål", comment: "")
    static let nynorsk = NSLocalizedString("Nynorsk", comment: "")
    static let occitan = NSLocalizedString("Occitan", comment: "")
    static let odiaOriya = NSLocalizedString("Odia (Oriya)", comment: "")
    static let ojibwa = NSLocalizedString("Ojibwa", comment: "")
    static let oldEnglish = NSLocalizedString("Old English", comment: "")
    static let oriya = NSLocalizedString("Oriya", comment: "")
    static let oromo = NSLocalizedString("Oromo", comment: "")
    static let ossetian = NSLocalizedString("Ossetian", comment: "")
    static let pampanga = NSLocalizedString("Pampanga", comment: "")
    static let papiamento = NSLocalizedString("Papiamento", comment: "")
    static let pashto = NSLocalizedString("Pashto", comment: "")
    static let persian = NSLocalizedString("Persian", comment: "")
    static let polish = NSLocalizedString("Polish", comment: "")
    static let portuguese = NSLocalizedString("Portuguese", comment: "")
    static let portugueseBrazil = NSLocalizedString("Portuguese (Brazil)", comment: "")
    static let portuguesePortugal = NSLocalizedString("Portuguese (Portugal)", comment: "")
    static let punjabi = NSLocalizedString("Punjabi", comment: "")
    static let punjabiGurmukhi = NSLocalizedString("Punjabi (Gurmukhi)", comment: "")
    static let quechua = NSLocalizedString("Quechua", comment: "")
    static let querétaroOtomi = NSLocalizedString("Querétaro Otomi", comment: "")
    static let romanian = NSLocalizedString("Romanian", comment: "")
    static let romansh = NSLocalizedString("Romansh", comment: "")
    static let romany = NSLocalizedString("Romany", comment: "")
    static let russian = NSLocalizedString("Russian", comment: "")
    static let rusyn = NSLocalizedString("Rusyn", comment: "")
    static let samoan = NSLocalizedString("Samoan", comment: "")
    static let sanskrit = NSLocalizedString("Sanskrit", comment: "")
    static let sardinian = NSLocalizedString("Sardinian", comment: "")
    static let scots = NSLocalizedString("Scots", comment: "")
    static let scotsGaelic = NSLocalizedString("Scots Gaelic", comment: "")
    static let serbian = NSLocalizedString("Serbian", comment: "")
    static let serbianCyrillic = NSLocalizedString("Serbian (Cyrillic)", comment: "")
    static let serbianLatin = NSLocalizedString("Serbian (Latin)", comment: "")
    static let serboCroatian = NSLocalizedString("Serbo-Croatian", comment: "")
    static let sesotho = NSLocalizedString("Sesotho", comment: "")
    static let shan = NSLocalizedString("Shan", comment: "")
    static let shona = NSLocalizedString("Shona", comment: "")
    static let silesian = NSLocalizedString("Silesian", comment: "")
    static let sindhi = NSLocalizedString("Sindhi", comment: "")
    static let sinhala = NSLocalizedString("Sinhala", comment: "")
    static let slovak = NSLocalizedString("Slovak", comment: "")
    static let slovenian = NSLocalizedString("Slovenian", comment: "")
    static let somali = NSLocalizedString("Somali", comment: "")
    static let songhaiLanguages = NSLocalizedString("Songhai languages", comment: "")
    static let southernNdebele = NSLocalizedString("Southern Ndebele", comment: "")
    static let southernSotho = NSLocalizedString("Southern Sotho", comment: "")
    static let spanish = NSLocalizedString("Spanish", comment: "")
    static let sundanese = NSLocalizedString("Sundanese", comment: "")
    static let swahili = NSLocalizedString("Swahili", comment: "")
    static let swedish = NSLocalizedString("Swedish", comment: "")
    static let syriac = NSLocalizedString("Syriac", comment: "")
    static let tagalog = NSLocalizedString("Tagalog", comment: "")
    static let tahitian = NSLocalizedString("Tahitian", comment: "")
    static let tajik = NSLocalizedString("Tajik", comment: "")
    static let tamil = NSLocalizedString("Tamil", comment: "")
    static let tatar = NSLocalizedString("Tatar", comment: "")
    static let telugu = NSLocalizedString("Telugu", comment: "")
    static let tetum = NSLocalizedString("Tetum", comment: "")
    static let thai = NSLocalizedString("Thai", comment: "")
    static let tigrinya = NSLocalizedString("Tigrinya", comment: "")
    static let tongan = NSLocalizedString("Tongan", comment: "")
    static let tsonga = NSLocalizedString("Tsonga", comment: "")
    static let tunisianArabic = NSLocalizedString("Tunisian Arabic", comment: "")
    static let turkish = NSLocalizedString("Turkish", comment: "")
    static let turkmen = NSLocalizedString("Turkmen", comment: "")
    static let twi = NSLocalizedString("Twi", comment: "")
    static let ukrainian = NSLocalizedString("Ukrainian", comment: "")
    static let upperSorbian = NSLocalizedString("Upper Sorbian", comment: "")
    static let urdu = NSLocalizedString("Urdu", comment: "")
    static let uyghur = NSLocalizedString("Uyghur", comment: "")
    static let uzbek = NSLocalizedString("Uzbek", comment: "")
    static let venda = NSLocalizedString("Venda", comment: "")
    static let vietnamese = NSLocalizedString("Vietnamese", comment: "")
    static let walloon = NSLocalizedString("Walloon", comment: "")
    static let welsh = NSLocalizedString("Welsh", comment: "")
    static let westernFrisian = NSLocalizedString("Western Frisian", comment: "")
    static let wolof = NSLocalizedString("Wolof", comment: "")
    static let xhosa = NSLocalizedString("Xhosa", comment: "")
    static let yiddish = NSLocalizedString("Yiddish", comment: "")
    static let yoruba = NSLocalizedString("Yoruba", comment: "")
    static let yucatecMaya = NSLocalizedString("Yucatec Maya", comment: "")
    static let zaza = NSLocalizedString("Zaza", comment: "")
    static let zulu = NSLocalizedString("Zulu", comment: "")
}

//
//  DataManager.swift
//  VoiceTranslator
//
//  Created by apple on 18.09.2022.
//

import UIKit
import NaturalLanguage


class DataManager {
    static let shared = DataManager()
    
    let allCountry: [LanguageStuck] = [
        .init(flagName: "NL", countryName: "Dutch", shortName: "nl", localShortLanguage: "nl-NL"),
        .init(flagName: "FR", countryName: "French", shortName: "fr", localShortLanguage: "fr-FR"),
        .init(flagName: "TW", countryName: "Chinese", shortName: "zh", localShortLanguage: "zh-TW"),
        .init(flagName: "IT", countryName: "Italian", shortName: "it", localShortLanguage: "it-IT"),
        .init(flagName: "VN", countryName: "Vietnamese", shortName: "vi", localShortLanguage: "vi-VN"),
        .init(flagName: "KR", countryName: "Korean", shortName: "ko", localShortLanguage: "ko-KR"),
        .init(flagName: "RO", countryName: "Romanian", shortName: "ro", localShortLanguage: "ro-RO"),
        .init(flagName: "IN", countryName: "Hindi", shortName: "hi", localShortLanguage: "hi-IN"),
        .init(flagName: "DK", countryName: "Danish", shortName: "da", localShortLanguage: "da-DK"),
        .init(flagName: "CN", countryName: "Chinese", shortName: "zh", localShortLanguage: "zh-CN"),
        .init(flagName: "SE", countryName: "Swedish", shortName: "sv", localShortLanguage: "sv-SE"),
        .init(flagName: "ES", countryName: "Spanish", shortName: "ES", localShortLanguage: "es-ES"),
        .init(flagName: "SA", countryName: "Arabic", shortName: "ar", localShortLanguage: "ar-SA"),
        .init(flagName: "HU", countryName: "Magyar", shortName: "hu", localShortLanguage: "hu-HU"),
        .init(flagName: "GB", countryName: "English", shortName: "en", localShortLanguage: "en-GB"),
        .init(flagName: "JP", countryName: "Japanese", shortName: "ja", localShortLanguage: "ja-JP"),
        .init(flagName: "FI", countryName: "Finnish", shortName: "fi", localShortLanguage: "fi-FI"),
        .init(flagName: "TR", countryName: "Turkish", shortName: "tr", localShortLanguage: "tr-TR"),
        .init(flagName: "NO", countryName: "Norwegian", shortName: "nb", localShortLanguage: "nb-NO"),
        .init(flagName: "PL", countryName: "Polish", shortName: "pl", localShortLanguage: "pl-PL"),
        .init(flagName: "MY", countryName: "Malaysian", shortName: "ms", localShortLanguage: "ms-MY"),
        .init(flagName: "CZ", countryName: "Czech", shortName: "cs", localShortLanguage: "cs-CZ"),
        .init(flagName: "GR", countryName: "Greece", shortName: "el", localShortLanguage: "el-GR"),
        .init(flagName: "ID", countryName: "Indonesian", shortName: "id", localShortLanguage: "id-ID"),
        .init(flagName: "HR", countryName: "Croatian", shortName: "hr", localShortLanguage: "hr-HR"),
        .init(flagName: "IL", countryName: "Hebrew", shortName: "he", localShortLanguage: "he-IL"),
        .init(flagName: "RU", countryName: "Russian", shortName: "ru", localShortLanguage: "ru-RU"),
        .init(flagName: "DE", countryName: "German", shortName: "de", localShortLanguage: "de-DE"),
        .init(flagName: "AU", countryName: "English", shortName: "en", localShortLanguage: "en-AU"),
        .init(flagName: "TH", countryName: "Thai", shortName: "th", localShortLanguage: "th-TH"),
        .init(flagName: "PT", countryName: "Portuguese", shortName: "pt", localShortLanguage: "pt-PT"),
        .init(flagName: "SK", countryName: "Slovak", shortName: "sk", localShortLanguage: "sk-SK"),
        .init(flagName: "US", countryName: "English", shortName: "en", localShortLanguage: "en-US"),
        .init(flagName: "UA", countryName: "Ukrainian", shortName: "uk", localShortLanguage: "uk-UA", isUseVoice: false),
        .init( flagName: "BY", countryName: "Belarus", shortName: "be", localShortLanguage: "ru-BY", isUseVoice: false),
        .init( flagName: "AZ", countryName: "Azerbaijani", shortName: "az", localShortLanguage: "az-AZ", isUseVoice: false, isUseMicro: false),
        .init(flagName: "AM", countryName: "Armenian", shortName: "hy", localShortLanguage: "hy-AM", isUseVoice: false, isUseMicro: false),
        .init( flagName: "AL", countryName: "Albanian", shortName: "sq", localShortLanguage: "sq-AL", isUseVoice: false, isUseMicro: false),
        .init(flagName: "IE", countryName: "Irish", shortName: "ga", localShortLanguage: "ga-IE", isUseVoice: false, isUseMicro: false),
        .init(flagName: "LV", countryName: "Latvian", shortName: "lv", localShortLanguage: "lv-LV", isUseVoice: false, isUseMicro: false),
        .init(flagName: "EE", countryName: "Estonian", shortName: "et", localShortLanguage: "et-EE", isUseVoice: false, isUseMicro: false),
        .init(flagName: "GE", countryName: "Georgian", shortName: "ka", localShortLanguage: "ka-GE", isUseVoice: false, isUseMicro: false),
        .init(flagName: "KZ", countryName: "Kazakh", shortName: "kk", localShortLanguage: "kk-KZ", isUseVoice: false, isUseMicro: false),
        .init(flagName: "UZ", countryName: "Uzbek", shortName: "uz", localShortLanguage: "uz-UZ", isUseVoice: false, isUseMicro: false),
        .init(flagName: "TJ", countryName: "Tajik", shortName: "tg", localShortLanguage: "tg-TJ", isUseVoice: false, isUseMicro: false),
        .init(flagName: "LT", countryName: "Lithuanian", shortName: "lt", localShortLanguage: "lt-LT", isUseVoice: false, isUseMicro: false),
        .init(flagName: "ZA", countryName: "Afrikaans", shortName: "af", localShortLanguage: "af-ZA", isUseVoice: false, isUseMicro: false),
        .init(flagName: "ET", countryName: "Amharic", shortName: "am", localShortLanguage: "am-ET", isUseVoice: false, isUseMicro: false),
        .init(flagName: "LU", countryName: "Luxembourgish", shortName: "lb", localShortLanguage: "lb-LU", isUseVoice: false, isUseMicro: false),
        .init(flagName: "MG", countryName: "Malagasy", shortName: "mg", localShortLanguage: "mg-MG", isUseVoice: false, isUseMicro: false),
        .init( flagName: "MK", countryName: "Macedonian", shortName: "mk", localShortLanguage: "mk-MK", isUseVoice: false, isUseMicro: false),
        .init( flagName: "ZA", countryName: "Zulu", shortName: "zu", localShortLanguage: "zu-ZA", isUseVoice: false, isUseMicro: false),
        .init( flagName: "ZA", countryName: "Xhosa", shortName: "xh", localShortLanguage: "xh-ZA", isUseVoice: false, isUseMicro: false),
        .init(flagName: "ZA", countryName: "Tsonga", shortName: "ts", localShortLanguage: "ts-ZA", isUseVoice: false, isUseMicro: false)
       
        
        
    ]
    let recognizeContry: [LanguageStuck] = [
        .init(flagName: "NL", countryName: "Dutch", shortName: "nl", localShortLanguage: "nl-NL"),
        .init(flagName: "FR", countryName: "French", shortName: "fr", localShortLanguage: "fr-FR"),
        .init(flagName: "IT", countryName: "Italian", shortName: "it", localShortLanguage: "it-IT"),
        .init(flagName: "RO", countryName: "Romanian", shortName: "ro", localShortLanguage: "ro-RO"),
        .init(flagName: "DK", countryName: "Danish", shortName: "da", localShortLanguage: "da-DK"),
        .init(flagName: "CN", countryName: "Chinese", shortName: "zh", localShortLanguage: "zh-CN"),
        .init(flagName: "SE", countryName: "Swedish", shortName: "sv", localShortLanguage: "sv-SE"),
        .init(flagName: "ES", countryName: "Spanish", shortName: "ES", localShortLanguage: "es-ES"),
        .init(flagName: "HU", countryName: "Magyar", shortName: "hu", localShortLanguage: "hu-HU"),
        .init(flagName: "GB", countryName: "English", shortName: "en", localShortLanguage: "en-GB"),
        .init(flagName: "FI", countryName: "Finnish", shortName: "fi", localShortLanguage: "fi-FI"),
        .init(flagName: "NO", countryName: "Norwegian", shortName: "nb", localShortLanguage: "nb-NO"),
        .init(flagName: "PL", countryName: "Polish", shortName: "pl", localShortLanguage: "pl-PL"),
        .init(flagName: "MY", countryName: "Malaysian", shortName: "ms", localShortLanguage: "ms-MY"),
        .init(flagName: "CZ", countryName: "Czech", shortName: "cs", localShortLanguage: "cs-CZ"),
        .init(flagName: "DE", countryName: "German", shortName: "de", localShortLanguage: "de-DE"),
        .init(flagName: "AU", countryName: "English", shortName: "en", localShortLanguage: "en-AU"),
        .init(flagName: "PT", countryName: "Portuguese", shortName: "pt", localShortLanguage: "pt-PT"),
        .init(flagName: "SK", countryName: "Slovak", shortName: "sk", localShortLanguage: "sk-SK"),
        .init(flagName: "US", countryName: "English", shortName: "en", localShortLanguage: "en-US"),
        .init(flagName: "TR", countryName: "Turkish", shortName: "tr", localShortLanguage: "tr-TR")
    ]
   
    func getDefaultLanguage() -> LanguageStuck {
        var languageCurrent = allCountry[0]
        allCountry.forEach { language in
            if language.flagName == "GB" {
                
                languageCurrent = language
            }
        }
        return languageCurrent
    }
    func getCurrentLanguage() -> LanguageStuck {
        var languageCurrent = allCountry[0]
        allCountry.forEach { language in
            if language.flagName == NSLocale.current.regionCode {
                languageCurrent = language
            }
        }
        return languageCurrent
    }
    func detetectedLanguageForInit(localLanguage: String) -> LanguageStuck {
        var languageCurrent = allCountry[0]
        allCountry.forEach { language in
            if language.localShortLanguage == localLanguage {
                languageCurrent = language
            }
        }
        return languageCurrent
    }
    func detectedLanguage(for string: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
        guard let countryLanguage = detectedLanguage?.firstWord() else { return nil }
        var localShortLanguage: String?
        allCountry.forEach { language in
            if language.countryName == countryLanguage{
                localShortLanguage = language.localShortLanguage
            }
        }
        return localShortLanguage
    }
    func ifCanSpeech(language: LanguageStuck) -> Bool {
    var result = false
        speechArray.forEach { canSpeech in
            if language.localShortLanguage == canSpeech{
                result = true
            }
        }
        return result
    }
    func sortCountriesByMicro() -> [LanguageStuck] {
        var newArray = [LanguageStuck]()
        for country in allCountry {
            for language in speechArray {
                if country.localShortLanguage == language {
                    newArray.append(country)
                }
            }
        }
       return newArray
    }
    let speechArray = [
        "nl-NL",
        "es-MX",
        "fr-FR",
        "zh-TW",
        "it-IT",
        "vi-VN",
        "fr-CH",
        "es-CL",
        "en-ZA",
        "ko-KR",
        "ca-ES",
        "ro-RO",
        "en-PH",
        "es-419",
        "en-CA",
        "en-SG",
        "en-IN",
        "en-NZ",
        "it-CH",
        "fr-CA",
        "hi-IN",
        "da-DK",
        "de-AT",
        "pt-BR",
        "yue-CN",
        "zh-CN",
        "sv-SE",
        "hi-IN-translit",
        "es-ES",
        "ar-SA",
        "hu-HU",
        "fr-BE",
        "en-GB",
        "ja-JP",
        "zh-HK",
        "fi-FI",
        "tr-TR",
        "nb-NO",
        "en-ID",
        "en-SA",
        "pl-PL",
        "ms-MY",
        "cs-CZ",
        "el-GR",
        "id-ID",
        "hr-HR",
        "en-AE",
        "he-IL",
        "ru-RU",
        "wuu-CN",
        "de-DE",
        "de-CH",
        "en-AU",
        "nl-BE",
        "th-TH",
        "pt-PT",
        "sk-SK",
        "en-US",
        "en-IE",
        "es-CO",
        "hi-Latn",
        "uk-UA",
        "es-US"
    ]
}

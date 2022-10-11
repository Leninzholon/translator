//
//  VoiseTranslateModel.swift
//  VoiceTranslator
//
//  Created by apple on 22.09.2022.
//

import Foundation


struct TranslatedModel: Codable {
    let questinLanguage: String
    let questionText: String
    let responseLanguege: String
    let respondText: String
    let whatIsSide: isSide
}


enum isSide: Codable {
   case left
    case right
}

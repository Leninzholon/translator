//
//  Constants.swift
//  VoiceTranslator
//
//  Created by apple on 05.10.2022.
//

import Foundation

class Constants {
    static let shared = Constants()
    
    var openKey: String {
        return self.adsKey
    }
    
    private let adsKey = "ca-app-pub-3940256099942544/2934735716"
}

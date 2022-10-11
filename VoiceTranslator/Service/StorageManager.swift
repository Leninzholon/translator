//
//  StorageManager.swift
//  VoiceTranslator
//
//  Created by apple on 24.09.2022.
//

import Foundation


class StorageManager {
    
    static let shared = StorageManager()
    
    func save(translated: TranslatedModel) {
        var translatedArray = load()
        translatedArray.append(translated)
        UserDefaults.standard.set(encodable: translatedArray, forKey: "translated")
    }
    func load() -> [TranslatedModel] {
        guard let array = UserDefaults.standard.value([TranslatedModel].self, forKey: "translated") else { return [] }
        return array
    }
    func delete(at index: Int) {
        var translatedArray = load()
        translatedArray.remove(at: index)
        UserDefaults.standard.set(encodable: translatedArray, forKey: "translated")
    }
    func deleteAll() {
        let translatedArray = [TranslatedModel]()
        UserDefaults.standard.set(encodable: translatedArray, forKey: "translated")
    }
}
extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}

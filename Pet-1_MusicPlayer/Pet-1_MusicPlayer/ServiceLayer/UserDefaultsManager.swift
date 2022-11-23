//
//  UserDefaultsManager.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/23/22.
//

import Foundation

protocol UserDefaultsManagerProtocol{
    func save(_ tracks: [Track], forKey: String)
    func loadData(forKey: String, complition: @escaping ([Track]) -> Void)
}

class UserDefaultsManager: UserDefaultsManagerProtocol {
    
    static var shared = UserDefaultsManager()
    
    func save(_ tracks: [Track], forKey: String){
        let data = try? JSONEncoder().encode(tracks)
        UserDefaults.standard.set(data, forKey: forKey)
    }
    
    func loadData(forKey: String, complition: @escaping ([Track]) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: forKey) else { return }
        do {
            let traks = try JSONDecoder().decode([Track].self, from: data)
            complition(traks)
        } catch {
            
        }
    }
}

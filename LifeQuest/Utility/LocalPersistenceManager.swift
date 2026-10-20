//
//  LocalPersistenceManager.swift
//  LifeQuest
//
//  Created by Icy on 10/20/26.
//

import Foundation

enum PersistenceError: Error {
    case notImplemented
}

struct LocalPersistenceManager {
    func save<T: Codable>(_  data: T,  to url: URL) throws {
        let encoder = JSONEncoder()
        let dataToSave = try encoder.encode(data)
        
        try dataToSave.write(to: url)
    }
    
    func load<T: Codable>( from url: URL) throws -> T {
        let decoder = JSONDecoder()
        let dataToLoad = try Data(contentsOf: url)
        
        return try decoder.decode(T.self, from: dataToLoad)
    }
    
    static func documentsURL( for filename: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }
}

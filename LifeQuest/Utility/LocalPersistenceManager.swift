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
        throw PersistenceError.notImplemented
    }
    
    func load<T: Codable>( from url: URL) throws -> T {
        throw PersistenceError.notImplemented
    }
    
    static func documentsURL( for filename: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }
}

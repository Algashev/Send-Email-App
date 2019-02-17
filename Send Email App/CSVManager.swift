//
//  CSVManager.swift
//  Send Email App
//
//  Created by Александр Алгашев on 16/02/2019.
//  Copyright © 2019 Александр Алгашев. All rights reserved.
//

import UIKit

struct ManagerKeys {
    static let vocabularyFile: String = "Vocabulary.csv"
    static let vocabularyPath: URL = FileManager.default.temporaryDirectory.appendingPathComponent(ManagerKeys.vocabularyFile)
}

class CSVManager {
    init() {
//        print(ManagerKeys.vocabularyPath)
    }
    
    func createCSV() -> Bool {
        if fileExists() { return true }
        
        let csvText = "Date,Task,Time Started,Time Ended\n"

        do {
            try csvText.write(to: ManagerKeys.vocabularyPath, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Failed to create file: \(ManagerKeys.vocabularyFile)")
            print("\(error)")
            return false
        }
    }
    func preperaToEmail() -> Data? {
        if !fileExists() { return nil }
        
        do {
            return try Data(contentsOf: ManagerKeys.vocabularyPath)
        } catch {
            print("Failed to prepara file \(ManagerKeys.vocabularyPath) for email.")
            print("\(error)")
            return nil
        }
    }
    func clearCSV() -> Bool {
        do {
            try FileManager.default.removeItem(at: ManagerKeys.vocabularyPath)
            print("\"\(ManagerKeys.vocabularyFile)\" successfully deleted.")
            return true
        } catch {
            print("Failed to delete file: \(ManagerKeys.vocabularyFile)")
            print("\(error)")
            return false
        }
    }
    func fileExists() -> Bool {
        return FileManager.default.fileExists(atPath: ManagerKeys.vocabularyPath.path)
    }
}

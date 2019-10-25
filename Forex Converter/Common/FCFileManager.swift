//
//  FCFileManager.swift
//  Forex Converter
//
//  Created by Idan Moshe on 16/10/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit

class FCFileManager {
    
    static func path(for fileName: String) -> URL {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsURL.appendingPathComponent("\(fileName)")
        return documentsURL
    }
    
    static func replaceContentOfFile(fileName: String, contents: Data?) {
        self.remove(fileName: fileName)
        
        let path: URL = self.path(for: fileName)
        
        if let contents = contents {
            do {
                try contents.write(to: path, options: .atomic)
            } catch let error {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
            
        }
    }
        
    static func remove(fileName: String) {
        let path: String = self.path(for: fileName).absoluteString
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch let error{
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    static func load(fileName: String) -> Data? {
        let path: URL = self.path(for: fileName)
        do {
            let data = try Data(contentsOf: path)
            return data
        }
        catch let error {
            #if DEBUG
            print(error)
            #endif
        }
        return nil
    }
        
}

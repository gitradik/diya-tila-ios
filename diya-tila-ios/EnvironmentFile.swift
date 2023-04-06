//
//  GetEnv.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 04.04.2023.
//

import SwiftUI

class EnvironmentFile {
    static let shared = EnvironmentFile()

    var plistDictionary: [String: Any]?

    private init() {
        guard let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            fatalError("Unable to locate Info.plist")
        }

        let plistData = FileManager.default.contents(atPath: plistPath)
        self.plistDictionary = try? PropertyListSerialization.propertyList(from: plistData!, format: nil) as? [String: Any]
    }
}

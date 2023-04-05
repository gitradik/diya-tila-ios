//
//  CombinateTwoDictionaries.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 05.04.2023.
//

func combineDictionaries(_ dictionaries: [Dictionary<String, Any>]) -> [String: Any] {
    var combinedDict = [String: Any]()
    for dictionary in dictionaries {
        for (key, value) in dictionary {
            combinedDict[key] = value
        }
    }
    return combinedDict
}

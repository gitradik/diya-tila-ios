//
//  CombinateTwoDictionaries.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 05.04.2023.
//

func combineTwoDictionaries(dict1: [String: Any], dict2: [String: Any]) -> [String: Any] {
    var combinedDict = [String: Any]()
    for (key, value) in dict1 {
        combinedDict[key] = value
    }
    for (key, value) in dict2 {
        combinedDict[key] = value
    }
    return combinedDict
}

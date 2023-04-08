//
//  ERRWithMessage.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

protocol ERRWithMessage: Error {
    var errorMessage: String { get }
}

//
//  FormField.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

class FormField: ObservableObject {
    
    enum ValidationRule {
        case none
        case required
        case custom((String?) -> Bool)
    }
    
    let type: FormFieldType
    let label: String?
    let placeholder: String?
    
    @Published var value = ""
    @Published var isValid: Bool = true
    @Published var errorMessage: String = ""
    
    private var validationRules: [ValidationRule]
    
    init(type: FormFieldType, defaultValue: String, label: String?, placeholder: String?, validationRules: [ValidationRule] = []) {
        self.type = type
        self.value = defaultValue
        self.label = label
        self.placeholder = placeholder
        self.validationRules = validationRules
    }
    
    func handleChange(newValue: String) {
        if type == .number {
            let filtered = newValue.filter { "0123456789".contains($0) }
            self.value = filtered
        } else {
            self.value = newValue
        }
    }
    
    func validate() {
        for rule in validationRules {
            switch rule {
            case .none:
                break
            case .required:
                if value == "" {
                    toInvalid(msg: "This field is required.")
                    return
                }
            case .custom(let validationClosure):
                if !validationClosure(value) {
                    toInvalid(msg: "Invalid value.")
                    return
                }
            }
        }
        toValid()
    }
    
    private func toValid() {
        isValid = true
        errorMessage = ""
    }
    private func toInvalid(msg: String) {
        isValid = false
        errorMessage = msg
    }
    
    func reset() {
        value = ""
        isValid = true
        errorMessage = ""
    }
}

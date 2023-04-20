//
//  FormField.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

class FormField: ObservableObject, Identifiable {
    let id: UUID = UUID()
    
    enum ValidationRule {
        case none
        case required
        case email
        case password
        case custom((String?) -> Bool)
    }
    
    let type: FormFieldType
    let name: String
    let label: String?
    let placeholder: String?
    
    var minValue: Double?
    var maxValue: Double?
    var stepValue: Double?
    
    @Published var value: String?
    @Published var isOnValue: Bool?
    @Published var dateValue: Date?
    @Published var doubleValue: Double?
    @Published var isValid: Bool = true
    @Published var errorMessage: String = ""
    
    private var validationRules: [ValidationRule]
    
    init(type: FormFieldType, name: String, defaultValue: String, label: String = "", placeholder: String = "", validationRules: [ValidationRule] = []) {
        self.type = type
        self.name = name
        self.value = defaultValue
        self.label = label
        self.placeholder = placeholder
        self.validationRules = validationRules
    }
    
    init(type: FormFieldType, name: String, defaultValue: Double, minValue: Double = 1, maxValue: Double = 10, stepValue: Double = 1, label: String = "", validationRules: [ValidationRule] = []) {
        self.type = type
        self.name = name
        self.doubleValue = defaultValue
        self.label = label
        self.placeholder = ""
        self.minValue = minValue
        self.maxValue = maxValue
        self.stepValue = stepValue
        self.validationRules = validationRules
    }
    
    init(type: FormFieldType, name: String, defaultValue: Bool, label: String = "", validationRules: [ValidationRule] = []) {
        self.type = type
        self.name = name
        self.isOnValue = defaultValue
        self.label = label
        self.placeholder = ""
        self.validationRules = validationRules
    }
    
    func handleChangeValue(newValue: String) {
        if type == .number {
            let filtered = newValue.filter { "0123456789".contains($0) }
            self.value = filtered
        } else {
            self.value = newValue
        }
    }
    func handleChangeValue(newValue: Bool) {
        self.isOnValue = newValue
    }
    func handleChangeValue(newValue: Date) {
        self.dateValue = newValue
    }
    func handleChangeValue(newValue: Double) {
        self.doubleValue = newValue
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
            case .email:
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                if !emailPredicate.evaluate(with: value) {
                    toInvalid(msg: "Email is invalid.")
                    return
                }
            case .password:
                guard let password = value else {
                    toInvalid(msg: "Minimum 8 characters, 1 uppercase letter, 1 digit.")
                    return
                }
                let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d\\W]{8,}$"
                
                do {
                    let regex = try NSRegularExpression(pattern: passwordRegex, options: .anchorsMatchLines)
                    let range = NSRange(location: 0, length: password.utf16.count)
                    let matches = regex.matches(in: password, options: [], range: range)
                    if matches.count <= 0 {
                        toInvalid(msg: "Minimum 8 characters, 1 uppercase letter, 1 digit.")
                        return
                    }
                } catch {
                    toInvalid(msg: "Minimum 8 characters, 1 uppercase letter, 1 digit.")
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
        print("toValid:", isValid, errorMessage)
    }
    private func toInvalid(msg: String) {
        isValid = false
        errorMessage = msg
        print("toInvalid:", isValid, errorMessage)
    }
    
    func reset() {
        value = ""
        isValid = true
        errorMessage = ""
    }
}

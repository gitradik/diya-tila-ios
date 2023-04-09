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
        case email
        case confirmPassword(String)
        case custom((String?) -> Bool)
    }
    
    let type: FormFieldType
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
    
    init(type: FormFieldType, defaultValue: String, label: String?, placeholder: String = "", validationRules: [ValidationRule] = []) {
        self.type = type
        self.value = defaultValue
        self.label = label
        self.placeholder = placeholder
        self.validationRules = validationRules
    }
    
    init(type: FormFieldType, defaultValue: Double, minValue: Double = 1, maxValue: Double = 10, stepValue: Double = 1, label: String?, placeholder: String = "", validationRules: [ValidationRule] = []) {
        self.type = type
        self.doubleValue = defaultValue
        self.label = label
        self.placeholder = placeholder
        self.minValue = minValue
        self.maxValue = maxValue
        self.stepValue = stepValue
        self.validationRules = validationRules
    }
    
    init(type: FormFieldType, defaultValue: Bool, label: String?, placeholder: String = "", validationRules: [ValidationRule] = []) {
        self.type = type
        self.isOnValue = defaultValue
        self.label = label
        self.placeholder = placeholder
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
    
    func handleChangeIsOnValue(newValue: Bool) {
        self.isOnValue = newValue
    }
    
    func handleChangeDateValue(newValue: Date) {
        self.dateValue = newValue
    }
    
    func handleChangeDoubleValue(newValue: Double) {
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
            case .confirmPassword(let password):
                print(value, password)
                if value != password {
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

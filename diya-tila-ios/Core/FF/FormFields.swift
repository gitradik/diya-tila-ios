//
//  FormFields.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI
import Combine

class FormFields {
    
    static func renderField(ff: FormField) -> some View {
        VStack {
            Text(ff.label ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
            switch ff.type {
            case .text:
                TextField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                    .keyboardType(keyboardType(for: ff.type))
                    .padding(.vertical, 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(ff.isValid ? Color.secondaryColor : Color.errorColor)
                            .frame(height: 1)
                            , alignment: .bottom
                    )
            case .number:
                TextField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                    .keyboardType(keyboardType(for: ff.type))
                    .padding(.vertical, 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(ff.isValid ? Color.secondaryColor : Color.errorColor)
                            .frame(height: 1)
                            , alignment: .bottom
                    )
            case .email:
                TextField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                    .keyboardType(keyboardType(for: ff.type))
                    .padding(.vertical, 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(ff.isValid ? Color.secondaryColor : Color.errorColor)
                            .frame(height: 1)
                            , alignment: .bottom
                    )
            case .password:
                SecureField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                    .padding(.vertical, 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(ff.isValid ? Color.secondaryColor : Color.errorColor)
                            .frame(height: 1)
                            , alignment: .bottom
                    )
                
                // MARK: this shoud be with styles
            case .checkbox:
                Toggle(isOn: .init(get: { ff.isOnValue! }, set: ff.handleChangeValue), label: {
                    Text(ff.placeholder ?? "")
                })
            case .date:
                DatePicker(ff.placeholder ?? "", selection: .init(get: { ff.dateValue! }, set: ff.handleChangeValue), displayedComponents: .date)
            case .switch_:
                Toggle(isOn: .init(get: { ff.isOnValue! }, set: ff.handleChangeValue)) {
                    Text(ff.placeholder ?? "")
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            case .slider:
                Slider(value: .init(get: { ff.doubleValue! }, set: ff.handleChangeValue), in: ff.minValue!...ff.maxValue!, step: ff.stepValue!)
                    .accentColor(.blue)
            default:
                EmptyView()
            }
            
            Text(ff.errorMessage)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    static func keyboardType(for ffType: FormFieldType) -> UIKeyboardType {
        switch ffType {
        case .text:
            return .default
        case .number:
            return .numberPad
        case .email:
            return .emailAddress
        case .password:
            return .default
        default:
            return .default
        }
    }
    
}

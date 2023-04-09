//
//  FormFields.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI
import Combine

class FormFields: ObservableObject {
    @Published var fields: [FormField] = []
    
    func addField(_ ff: FormField) {
        fields.append(ff)
    }
    
    func renderField(ff: FormField) -> some View {
        VStack {
            Text(ff.label ?? "")
            switch ff.type {
            case .text:
                AnyView(TextField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                                .keyboardType(keyboardType(for: ff.type)))
            case .number:
                AnyView(TextField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                                .keyboardType(keyboardType(for: ff.type)))
            case .email:
                AnyView(TextField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                                .keyboardType(keyboardType(for: ff.type)))
            case .password:
                AnyView(SecureField(ff.placeholder ?? "", text: .init(get: { ff.value! }, set: ff.handleChangeValue))
                                .keyboardType(keyboardType(for: ff.type)))
            case .checkbox:
                AnyView(
                    Toggle(isOn: .init(get: { ff.isOnValue! }, set: ff.handleChangeIsOnValue), label: {
                        Text(ff.placeholder ?? "")
                    }))
            case .date:
                AnyView(
                    DatePicker(ff.placeholder ?? "", selection: .init(get: { ff.dateValue! }, set: ff.handleChangeDateValue), displayedComponents: .date)
                )
            case .switch_:
                AnyView(
                    Toggle(isOn: .init(get: { ff.isOnValue! }, set: ff.handleChangeIsOnValue)) {
                        Text(ff.placeholder ?? "")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue)) // Можно настроить цвет переключателя
                )
            case .slider:
                AnyView(
                    Slider(value: .init(get: { ff.doubleValue! }, set: ff.handleChangeDoubleValue), in: ff.minValue!...ff.maxValue!, step: ff.stepValue!)
                        .accentColor(.blue) // Можно настроить цвет ползунка
                )
            default:
                AnyView(EmptyView())
            }
        }
    }

    private func keyboardType(for ffType: FormFieldType) -> UIKeyboardType {
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


extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

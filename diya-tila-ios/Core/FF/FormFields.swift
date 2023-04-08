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
    
    func addField(_ field: FormField) {
        fields.append(field)
    }
    
    func renderField(ff: FormField) -> some View {
        switch ff.type {
        case .text:
            return renderTextField(formField: ff).eraseToAnyView()
        case .number:
            return renderNumberField(formField: ff).eraseToAnyView()
        case .email:
            return renderEmailFields().eraseToAnyView()
        case .password:
            return renderEmailFields().eraseToAnyView()
        case .checkbox:
            return renderEmailFields().eraseToAnyView()
        case .date:
            return renderEmailFields().eraseToAnyView()
        case .dropdown:
            return renderEmailFields().eraseToAnyView()
        case .switch_:
            return renderEmailFields().eraseToAnyView()
        case .radio:
            return renderEmailFields().eraseToAnyView()
        case .slider:
            return renderEmailFields().eraseToAnyView()
        }
    }
    
    private func renderTextField(formField: FormField) -> some View {
        VStack {
            Text(formField.label ?? "")
            TextField(formField.placeholder ?? "", text: .init(get: { formField.value }, set: formField.handleChange))
        }
    }
    
    func renderNumberField(formField: FormField) -> some View {
        VStack {
            Text(formField.label ?? "")
            TextField(formField.placeholder ?? "", text: .init(get: { formField.value }, set: formField.handleChange))
                        .keyboardType(.numberPad)
        }
       
    }
    
    func renderEmailFields() -> some View {
        EmptyView()
    }
}


extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

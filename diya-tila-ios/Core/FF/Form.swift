//
//  Form.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

struct Form {
    private var formFields = FormFields()
    
    init(fields: [FormField]) {
        for f in fields {
            formFields.addField(f)
        }
    }
    
    func renderFields() -> some View {
        ForEach(0..<formFields.fields.count) { index in
            self.formFields.renderField(ff: formFields.fields[index])
        }
    }
}

//
//  Form.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

struct Form {
    let formFields = FormFields()
    
    init(fields: [FormField]) {
        for ff in fields {
            formFields.addField(ff)
        }
    }
    
    func addField(ff: FormField) {
        formFields.addField(ff)
    }
    
    func getFieldByType(type: FormFieldType) -> FormField? {
        let formFields = formFields.fields.filter { ff in
            ff.type == type
        }
        
        if formFields.isEmpty {
            return nil
        }
        
        return formFields[0]
    }
    
    func renderFields() -> some View {
        ForEach(0..<formFields.fields.count) { index in
            self.formFields.renderField(ff: formFields.fields[index])
        }
    }
    
    func validate() {
        for ff in formFields.fields {
            ff.validate()
        }
    }
}

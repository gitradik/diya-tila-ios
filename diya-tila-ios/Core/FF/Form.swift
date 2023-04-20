//
//  Form.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

struct Form: View {
    @State var fields: [FormField] = []
    let submitButtonLabel: String
    let submit: ([String: FormField]) -> Void
    
    func validate() {
        for ff in fields {
            ff.validate()
        }
        let ffs = fields
        fields = []
        fields = ffs
    }
    func isValid() -> Bool {
        fields.allSatisfy { $0.isValid }
    }
    
    var body: some View {
        VStack {
            ForEach(fields) { ff in
                FormFields.renderField(ff: ff)
            }
            
            Button(action: {
                validate()
                
                guard isValid() else {
                    return
                }
                
                
                var dictionary: [String: FormField] = [:]
                for ff in fields {
                    dictionary[ff.name] = ff
                }
                submit(dictionary)
            }) {
                Text(submitButtonLabel)
                    .padding(12)
                    .border(Color.primaryColor)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(Color.secondaryColor)
            .background(Color.primaryColor)
            .cornerRadius(10)
        }
    }
}

//
//  LoginView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    let login: ((_ email: String, _ passwd: String) -> Void)
    
    var body: some View {
        VStack {
            Image("Logo").sizeToFit().frame(width: 170, height: 170)
            
            Form(fields: [
                FormField(type: .email, name: "email", defaultValue: "", placeholder: "Email:", validationRules: [.required, .email]),
                FormField(type: .password, name: "password", defaultValue: "", placeholder: "Password:", validationRules: [.required, .password])
            ], submitButtonLabel: "Sign In") { fields in
                if let emailValue = fields["email"]?.value,
                   let passwordValue = fields["password"]?.value {
                    login(emailValue, passwordValue)
                }
            }
        }
    }
}


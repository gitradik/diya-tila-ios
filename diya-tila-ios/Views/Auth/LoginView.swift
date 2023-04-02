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
    let logIn: ((_ email: String, _ passwd: String) -> Void)?
    
    @State private var email: String = ""
    @State private var passwd: String = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $passwd)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                if let fn = logIn {
                    fn(email, passwd)
                }
            }) {
                Text("Sign in")
                    .padding(12)
                    .border(.cyan)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(.cyan)
            .cornerRadius(10)
        }
    }
}


//
//  RigisterView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct SignupView: View {
    let signUp: ((_ name: String, _ email: String, _ passwd: String) -> Void)?
    
    @State private var name: String = ""
    @State private var passwd: String = ""
    @State private var email: String = ""
    
    var body: some View {
        VStack {
            TextField("Full Name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $passwd)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                if let fn = signUp {
                    fn(name, email, passwd)
                }
            }){
                Text("Register")
                    .padding(12)
                    .border(.cyan)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(.cyan)
            .cornerRadius(10)
        }
        .scenePadding(.top)
        .scenePadding(.horizontal)
    }
}

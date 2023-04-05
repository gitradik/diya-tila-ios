//
//  DropdownView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 05.04.2023.
//

import SwiftUI

struct DropdownView: View {
    
    let choices = ["Choice 1", "Choice 2", "Choice 3"]
    @State private var selectedChoice: String?
    @State private var isShowingChoices = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.isShowingChoices = true
            }) {
                Text("Select a Choice")
            }
            .sheet(isPresented: $isShowingChoices, content: {
                NavigationView {
                    List(choices, id: \.self) { choice in
                        Button(action: {
                            self.selectedChoice = choice
                            self.isShowingChoices = false
                        }) {
                            Text(choice)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Image(systemName: "xmark").onTapGesture {
                                self.isShowingChoices = false
                            }
                        }
                    }
                    .navigationBarTitle("Choose a Choice")
                }
            })
            if let selectedChoice = selectedChoice {
                Text("You selected: \(selectedChoice)")
            }
        }
    }
}


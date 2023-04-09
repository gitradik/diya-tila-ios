//
//  PopoverTopContentView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 06.04.2023.
//

import SwiftUI

struct PopoverTitleAndCloseView: View {
    let title: String
    @Binding var isPresent: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer().maxWidth(50)
                Spacer().overlay(Group {
                    Text(title)
                }, alignment: .center)
                Spacer().overlay(Group {
                    VStack {
                        Button(action: {
                            isPresent.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                        }).foregroundColor(.black)
                    }
                }, alignment: .trailing).maxWidth(50)
            }
            .scenePadding(.vertical)
        }
        .padding(.top)
        .padding(.horizontal)
    }
}

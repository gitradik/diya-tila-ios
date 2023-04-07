//
//  PopoverTopContentView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 06.04.2023.
//

import SwiftUI

struct PopoverTitleAndCloseView: View {
    let title: String
    @Binding var isShow: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 50)
                Spacer().overlay(Group {
                    Text(title)
                }, alignment: .center)
                Spacer().overlay(Group {
                    VStack {
                        Button(action: {
                            isShow.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                        }).foregroundColor(.black)
                    }
                }, alignment: .trailing)
                .frame(width: 50)
            }
            .scenePadding(.vertical)
        }
        .padding(.top, 5)
        .padding(.leading, 7)
        .padding(.trailing, 7)
    }
}

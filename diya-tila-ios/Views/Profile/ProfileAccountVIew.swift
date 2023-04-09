//
//  ProfileAccountVIew.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

struct ProfileAccountView: View {
    let list: [User]
    let selected: User
    let select: (User) -> Void
    let addAccount: () -> Void
    
    @State private var isPresent: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(selected.fullName!)
                Image("ArrowDown")
                    .resizable()
                    .frame(width: 18, height: 18)
            }.onTapGesture {
                self.isPresent.toggle()
            }
            .popover(isPresented: $isPresent) {
                PopoverTitleAndCloseView(title: "Change account", isPresent: self.$isPresent)
                
                VStack(alignment: .leading) {
                    ForEach(0..<list.count) { index in
                        HStack {
                            if list[index].id == selected.id, list.count > 1 {
                                Image(systemName: "checkmark")
                            }
                            PhotoURLLoadingView(imageURL: list[index].photoURL!, width: 40, height: 40)
                            Text("\(list[index].fullName!)")
                        }.onTapGesture {
                            select(list[index])
                        }
                    }
                    HStack {
                        Image("AddNew")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                        Button("Add account") {
                            self.isPresent.toggle()
                            addAccount()
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}



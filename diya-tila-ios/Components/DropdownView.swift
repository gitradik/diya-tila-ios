import SwiftUI

struct DropdownView<T>: View {
    let choices: [T]
    let title: String
    let mapItemView: (T) -> Text
    let mapTitleView: (T) -> Text

    @State private var selectedChoice: T?
    @State private var isShowingPopover = false

    var body: some View {
        VStack {
            Button(action: {
                self.isShowingPopover = true
            }) {
                if let choice = selectedChoice {
                    mapTitleView(choice)
                } else {
                    Text("Select a choice")
                }
            }
            .popover(isPresented: $isShowingPopover) {
                VStack {
                    HStack {
                        Spacer().frame(width: 50)
                        Spacer().overlay(Group {
                            Text(title)
                        }, alignment: .center)
                        Spacer().overlay(Group {
                            VStack {
                                Button(action: {
                                    self.isShowingPopover = false
                                }, label: {
                                    Image(systemName: "xmark")
                                }).foregroundColor(.black)
                            }
                        }, alignment: .trailing)
                        .frame(width: 50)
                    }
                    .scenePadding(.vertical)

                    VStack(alignment: .leading) {
                        ForEach(0..<choices.count) { index in
                            Button(action: {
                                selectedChoice = choices[index]
                                self.isShowingPopover = false
                            }) {
                                mapItemView(choices[index])
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                .padding(.top, 3)
                .padding(.leading, 7)
                .padding(.trailing, 7)
                .background(Color.white) // Set VStack background color to white
            }
        }.onAppear {
            selectedChoice = choices[0]
        }
    }
}

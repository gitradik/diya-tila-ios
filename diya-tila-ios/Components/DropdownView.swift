import SwiftUI

struct DropdownView<T>: View {
    let choices: [T]
    let title: String
    let mapItemView: (T, Int) -> Text
    let mapTitleView: (T) -> Text
    let selectChange: (T) -> Void

    @State private var selectedChoice: T?
    @State private var show = false

    var body: some View {
        VStack {
            Button(action: {
                self.show = true
            }) {
                if let choice = selectedChoice {
                    mapTitleView(choice)
                } else {
                    Text("Select a choice")
                }
            }
            .popover(isPresented: $show) {
                    PopoverTopContentView(title: title, isShow: self.$show)
                
                    VStack(alignment: .leading) {
                        ForEach(0..<choices.count) { index in
                            Button(action: {
                                selectedChoice = choices[index]
                                self.show = false
                                selectChange(selectedChoice!)
                            }) {
                                mapItemView(choices[index], index)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                
                    Spacer()
            }
        }.onAppear {
            selectedChoice = choices[0]
        }
    }
}

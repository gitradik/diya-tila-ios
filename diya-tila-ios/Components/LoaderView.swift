//
//  LoaderView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 06.04.2023.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        LottieAnimationWithFile(lottieFile: "Wait", loopMode: .loop)
            .aspectRatio(contentMode: .fill)
            .frame(width: 230, height: 230)
    }
}

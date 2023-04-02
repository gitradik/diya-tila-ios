//
//  LottieView.swift
//  SwiftUITest
//
//  Created by Rodion Malakhov on 30.03.2023.
//

import SwiftUI
import Lottie

struct LottieAnimationWithFile: UIViewRepresentable {
    
    var lottieFile: String
    var loopMode: LottieLoopMode
    var animationView = LottieAnimationView()
    
    init(lottieFile: String, loopMode: LottieLoopMode) {
        self.lottieFile = Bundle.main.path(forResource: lottieFile, ofType: "json")!
        self.loopMode = loopMode
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieAnimationWithFile>) -> UIView {
        let view = UIView()
        
        animationView.animation = LottieAnimation.filepath(lottieFile)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieAnimationWithFile>) {
        animationView.play()
    }
}

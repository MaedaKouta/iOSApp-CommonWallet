//
//  Flip.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/04.
//

import Foundation
import SwiftUI

struct Flip<Front: View, Back: View>: View {
    var isFront: Bool
    @State var canShowFrontView: Bool
    let duration: Double
    let front: () -> Front
    let back: () -> Back

    init(isFront: Bool,
         duration: Double = 1.0,
         @ViewBuilder front: @escaping () -> Front,
         @ViewBuilder back: @escaping () -> Back) {
        self.isFront = isFront
        self._canShowFrontView = State(initialValue: isFront)
        self.duration = duration
        self.front = front
        self.back = back
    }

    var body: some View {
        ZStack {
            if self.canShowFrontView {
                front()
            }
            else {
                back()
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
            }
        }
        .onChange(of: isFront, perform: {
            value in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration/2.0) {
                self.canShowFrontView = value
            }
        })
        .animation(nil)
        .rotation3DEffect(isFront ? Angle(degrees: 0): Angle(degrees: -180), axis: (x: CGFloat(10), y: CGFloat(0), z: CGFloat(0)))
        .animation(.easeInOut(duration: duration))
    }
}

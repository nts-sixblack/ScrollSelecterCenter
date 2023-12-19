//
//  ContentView.swift
//  ScrollSelecter
//
//  Created by Thanh Sau on 19/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentSelecter: Int = 0
    @State var visibleIndex: Set<Int> = [0]
    
    let coordinateSpaceName: String = "scrollView"
    let itemWidth: CGFloat = 100
    
    var body: some View {
        VStack {
            GeometryReader(content: { outerProxy in
                ScrollViewReader(content: { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0...10, id: \.self) { index in
                                Circle()
                                    .frame(width: itemWidth)
                                    .foregroundColor(.blue)
                                    .overlay {
                                        Circle()
                                            .stroke(currentSelecter == index ? .black : .clear, lineWidth: 2)
                                    }
                                    .background(
                                        GeometryReader(content: { innerProxy in
                                            Color.clear
                                                .onChange(of: innerProxy.frame(in: .named(self.coordinateSpaceName))) { itemPosition in
                                                    if isCenter(innerRect: itemPosition, outerProxy: outerProxy) {
                                                        currentSelecter = index
                                                    }
                                                }
                                        })
                                    )
                            }
                        }
                        .padding(.horizontal, outerProxy.size.width * 0.5 - itemWidth/2)
                    }
                    .coordinateSpace(.named(self.coordinateSpaceName))
                })
            })
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func isCenter(innerRect:CGRect, outerProxy: GeometryProxy) -> Bool {
        let innerOrigin = innerRect.origin.x
        let imageWidth = innerRect.width
        let scrollOrigin = outerProxy.frame(in: .global).origin.x
        let scrollWidth = outerProxy.size.width
        let centerPosition = scrollWidth/2
        print(innerOrigin) /// 146.5
        print(imageWidth) /// 100 -> 246.5
//        print(scrollOrigin) /// 196.5
        print(scrollWidth)
        
        if centerPosition > innerOrigin && centerPosition < innerOrigin+imageWidth {
            return true
        }
        
        return false
    }
}

#Preview {
    ContentView()
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

//
//  Home.swift
//  DotInversion
//
//  Created by Ajay Gupta on 10/28/21.
//

import SwiftUI

struct Home: View {
    
    // CurrentState
    @State var dotState: DotState = .normal
    // Scale Value
    @State var dotScale: CGFloat = 1
    // Rotation
    @State var dotRotation: Double = 0
    
    var body: some View {
        ZStack{
            ZStack{
                //BgColor Changing based on dotState
                (dotState == .normal ? Color("Gold"): Color("Grey"))
                //changing view based on state
                if dotState != .normal {
                    MinimisedView()
                } else {
                    ExpandedView()
                }
            }
            .animation(.none, value: dotState)
            
            
            Rectangle()
                .fill(dotState != .normal ? Color("Gold"): Color("Grey"))
                .overlay(
                    ZStack{
                        //changing view based on state
                        if dotState == .normal {
                            MinimisedView()
                        } else {
                            ExpandedView()
                        }
                    }
                )
                .animation(.none, value: dotState)
            //Masking the view with circle to create dot inversion animation
                .mask(
                    GeometryReader{proxy in
                        
                        Circle()
                        //As we increase scale, content will turn to black
                            .frame(width: 100, height: 100)
                            .scaleEffect(dotScale)
                            .rotation3DEffect(.init(degrees: dotRotation),
                                              axis: (x:0 ,y:1,z:0),
                                              anchorZ: dotState == .flipped ? -10: 10,
                                              perspective: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .offset(y: -60)
                    }
                )
            Circle()
            //As we increase scale, content will turn to black
                .foregroundColor(Color.black.opacity(0.01))
                .frame(width: 100, height: 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: -60)
                .onTapGesture(perform:{
                    if dotState == .flipped {
                        //Reversing else condition effect
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                            //1.5/2 = 7
                            withAnimation(.linear(duration: 0.7)){
                                dotScale = 1
                                dotState = .normal
                            }
                        }
                        
                        withAnimation(.linear(duration: 1.5)){
                            dotRotation = 0
                            dotScale = 8
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.725) {
                            //1.5/2 = 7
                            withAnimation(.linear(duration: 0.7)){
                                dotScale = 1
                                dotState = .flipped
                            }
                        }
                        
                        withAnimation(.linear(duration: 1.5)){
                            dotRotation = -180
                            dotScale = 8
                        }
                    }
                })
        }
        .ignoresSafeArea()
    }
    
    //Expanded and Minimised Views
    @ViewBuilder
    func ExpandedView() -> some View {
        VStack(spacing: 10) {
            Image(systemName: "ipad")
                .font(.system(size: 148))
            Text("iPad")
                .font(.system(size: 38).bold())
        }
        .foregroundColor(.white)
    }
    
    @ViewBuilder
    func MinimisedView() -> some View {
        VStack(spacing: 10) {
            Image(systemName: "applewatch")
                .font(.system(size: 148))
            Text("Apple Watch")
                .font(.system(size: 38).bold())
        }
        .foregroundColor(.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//Enum for current Dot State

enum DotState {
    case normal
    case flipped
}

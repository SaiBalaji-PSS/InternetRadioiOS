//
//  CustomPlayerButton.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 11/08/26.
//

import SwiftUI

struct CustomPlayerButton: View {
   
   
    let buttonImageName: String
    let xOffset: CGFloat
    var buttonPressed: (() -> (Void))?
    var body: some View {
        Button {
            buttonPressed?()
        } label: {
            ZStack{
                Circle()
                    .fill(.white)
                    .glassEffect(.regular.interactive(),in: .circle)
                    .frame(width: 75,height: 75)
                    .shadow(radius: 6.0,x:1,y:1)
                Image(systemName: buttonImageName)
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 30,height: 30)
                    .offset(x:xOffset)
                
            }
        }
    }
}

#Preview {
    CustomPlayerButton(buttonImageName: "play.fill",xOffset: 6.0)
}

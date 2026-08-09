//
//  RadioCellView.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 06/08/26.
//

import SwiftUI

struct RadioCellView: View {
    let radioItem: RadioStation
    
    var body: some View {
        VStack(alignment:.center){
            AsyncImage(url: URL(string: radioItem.favicon ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100,height: 100)
                
            } placeholder: {
                Image(systemName: "radio")
                    .resizable()
                    .tint(.green)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100,height: 100)
            }
            Text(radioItem.name?.uppercased() ?? "N/A")
                .font(.system(size: 12.0))
                .lineLimit(1)
                .bold()
                
        }.frame(width: 120).padding(2).overlay {
            RoundedRectangle(cornerRadius: 6.0).stroke(Color.gray, lineWidth: 1.0)
        }
    }
}

//#Preview {
//    RadioCellView()
//}

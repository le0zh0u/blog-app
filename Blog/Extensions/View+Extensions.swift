//
//  View+Extensions.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import Foundation
import SwiftUI

extension View{
    func embedInNavigationView() -> some View {
        NavigationView{ self }
    }
    
    func embedInSheetView(viewTitle: String, closeAction: @escaping () -> Void) -> some View {
        VStack {
            HStack{
                Text("").frame(width: 20, height: 20, alignment: .center)
                    .padding()
                Spacer()
                Text(viewTitle)
                Spacer()
                Button(action: {
                    closeAction()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }).padding()
            }
            Spacer()
            self
        }
    }
}

//
//  ConfigView.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/17.
//

import SwiftUI

struct ConfigView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            
            Text("Config")
            
        }
        .navigationBarTitle(Text("Config"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
        }))
        .embedInNavigationView()
        
        
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}

//
//  AddPostView.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import SwiftUI

struct AddPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var addPostVM : AddPostViewModel

    init(addPostVM: AddPostViewModel) {
        self.addPostVM = addPostVM
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle")
                }).padding()
            }
            VStack{
    //            Text("MaxPriority: \(addPostVM.maxPriority)")
                TextField("Title", text: $addPostVM.postTitle)
                TextField("Body", text: $addPostVM.postBody)
                Button("Save"){
                    let saved = self.addPostVM.savePost()
                    if saved {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }.padding()
            Spacer()
        }
        
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        let addPostVM = AddPostViewModel(maxPriority:Int16(0))
        return AddPostView(addPostVM: addPostVM)
    }
}

//
//  PostDetailView.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import SwiftUI

struct PostDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let post: PostViewModel
    @ObservedObject private var updateVM = UpdateViewModel()
    @State private var postViewState = PostViewState()
    
    
    var body: some View {
        VStack {
            VStack{
                TextField(post.title, text: $postViewState.title)
                TextField(post.body, text: $postViewState.body)
            }.padding()
            
            Button("Update") {
                self.postViewState.postId = self.post.postId
                
                self.updateVM.update(postViewState: self.postViewState)
                
                presentationMode.wrappedValue.dismiss()
            }
            
            .onAppear(){
                self.postViewState.title = self.post.title
                self.postViewState.body = self.post.body
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let post = Post()
        
        return PostDetailView(post: PostViewModel(post: post))
    }
}

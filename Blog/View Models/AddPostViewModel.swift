//
//  AddPostViewModel.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import Foundation

class AddPostViewModel:ObservableObject {
    
    var postTitle: String = ""
    
    var postBody:String = ""
    
    var maxPriority: Int16
    
    init(maxPriority: Int16) {
        self.maxPriority = maxPriority
    }
    
    private var post: Post {
        let post = Post(context: PersistenceController.shared.container.viewContext)
        post.postId = UUID()
        post.title = postTitle
        post.body = postBody
        post.priority = maxPriority + 1
        return post
    }
    
    
    func savePost() -> Bool {
        
        do {
            try PersistenceController.shared.savePost(post: post)
            return true
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
}

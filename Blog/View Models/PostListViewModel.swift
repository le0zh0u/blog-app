//
//  PostListViewModel.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import Foundation

class PostListViewModel: ObservableObject {
    
    @Published var posts = [PostViewModel]()
    
    func fetchAllPosts() {
        DispatchQueue.main.async {
            self.posts = PersistenceController.shared.getAllPosts().map(PostViewModel.init)
        }
    }
    
    func deletePost(_ postVM: PostViewModel) -> Bool {
        var deleted = false
        do{
            try PersistenceController.shared.deletePost(post: postVM.post)
            deleted = true
        } catch {
            print(error.localizedDescription)
        }
        
        return deleted
    }
    
}

class PostViewModel {
    var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var postId: String {
        guard let postId = self.post.postId else {
            return ""
        }
        
        return postId.uuidString
    }
    
    var title: String {
        self.post.title ?? ""
    }
    
    var body : String {
        self.post.body ?? ""
    }
    
    var published: Bool {
        self.post.isPublished
    }
    
}

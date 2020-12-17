//
//  PostListViewModel.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import Foundation

class PostListViewModel: ObservableObject {
    
    @Published var posts = [PostViewModel]()
    
    @Published var maxPriority: Int16 = 0
    
    func fetchAllPosts() {
        DispatchQueue.main.async {
            self.posts = PersistenceController.shared.getAllPosts().map(PostViewModel.init)
            self.maxPriority = self.posts.last?.priority ?? Int16(0)
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
    
    func movePost(source: Int, destination: Int) -> Bool {
        
        var postPriorityStates = [PostPriorityState]()
        var startIndex = 0
        var endIndex = 0
        var startPriority = Int16(0)
        var movePostPriorityState = PostPriorityState()
        movePostPriorityState.postId = posts[source].postId
        if source < destination {
            startIndex = source + 1
            endIndex = destination - 1
            startPriority = posts[source].priority
            
            while startIndex <= endIndex {
                var postPriorityState = PostPriorityState()
                postPriorityState.postId = posts[startIndex].postId
                postPriorityState.priority = startPriority
                postPriorityStates.append(postPriorityState)
                startPriority = startPriority + 1
                startIndex = startIndex + 1
            }
            movePostPriorityState.priority = startPriority
        } else if destination < source {
            startIndex = destination
            endIndex = source - 1
            startPriority = posts[destination].priority + 1
            
            while startIndex <= endIndex {
                var postPriorityState = PostPriorityState()
                postPriorityState.postId = posts[startIndex].postId
                postPriorityState.priority = startPriority
                postPriorityStates.append(postPriorityState)
                startPriority = startPriority + 1
                startIndex = startIndex + 1
            }
            movePostPriorityState.priority = posts[destination].priority
        }
        
       
        postPriorityStates.append(movePostPriorityState)
        
        let result = updatePostPriority(postPriorityStates: postPriorityStates)
        
        return result
        
    }
    
    func updatePostPriority(postPriorityStates: [PostPriorityState]) -> Bool{
        var updated = false
        for postPriorityState in postPriorityStates {
            do {
                try PersistenceController.shared.updatePostPriority(postId: postPriorityState.postId, priority: postPriorityState.priority)
                updated = true
            }catch {
                print(error.localizedDescription)
            }
        }
        return updated
    }
    
}

struct PostPriorityState {
    var postId : String = ""
    var priority : Int16 = 0
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
    
    var priority: Int16 {
        self.post.priority
    }
    
}

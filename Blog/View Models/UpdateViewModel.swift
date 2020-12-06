//
//  UpdateViewModel.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import Foundation

class UpdateViewModel: ObservableObject {
    
    func update(postViewState: PostViewState){
        
        do{
            try PersistenceController.shared.updatePost(postId: postViewState.postId, title: postViewState.title, body: postViewState.body)
        }catch{
            print(error.localizedDescription)
        }
    }
    
}

struct PostViewState {
    var postId : String = ""
    var title : String = ""
    var body : String = ""
    
}

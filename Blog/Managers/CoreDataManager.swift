//
//  CoreDataManager.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static func getAllPosts() ->[Post] {
        var posts = [Post]()
        
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        do{
            posts = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return posts
    }
    
}

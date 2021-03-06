//
//  Persistence.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Post(context: viewContext)
            newItem.title = "title"
            newItem.body = "body"
            newItem.isPublished = true
            newItem.postId = UUID()
            newItem.priority = 0
//            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Blog")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            print(storeDescription.url)
            
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK - getAllPosts
    func getAllPosts() ->[Post] {
        var posts = [Post]()
        
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do{
            posts = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return posts
    }
    
    func savePost(post: Post) throws {
        self.container.viewContext.insert(post)
        try save()
    }
    
    func getByPostId(postId: UUID) throws -> Post? {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "postId = %@", (postId.uuidString))
        
        let results = try self.container.viewContext.fetch(request)
        
        return results.first
    }
    
    func updatePost(postId: String, title:String, body:String) throws {
        
        let postToBeUpdated = try getByPostId(postId: UUID(uuidString: postId)!)
        
        if let postToBeUpdated = postToBeUpdated {
            postToBeUpdated.title = title
            postToBeUpdated.body = body
            
            try save()
        }
    }
    
    func updatePostPriority(postId: String, priority: Int16) throws {
        let postToBeUpdated = try getByPostId(postId: UUID(uuidString: postId)!)
        
        if let postToBeUpdated = postToBeUpdated {
            postToBeUpdated.priority = priority
            
            try save()
        }
    }
    
    private func save() throws {
        try self.container.viewContext.save()
    }
    
    func deletePost(post: Post) throws {
        self.container.viewContext.delete(post)
        try save()
    }
}

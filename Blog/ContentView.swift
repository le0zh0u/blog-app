//
//  ContentView.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    @ObservedObject private var postListVM = PostListViewModel()
    @State private var isPresented: Bool = false
    
    var body: some View {
            VStack {
                List{
                    ForEach(postListVM.posts, id: \.postId){ post in
                        NavigationLink(
                            destination: PostDetailView(post: post),
                            label: {
                                Text("\(post.title) - \(post.priority)")
                            })
                    }
                    .onDelete(perform: { indexSet in
                        self.deleetPost(at: indexSet)
                    })
                    .onMove(perform: movePost)
                    .listRowBackground(Color.white)
                }
                
                .onAppear(){
                    self.postListVM.fetchAllPosts()
                }
                .sheet(isPresented: $isPresented, onDismiss: {
                    self.postListVM.fetchAllPosts()
                }, content: {
                    let addPostVM = AddPostViewModel(maxPriority:Int16(self.postListVM.maxPriority))
                    AddPostView(addPostVM: addPostVM)
                })
            }
//            .navigationBarTitle("Posts")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add Post"){
                self.isPresented = true
            })
            .embedInNavigationView()
        
    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    //
    private func deleetPost(at indexSet: IndexSet) {
        var deleted = false
        
        indexSet.forEach { (index) in
            let post = postListVM.posts[index]
            deleted = postListVM.deletePost(post)
        }
        
        if deleted {
            postListVM.fetchAllPosts()
        }
        
    }
    
    private func movePost(indexSet: IndexSet, destination: Int){
        let source = indexSet.first!
        
        if source == destination {
            return
        }
        
        let moved = postListVM.movePost(source: source, destination: destination)
        if moved {
            postListVM.fetchAllPosts()
        }
        
    }
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

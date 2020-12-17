//
//  ContentView.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import SwiftUI
import CoreData
import MobileCoreServices

enum ActiveSheet: Identifiable {
    case addView, configView
    
    var id: Int {
        hashValue
    }
}

struct ContentView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    @ObservedObject private var postListVM = PostListViewModel()
    @State private var activeSheet: ActiveSheet?
    @State private var editMode = EditMode.inactive
    @State private var addPostVM: AddPostViewModel = AddPostViewModel(maxPriority:0)
    
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
                .onInsert(of: [String(kUTTypeURL)], perform:onInsert)
                .onDelete(perform: { indexSet in
                    self.deleetPost(at: indexSet)
                })
                .onMove(perform: movePost)
                .listRowBackground(Color.white)
            }
            .onAppear(){
                self.postListVM.fetchAllPosts()
            }
            .sheet(item: $activeSheet, onDismiss: {
                self.postListVM.fetchAllPosts()
                self.addPostVM = AddPostViewModel(maxPriority:Int16(self.postListVM.maxPriority))
            }, content: { (item) in
                // Multi Sheet
                switch item {
                case .addView:
                    AddPostView(addPostVM: self.addPostVM)
                case .configView:
                    ConfigView()
                }
            })
        }
        .navigationBarTitle(Text("Posts"))
        .navigationBarItems(leading: configButton, trailing:
                                HStack{
                                    EditButton()
                                    self.addButton
                                }
        )
        .environment(\.editMode, $editMode)
        .embedInNavigationView()
        
    }
    
    private var addButton: some View{
        switch editMode {
        case .inactive:
            return AnyView(Button(action: {
                self.addPostVM.maxPriority = Int16(self.postListVM.maxPriority)
                self.activeSheet = .addView
            }, label: {
                Image(systemName: "plus.circle")
            }))
        default:
            return AnyView(EmptyView())
        }
    }
    
    private var configButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: {
                self.activeSheet = .configView
            }, label: {
                Image(systemName: "slider.horizontal.3")
            }))
        default:
            return AnyView(EmptyView())
        }
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
    
    private func onInsert(at offset:Int, itemProvider: [NSItemProvider]){
        
        for provider in itemProvider {
            // load provider
            if provider.canLoadObject(ofClass: URL.self){
                //
                _ = provider.loadObject(ofClass: URL.self, completionHandler: { (url, error) in
                    // 3.
                    self.addPostVM = AddPostViewModel(maxPriority:Int16(self.postListVM.maxPriority))
                    self.addPostVM.postBody = url?.absoluteString ?? ""
                    
                    self.activeSheet = .addView
                    
                })
            }
        }
        
    }
    
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

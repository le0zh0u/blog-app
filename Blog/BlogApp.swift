//
//  BlogApp.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import SwiftUI

@main
struct BlogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

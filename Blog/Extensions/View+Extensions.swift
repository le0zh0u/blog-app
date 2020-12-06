//
//  View+Extensions.swift
//  Blog
//
//  Created by 周椿杰 on 2020/12/6.
//

import Foundation
import SwiftUI

extension View{
    
    func embedInNavigationView() -> some View {
        NavigationView{ self }
    }
}

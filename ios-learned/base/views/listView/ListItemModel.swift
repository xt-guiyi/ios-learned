//
//  ListItemModel.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import Foundation

struct ListItemModel {
    let title: String
    let subtitle: String
    let action: (() -> Void)?
    
    init(title: String, subtitle: String, action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
}
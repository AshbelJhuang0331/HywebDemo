//
//  JSONDecoder+Additions.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/7.
//

import Foundation
import CoreData

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}

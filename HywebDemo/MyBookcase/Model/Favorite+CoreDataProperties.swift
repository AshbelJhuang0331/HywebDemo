//
//  Favorite+CoreDataProperties.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/9.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var uuid: Int64

}

extension Favorite : Identifiable {

}

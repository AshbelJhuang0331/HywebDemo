//
//  Book+CoreDataProperties.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/9.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var coverUrl: String?
    @NSManaged public var publishDate: String?
    @NSManaged public var publisher: String?
    @NSManaged public var title: String?
    @NSManaged public var uuid: Int64

}

extension Book : Identifiable {

}

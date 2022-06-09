//
//  Book+CoreDataClass.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/9.
//
//

import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey { case uuid, title, coverUrl, publishDate, publisher, author }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("NSManagedObjectContext is missing!")
        }
        let entity = NSEntityDescription.entity(forEntityName: String(describing: "Book"), in: context)!
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = Int64(try values.decode(Int.self, forKey: .uuid))
        title = try values.decode(String.self, forKey: .title)
        coverUrl = try values.decode(String.self, forKey: .coverUrl)
        publishDate = try values.decode(String.self, forKey: .publishDate)
        publisher = try values.decode(String.self, forKey: .publisher)
        author = try values.decode(String.self, forKey: .author)
    }
}

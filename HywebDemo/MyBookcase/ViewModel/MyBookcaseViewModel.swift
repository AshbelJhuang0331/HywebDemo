//
//  MyBookcaseViewModel.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/7.
//

import Foundation

protocol MyBookcaseViewModelDelegate: AnyObject {
    func requestingMyBookcase()
    func requestMyBookcaseSucceed()
    func requestMyBookcaseFailed(error: Error)

    func endedTogglingFavoriteWithIndex(_ index: Int)
}

class MyBookcaseViewModel {
    
    // MARK: - Variables and Constants
    
    weak var delegate: MyBookcaseViewModelDelegate?
    let api = API()
    var books: [Book] = []
    
    // MARK: - Public Methods
    
    func requestMyBookcase() {
        delegate?.requestingMyBookcase()
        api.fetchMyBookcase { [weak self] (data) in
            do {
                CoreDataStack.sharedInstance.deleteAllBooks()
                let decoder = JSONDecoder(context: CoreDataStack.sharedInstance.persistentContainer.viewContext)
                self?.books = try decoder.decode([Book].self, from: data)
                CoreDataStack.sharedInstance.saveContext()
                self?.delegate?.requestMyBookcaseSucceed()
            } catch {
                self?.delegate?.requestMyBookcaseFailed(error: error)
                self?.requestMyBookcaseFromCoreData()
            }
        } fail: { [weak self] (error) in
            self?.delegate?.requestMyBookcaseFailed(error: error)
            self?.requestMyBookcaseFromCoreData()
        }
    }
    
    func toggleFavoriteWithIndex(_ index: Int) {
        if index < self.books.count {
            let book = self.books[index]
            let uuid = book.uuid
            if CoreDataStack.sharedInstance.fetchFavoriteByUUID(uuid) != nil {
                CoreDataStack.sharedInstance.deleteFavoriteByUUID(uuid)
            } else {
                CoreDataStack.sharedInstance.insertFavoriteByUUID(uuid)
            }
            self.delegate?.endedTogglingFavoriteWithIndex(index)
        }
    }
    
    // MARK: - Private Methods
    
    private func requestMyBookcaseFromCoreData() {
        do {
            self.books = try CoreDataStack.sharedInstance.fetchAllBooks()
            self.delegate?.requestMyBookcaseSucceed()
        } catch {
            self.delegate?.requestMyBookcaseFailed(error: error)
        }
    }
}

//
//  MyBookcaseCell.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/7.
//

import UIKit
import SDWebImage

protocol MyBookcaseCellDelegate: AnyObject {
    func myBookCaseCell(cell: MyBookcaseCell, didTapFavoriteButton: UIButton)
}

class MyBookcaseCell: UICollectionViewCell {

    // MARK: Variables and Constants
    
    private enum FavoriteImageName {
        static let unfilled = "ic_favorite"
        static let filled = "ic_favorite_filled"
    }
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var bookNameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    weak var delegate: MyBookcaseCellDelegate?
    
    // MARK: Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.coverImageView.image = nil
        self.bookNameLabel.text = ""
        self.favoriteButton.setImage(UIImage(named: FavoriteImageName.unfilled), for: .normal)
    }
    
    // MARK: - IBActions
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        self.delegate?.myBookCaseCell(cell: self, didTapFavoriteButton: sender)
    }
    
    // MARK: - Public Method
    
    func configureWithBook(_ book: Book) {
        if let coverUrl = book.coverUrl, coverUrl.count > 0 {
            self.coverImageView.sd_setImage(with: URL(string: coverUrl), completed: nil)
        }
        self.bookNameLabel.text = book.title ?? ""
        let favorited = CoreDataStack.sharedInstance.fetchFavoriteByUUID(book.uuid) != nil
        self.configureFavoriteButton(favorited: favorited)
    }
    
    func configureFavoriteButton(favorited: Bool) {
        let imageNamed = favorited ? FavoriteImageName.filled : FavoriteImageName.unfilled
        self.favoriteButton.setImage(UIImage(named: imageNamed), for: .normal)
    }
}

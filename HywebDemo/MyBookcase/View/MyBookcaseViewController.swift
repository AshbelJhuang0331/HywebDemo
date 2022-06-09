//
//  MyBookcaseViewController.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/7.
//

import UIKit

private let reuseIdentifier = "Cell"

class MyBookcaseViewController: UIViewController {
    
    // MARK: - Variables and Constants
    
    @IBOutlet weak var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    let viewModel = MyBookcaseViewModel()
    
    private enum CellConfig {
        static let itemHorizontalSpace: CGFloat = 20
        static let itemCountPerRow: CGFloat = 3
        static let itemImageHeightWidthPortion: CGFloat = 1.4
        static let itemImageAndLabelSpace: CGFloat = 5
        static let itemLabelHeight: CGFloat = 40
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        setupData()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationItem.title = "我的書櫃"
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        collectionView.register(UINib(nibName: String(describing: MyBookcaseCell.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func setupData() {
        viewModel.requestMyBookcase()
        viewModel.delegate = self
    }
    
    @objc private func pullToRefresh() {
        viewModel.requestMyBookcase()
    }
}

extension MyBookcaseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.size.width - CellConfig.itemHorizontalSpace * (CellConfig.itemCountPerRow + 1)) / CellConfig.itemCountPerRow
        let cellHeight = cellWidth * CellConfig.itemImageHeightWidthPortion + CellConfig.itemImageAndLabelSpace + CellConfig.itemLabelHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MyBookcaseViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyBookcaseCell
        if indexPath.item < self.viewModel.books.count {
            cell.delegate = self
            let book = self.viewModel.books[indexPath.item]
            cell.configureWithBook(book)
        }
        return cell
    }
}

extension MyBookcaseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < self.viewModel.books.count {
            let book = self.viewModel.books[indexPath.item]
            print(book)
        }
    }
}

extension MyBookcaseViewController: MyBookcaseCellDelegate {
    func myBookCaseCell(cell: MyBookcaseCell, didTapFavoriteButton: UIButton) {
        if let indexPath = collectionView.indexPath(for: cell),
           indexPath.item < self.viewModel.books.count {
            self.viewModel.toggleFavoriteWithIndex(indexPath.item)
        }
    }
}

extension MyBookcaseViewController: MyBookcaseViewModelDelegate {
    func requestingMyBookcase() {
        // Maybe do some custom loading?
    }
    
    func requestMyBookcaseSucceed() {
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    func requestMyBookcaseFailed(error: Error) {
        refreshControl.endRefreshing()
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(confirm)
        self.present(alert, animated: true) {
            
        }
    }
    
    func endedTogglingFavoriteWithIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.reloadItems(at: [indexPath])
    }
}

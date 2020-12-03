//
//  StoryCollectionView.swift
//  Forex Converter
//
//  Created by Idan Moshe on 19/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

protocol StoryCollectionViewDelegate: class {
    func storyCollectionView(_ storyCollectionView: StoryCollectionView, didSelect currency: Currency)
}

class StoryCollectionView: StoryboardCustomXibView {
    
    weak var delegate: StoryCollectionViewDelegate?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var storyViewModel = StoryViewModel()
    private var observerHandler: (Currency) -> Void = { arg in }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView.register(UINib(nibName: StoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        
        // Register observer to notify on data source updates
        self.storyViewModel.registerForUpdates { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        // 1. Add Israeli New Shekel at index[0]
        // 2. Scroll & select index[0]
        
        // Scroll to current Hebrew month
//        if let index = self.currencies.firstIndex(of: Date.localizedCurrentMonth) {
//            DispatchQueue.main.async {
//                let indexPath = IndexPath(item: index, section: 0)
//                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//
//                self.showEventsForMonth(at: indexPath)
//            }
//        }
    }
    
    // MARK: - General methods
    
    func appendCurrencies(_ currencies: [Currency]) {
        self.storyViewModel.currencies.append(contentsOf: currencies)
    }
    
    func registerForUpdates(completionHandler: @escaping (Currency) -> Void) {
        self.observerHandler = completionHandler
    }
    
    func getSelectedCurrency() -> Currency {
        self.storyViewModel.getSelectedCurrency()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
//    private func showEventsForMonth(at indexPath: IndexPath) {
//        self.storyViewModel.selectedIndexPath = indexPath
//        
//        
//        
//        // Circle the selected month with green color
//        for visibleIndexPath: IndexPath in collectionView.indexPathsForVisibleItems {
//            if let cell = collectionView.cellForItem(at: visibleIndexPath) as? StoryCollectionViewCell {
//                if visibleIndexPath.item == indexPath.item {
//                    cell.currentMonthView.isHidden = false
//                } else {
//                    cell.currentMonthView.isHidden = true
//                }
//            }
//        }
//                
//        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        
//        let selectedCurrency: Currency = self.storyViewModel.currencies[indexPath.item]
//        self.delegate?.storyCollectionView(self, didSelect: selectedCurrency)
//    }

}

// MARK: - UICollectionViewDataSource

extension StoryCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storyViewModel.currencies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
        let currency: Currency = self.storyViewModel.currencies[indexPath.item]
        let isSelectedCurrency: Bool = (self.storyViewModel.selectedIndexPath.item == indexPath.item)
        cell.configure(currency: currency, isSelectedCurrency: isSelectedCurrency)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension StoryCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.storyViewModel.selectedIndexPath = indexPath
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.observerHandler(self.storyViewModel.currencies[indexPath.item])
        }
    }
    
}

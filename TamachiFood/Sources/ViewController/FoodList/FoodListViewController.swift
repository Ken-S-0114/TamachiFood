//
//  FoodListViewController.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/14.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController {
    @IBOutlet weak var foodSearchBar: UISearchBar!
    @IBOutlet weak var evaluationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var foodCollectionView: UICollectionView!
//
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.foodCollectionView.delegate = self
//        self.foodCollectionView.dataSource = self
    }
}

//
// extension FoodListViewController: UICollectionViewDelegate {}
//
// extension FoodListViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
// }

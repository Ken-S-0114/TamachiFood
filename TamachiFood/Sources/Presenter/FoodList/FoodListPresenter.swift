//
//  FoodListPresenter.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/14.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Firebase
import Foundation

protocol FoodListPresenterProtocol: AnyObject {
    // func bindFoods(_ foods: [FoodFirebaseModel])
}

// class FoodListPresenter: FoodListPresenterProtocol {
//    var presenter: FoodListPresenterProtocol!
//    var DBRef: DatabaseReference!
//
//    init(presenter: FoodListPresenterProtocol) {
//        self.presenter = presenter
//        DBRef = Database.database().reference()
//    }
//
//    func fetchFoodsFromDatabase() {
//        let defaultPlace = DBRef.child("food")
//        defaultPlace.observe(.value) { (snap: DataSnapshot) in
//
//        self.presenter.bindFoods(<#T##foods: [FoodFirebaseModel]##[FoodFirebaseModel]#>)
//    }
//
// }

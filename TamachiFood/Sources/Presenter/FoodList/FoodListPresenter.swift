//
//  FoodListPresenter.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/14.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Firebase
import Foundation

// protocol FoodListPresenterProtocol: AnyObject {
//    func bindFoods(_ foods: [FoodModel])
// }
//
// class FoodListPresenter: FoodListPresenterProtocol {
//    var presenter: FoodListPresenterProtocol!
//    private var DBRef: DatabaseReference!
//
//    init(presenter: FoodListPresenterProtocol) {
//        self.presenter = presenter
//        DBRef = Database.database().reference()
//    }
//
//    func fetchFoodsFromDatabase() {
//        var foodsName: [String] = []
//        let defaultPlace = DBRef.child("food")
//        defaultPlace.observeSingleEvent(of: .value) { (snapshot) in
//            for folder in snapshot.children {
//                if let snap = folder as? DataSnapshot {
//                    foodsName.append(folder.foodName)
//                }
//            }
//        }
//        self.presenter.bindFoods(<#T##foods: [FoodFirebaseModel]##[FoodFirebaseModel]#>)
//    }
//
// }

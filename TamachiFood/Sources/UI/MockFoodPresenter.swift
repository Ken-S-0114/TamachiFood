//
//  MockFoodPresenter.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/14.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Foundation

protocol MockFoodPresenterProtocol: AnyObject {
    func bindFoods(_ foods: [FoodModel])
}

class MockFoodPresenter {
    var presenter: MockFoodPresenterProtocol!
    
    init(presenter: MockFoodPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getFoods() {
        let foods: [FoodModel] = [
            FoodModel(foodId: 0, foodName: "A", storeName: "A店", foodPrice: 1000),
            FoodModel(foodId: 1, foodName: "B", storeName: "B店", foodPrice: 2000),
            FoodModel(foodId: 2, foodName: "C", storeName: "C店", foodPrice: 3000),
            FoodModel(foodId: 3, foodName: "D", storeName: "D店", foodPrice: 1000),
            FoodModel(foodId: 4, foodName: "E", storeName: "E店", foodPrice: 2000),
            FoodModel(foodId: 5, foodName: "F", storeName: "F店", foodPrice: 3000),
            FoodModel(foodId: 6, foodName: "G", storeName: "G店", foodPrice: 3000),
            FoodModel(foodId: 7, foodName: "H", storeName: "H店", foodPrice: 1000),
            FoodModel(foodId: 8, foodName: "I", storeName: "I店", foodPrice: 2000),
            FoodModel(foodId: 9, foodName: "J", storeName: "J店", foodPrice: 3000)
        ]
        return presenter.bindFoods(foods)
    }
}

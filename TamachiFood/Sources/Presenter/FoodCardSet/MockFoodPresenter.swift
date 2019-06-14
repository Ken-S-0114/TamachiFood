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
    
    let mockModel: [FoodModel] = [
        FoodModel(foodId: 0, foodName: "カルボナーラ", storeName: "A店", foodPrice: 1000, evaluation: .deselect),
        FoodModel(foodId: 1, foodName: "焼肉定食", storeName: "B店", foodPrice: 2000, evaluation: .like),
        FoodModel(foodId: 2, foodName: "サーロインステーキ", storeName: "C店", foodPrice: 3000, evaluation: .deselect),
        FoodModel(foodId: 3, foodName: "D", storeName: "D店", foodPrice: 1000, evaluation: .deselect),
        FoodModel(foodId: 4, foodName: "E", storeName: "E店", foodPrice: 2000, evaluation: .deselect),
        FoodModel(foodId: 5, foodName: "F", storeName: "F店", foodPrice: 3000, evaluation: .deselect),
        FoodModel(foodId: 6, foodName: "G", storeName: "G店", foodPrice: 3000, evaluation: .deselect),
        FoodModel(foodId: 7, foodName: "H", storeName: "H店", foodPrice: 1000, evaluation: .deselect),
        FoodModel(foodId: 8, foodName: "I", storeName: "I店", foodPrice: 2000, evaluation: .deselect),
        FoodModel(foodId: 9, foodName: "J", storeName: "J店", foodPrice: 3000, evaluation: .deselect)
    ]
    
    init(presenter: MockFoodPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getFoods() {
        let foods: [FoodModel] = mockModel
        return presenter.bindFoods(foods)
    }
    
    func getFood(index: Int) -> FoodModel {
        return mockModel[index]
    }
}

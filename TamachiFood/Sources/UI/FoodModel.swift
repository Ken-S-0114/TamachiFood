//
//  FoodModel.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Foundation

struct FoodModel {
    let id: Int
    let foodName: String
    let storeName: String
    let foodPrice: Int
    let url: URL
}

extension FoodModel: Equatable {
    static func == (lhs: FoodModel, rhs: FoodModel) -> Bool {
        return lhs.id == rhs.id
    }
}

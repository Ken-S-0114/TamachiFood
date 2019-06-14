//
//  FoodModel.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Foundation

struct FoodModel {
    let foodId: Int
    let foodName: String
    let storeName: String
    let foodPrice: Int
    var evaluation: EvaluationStatus
    
    // let img: UIImage?
    // let url: URL?
}

enum EvaluationStatus {
    case like
    case hate
    case deselect
    
    func changeStatusToStr() -> String {
        switch self {
        case .like: return "好き"
        case .hate: return "嫌い"
        case .deselect: return "未選択"
        }
    }
    
    func newArriveToStr() -> String {
        switch self {
        case .deselect: return "新着"
        case .like, .hate: return "選択済"
        }
    }
}

extension FoodModel: Equatable {
    static func == (lhs: FoodModel, rhs: FoodModel) -> Bool {
        return lhs.foodId == rhs.foodId
    }
}

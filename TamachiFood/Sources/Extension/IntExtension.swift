//
//  IntExtension.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    // 決まった範囲内（負数値を含む）での乱数値を作るメソッド
    static func createRandom(range: Range<Int>) -> Int {
        let rangeLength = range.upperBound - range.lowerBound
        let random = arc4random_uniform(UInt32(rangeLength))
        return Int(random) + range.lowerBound
    }
}

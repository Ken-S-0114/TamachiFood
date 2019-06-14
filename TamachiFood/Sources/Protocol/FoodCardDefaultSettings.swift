//
//  FoodCardDefaultSetting.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Foundation
import UIKit

class FoodCardDefaultSettings: FoodCardSetting {
    private let DEFAULT_FONT_NAME = "HiraKakuProN-W3"
    private let DEFAULT_FONT_NAME_BOLD = "HiraKakuProN-W6"
    
    private let DEFAULT_TITLE_FONT_SIZE = 13.0
    private let DEFAULT_REMARK_FONT_SIZE = 13.0
    private let DEFAULT_DESCRIPTION_FONT_SIZE = 11.0
    private let DEFAULT_READ_MORE_BUTTON_FONT_SIZE = 12.0
    
    static var cardSetViewWidth: CGFloat = 300
    
    static var cardSetViewHeight: CGFloat = 320
    
    static var backgroundCornerRadius: CGFloat = 0.0
    
    static var backgroundBorderWidth: CGFloat = 0.75
    
    static var backgroundBorderColor: CGColor = UIColor.gray.cgColor
    
    static var backgroundShadowRadius: CGFloat = 3
    
    static var backgroundShadowOpacity: Float = 0.5
    
    static var backgroundShadowOffset: CGSize = CGSize(width: 0.75, height: 1.75)
    
    static var backgroundShadowColor: CGColor = UIColor.darkGray.cgColor
    
    static var backgroundColor: UIColor = UIColor.white
    
    static var remarkLabelBackgroundColor: UIColor = UIColor.orange
    
    static var remarkLabelFontColor: UIColor = UIColor.white
    
    static var readMoreButtonBackgroundColor: UIColor = UIColor.clear
    
    static var readMoreButtonFontColor: UIColor = UIColor.green
    
    static var beforeInitializeScale: CGFloat = 1.00
    
    static var afterInitializeScale: CGFloat = 1.00
    
    static var durationOfInitialize: TimeInterval = 1.50
    
    static var durationOfStartDragging: TimeInterval = 0.25
    
    static var durationOfReturnOriginal: TimeInterval = 0.25
    
    static var durationOfSwipeOut: TimeInterval = 0.50
    
    static var startDraggingAlpha: CGFloat = 0.98
    
    static var stopDraggingAlpha: CGFloat = 1.00
    
    static var maxScaleOfDragging: CGFloat = 1.00
    
    static var swipeXPosLimitRatio: CGFloat = 0.30
    
    static var swipeYPosLimitRatio: CGFloat = 0.10
}

//
//  UIColorExt.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/27.
//

import UIKit

extension UIColor {
    class func colorWithRGB(r: Float,g: Float,b: Float, alpha: Float) -> UIColor {

        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

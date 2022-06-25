//
//  UIColorExtension.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import UIKit.UIColor
import SwiftUI

/* Speed up use of UIColor conversion in SwiftUI */
extension UIColor { // Simple declarative approach
    var color: Color { Color(self) } // Could be a func but a computed prop follows the cgColor & ciColor approach
}

/* Accepting RGB via 0-255 digits and 0.0 to 1.0 alpha
Accepting 6-digit Hex, 2-digit piecewise Hex, 8-digit Hex with Alpha digits leading OR 0.0 to 1.0 Alpha*/
extension UIColor {
    // Int can be from 0-255 OR in hexadecimal form (e.g. FFFFFF == White) BUT
    // 0x needed at start of each hexadecimal value (e.g. UIColor(red: 0xFF, green: 0xFF, blue: 0xFF) == white)
    // CAN'T add designated initializers via Extension BUT convenience inits that call the OG designated inits are fine
    /// Convenience initializer enabling simple UIColor creation based on RGB values between 0-255
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(
            red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0, alpha: 1.0
        )
    }
    // Same idea as above BUT include alpha! with default val of 0xFF or 255 by default
    /// Convenience initializer enabling simple UIColor creation based on RGB values between 0-255 including an alpha value
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0, alpha: CGFloat(a) / 255.0
        )
    }
    // Or for the simple alpha 0 to 1.0
    /// Convenience initializer enabling simple UIColor creation based on RGB values between 0 to 255 including an alpha value
    /// between 0.0 and 1.0
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0, alpha: a
        )
    }
    
    // Handles it without alpha value (0xFFFFFF)
    /// Convenience initializer enabling simple UIColor creation based on RGB values based based upon a hex value
    /// For example: 0xFFFFFF being white
    convenience init(rgb: Int) {
        /* Each pair of hexadecimals can be thought of as 8 bits
         So 0xAABBCC shifting 16 leaves 0x0000AA printed as 0xAA or AA,
         8 right shift = 0x00AABB printed as 0xAABB or AABB, No Shift = 0xAABBCC
         Using the Bitwise & operator with 0xFF afterward masks the hexadecimals we don't want
         Doing 0xAABB & 0xFF reduces to 170, otherwise it would be 43707. Why?
         It lops off the leading bits -> 0xFF == 11111111 while 0xAABB == 1010101010111011
         What you get back is 0000000010111011 -> 10111011 -> 0x0000BB -> 0xBB.
         The Bitwise & operator sets a place to 1 if BOTH inputs have 1 in that place
         So all leading 0s of 0xFF leave behind 0s and we're left with a simple pair of hexadecimals */
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    // 6 digit Hex (0xFFFFFF) with Float based alpha
    /// Convenience initializer enabling simple UIColor creation based on RGB values based based upon a hex value with
    /// an optional alpha value in terms of 0.0 to 1.0
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF, a: a
        )
    }
    // 8 digit hex with leading 2 digits representing alpha = ARGB - 0xFFFFFFFF
    /// Convenience initializer enabling simple UIColor creation based on RGB values based based upon a hex value with
    /// a leading alpha value. For example: 0xFFFFFFFF being white with full opacity
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF, green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF, a: (argb >> 24) & 0xFF
        )
    }
    
    /// Increase all RGB values by a certain percent in CGFloat form between 0.0 and 1.0 (not to be confused by raising alpha/opacity)
    func brighten(by percent: CGFloat) -> UIColor {
        guard percent > 0.0, percent <= 1.0 else { return self }
        let rgba = self.cgColor.components
        
        let red = rgba![0]
        let finalRed = (red + percent > 1.0) ? 1.0 : red + percent
        
        let green = rgba![1]
        let finalGreen = (green + percent > 1.0) ? 1.0 : green + percent
        
        let blue = rgba![2]
        let finalBlue = (blue + percent > 1.0) ? 1.0 : blue + percent
        
        return UIColor(red: finalRed, green: finalGreen, blue: finalBlue, alpha: 1.0)
    }
}

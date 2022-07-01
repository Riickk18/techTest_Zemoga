//
//  String+Extensions.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import Foundation
import UIKit

extension String {
    /**
     Function to create a Mutable String with bold font.
     - Parameter string: string that will be configure with system bold font
     - Parameter size: CGFloat of size of font value
     - Returns: A NSMutableAttributedString
     */
    func configureBoldNSMutableAttributedString(string: String, size: CGFloat) -> NSMutableAttributedString{
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: size)]
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs as [NSAttributedString.Key : Any])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    /**
     Function to create a Mutable String with light font.
     - Parameter string: string that will be configure with system font
     - Parameter size: CGFloat of size of font value
     - Returns: A NSMutableAttributedString
     */
    func configureLightNSMutableAttributedString(string: String, size: CGFloat) -> NSMutableAttributedString{
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: size)]
        return NSMutableAttributedString(string: string, attributes:attrs2 as [NSAttributedString.Key : Any])
    }
    
    /**
     Function to create a Mutable String with bold string and light string. Additionally, string will configure with 5 points of lineSpacing
     - Parameter stringBold: string that will be configure with system bold font
     - Parameter self: string that will be configure with system font
     - Parameter size: CGFloat of size of font value
     - Returns: A string composing with stringBold + stringLight
     */
    func configureMutableString( stringBold: String, size: CGFloat ) -> NSMutableAttributedString {
        let string1 = configureBoldNSMutableAttributedString(string: stringBold, size: size)
        let string2 = configureLightNSMutableAttributedString(string: self, size: size)
        string1.append(string2)
        return string1
    }
}

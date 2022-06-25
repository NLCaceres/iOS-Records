//
//  UIColorExtensionTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

/* Test UIColor simplification extensions
 Accepting RGB via 0-255 digits and 0.0 to 1.0 alpha
 Accepting 6-digit Hex, 2-digit piecewise Hex, 8-digit Hex with Alpha digits leading OR 0.0 to 1.0 Alpha */
class UIColorExtensionTests: XCTestCase {
    // MARK: 2 Digit Piece by Piece Hex 0xFF or 255
    func testBasicRgbInit() {
        let white = UIColor(red: 255, green: 255, blue: 255)
        let hexWhite = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
        let normalWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(white, normalWhite)
        XCTAssertEqual(hexWhite, normalWhite)
        
        let red = UIColor(red: 255, green: 0, blue: 0)
        let hexRed = UIColor(red: 0xFF, green: 0, blue: 0)
        let normalRed = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        XCTAssertEqual(red, normalRed)
        XCTAssertEqual(hexRed, normalRed)
        
        let green = UIColor(red: 0, green: 255, blue: 0)
        let hexGreen = UIColor(red: 0, green: 0xFF, blue: 0)
        let normalGreen = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        XCTAssertEqual(green, normalGreen)
        XCTAssertEqual(hexGreen, normalGreen)
        
        let blue = UIColor(red: 0, green: 0, blue: 255)
        let hexBlue = UIColor(red: 0, green: 0, blue: 0xFF)
        let normalBlue = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        XCTAssertEqual(blue, normalBlue)
        XCTAssertEqual(hexBlue, normalBlue)
    }
    func testBasicRgbIntAlphaInit() {
        // WHEN no alpha included, default is full aka 0xFF or 255
        let white = UIColor(red: 255, green: 255, blue: 255)
        let normalWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(white, normalWhite)
        
        let halfWhite = UIColor(red: 255, green: 255, blue: 255, a: 51)
        let halfHexWhite = UIColor(red:255, green: 255, blue: 255, a: 0x33)
        let normalHalfWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        XCTAssertEqual(halfWhite, normalHalfWhite)
        XCTAssertEqual(halfHexWhite, normalHalfWhite)
        
        let clear = UIColor(red: 255, green: 255, blue: 255, a: 0)
        let hexClear = UIColor(red: 255, green: 255, blue: 255, a: 0x00)
        let normalClear = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        XCTAssertEqual(clear, normalClear)
        XCTAssertEqual(hexClear, normalClear)
    }
    func testBasicRgbCgFloatAlphaInit() {
        // WHEN no alpha included, default is full aka 1.0
        let white = UIColor(red: 255, green: 255, blue: 255)
        let normalWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(white, normalWhite)
        
        let halfWhite = UIColor(red: 255, green: 255, blue: 255, a: 0.5)
        let normalHalfWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        XCTAssertEqual(halfWhite, normalHalfWhite)
        
        let clear = UIColor(red: 255, green: 255, blue: 255, a: 0.0)
        let normalClear = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        XCTAssertEqual(clear, normalClear)
    }
    
    // MARK: 6 Digit Hex
    func testRgbFullHexInit() {
        // WHEN using 6 digit hex 0xAABBCC
        let white = UIColor(rgb: 0xFFFFFF)
        // THEN each pair is represented as a CGFloat where the hex in decimal is divided by 255
        let normalWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(white, normalWhite)
        
        let red = UIColor(rgb: 0xFF0000)
        let normalRed = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        XCTAssertEqual(red, normalRed)
        
        let green = UIColor(rgb: 0x00FF00)
        let normalGreen = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        XCTAssertEqual(green, normalGreen)
        
        let blue = UIColor(rgb: 0x0000FF)
        let normalBlue = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        XCTAssertEqual(blue, normalBlue)
    }
    func testRgbAlphaHexInit() {
        // WHEN hex is 8 digit 0xAABBCCDD
        let white = UIColor(argb: 0xFFFFFFFF)
        let normalWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(white, normalWhite)
        
        let halfWhite = UIColor(argb: 0x33FFFFFF)
        // THEN 1st hex pair corresponds to a particular alpha float value
        let normalHalfWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        XCTAssertEqual(halfWhite, normalHalfWhite)
        
        let clear = UIColor(argb: 0x00FFFFFF)
        let normalClear = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        XCTAssertEqual(clear, normalClear)
    }
    func testRgbHexCgFloatAlphaInit() {
        // WHEN no alpha included, default is full aka 1.0
        let defaultAlphaWhite = UIColor(rgb: 0xFFFFFF)
        let normalAlphaWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(defaultAlphaWhite, normalAlphaWhite)
        
        // When using 6 digit Hex, can pass in CGFloat alpha value
        let white = UIColor(rgb: 0xFFFFFF, a: 1.0)
        let normalWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(white, normalWhite)
        
        let halfWhite = UIColor(rgb: 0xFFFFFF, a: 0.5)
        // THEN matches default rgb alpha initalizer usage
        let normalHalfWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        XCTAssertEqual(halfWhite, normalHalfWhite)
        
        let clear = UIColor(rgb: 0xFFFFFF, a: 0.0)
        let normalClear = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        XCTAssertEqual(clear, normalClear)
    }
}

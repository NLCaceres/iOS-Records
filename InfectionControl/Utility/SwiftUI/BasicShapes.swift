//
//  BasicShapes.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct XShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
    
        // Defines \ shape
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Then define / shape
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path // To make X
    }
}

struct CheckMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Define / shape
        path.move(to: CGPoint(x: rect.maxX-2, y: rect.minY+1))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        // Then define small \
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + rect.height / 8))
        // Final y == Somewhat below midY, somewhat above total height (midY < Y < maxY)
        return path // To make checkmark
    }
}

struct CircularSlash: Shape {
    // Idea here is a circle with a \ across the top left edge
    func path(in rect: CGRect) -> Path {
        var circlePath = Circle().path(in: rect)
        circlePath.move(to: getCirclePoint(rect: rect, degrees: 225.0))
        // Note: Degrees = 0.0 is the (rect.maxX, rect.midY) so far right side
        circlePath.addLine(to: getCirclePoint(rect: rect, degrees: 45.0))
        // So Degrees = 45.0 is clockwise movement along the circle, where 90.0 is at (rect.midX, rect.maxY)
        
        // Calculating points along the circle beats create our XShape(), calling path(in: rect) on it
        // And calling addPath(xShapeVar) on our circlePath (Just kept getting an oversized X)
        return circlePath
    }
}

func getCirclePoint(rect: CGRect, degrees: CGFloat) -> CGPoint {
    let radians = degrees * .pi / 180
    let radius = rect.midX - rect.minX
    let startX = rect.midX + radius * cos(radians)
    let startY = rect.midY + radius * sin(radians)
    return CGPoint(x: startX, y: startY)
}

func getEvenCirclePoints(centerPoint point: CGPoint, radius: CGFloat, n: Int) -> [CGPoint] {
    let result: [CGPoint] = stride(from: 0.0, to: 360.0, by: Double(360 / n)).map {
        let radians = CGFloat($0) * .pi / 180
        let x = point.x + radius * cos(radians)
        let y = point.y + radius * sin(radians)
        return CGPoint(x: x, y: y)
    }
    return result
}

struct WarningSign: Shape {
    // Idea here is a triangle with an exclamation point inside
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = rect.width / 10
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY * 0.95), radius: radius,
                    startAngle: .degrees(0.0), endAngle: .degrees(360.0), clockwise: true)
        // Begin \ of ! point
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY * 0.8))
        path.addLine(to: CGPoint(x: rect.midX * 0.60 , y: rect.midY * 0.35))
        
        // Begin top arc of ! point
        let topArcRadius = rect.midX - rect.midX * 0.60
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY * 0.35), radius: topArcRadius,
                    startAngle: .degrees(180.0), endAngle: .degrees(0.0), clockwise: false)
        
        // Alternative method is to use a quad curve rather than an arc
//        let curveEndpoint = CGPoint(x: rect.midX * 1.4 , y: rect.midY * 0.2)
//        path.addQuadCurve(to: curveEndpoint, control: CGPoint(x: rect.midX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY * 0.8))
        
        return path
    }
}

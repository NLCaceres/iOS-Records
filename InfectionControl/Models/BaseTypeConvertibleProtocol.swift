//
//  BaseTypeConvertibleProtocol.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

/* The BaseTypeConvertible Protocol defines the relationship between a DTO and its Base model,
 * ensuring a DTO can always be easily converted into its Base type
 * Inspired by the CustomStringConvertible protocol that defines how a conforming type should be converted to a String
 */

protocol BaseTypeConvertible {
    associatedtype Base // Refers to the conforming class's normal base model (as opposed to a DTO)
    func toBase() -> Base
}

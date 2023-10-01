//
//  ToBaseProtocol.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation

/* The ToBaseProtocol defines the relationship between a DTO and its Base model,
 * ensuring a DTO can always be easily converted into its Base type
 */

protocol ToBase {
    associatedtype Base // Refers to the conforming class's normal base model (as opposed to a DTO)
    func toBase() -> Base
}

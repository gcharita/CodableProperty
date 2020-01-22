//
//  OptionalCodableTransformer.swift
//  CodableProperty
//
//  Created by Giorgos Charitakis on 22/1/20.
//

import Foundation

public struct OptionalCodableTransformer<BaseTransformer: BaseCodableTransformer>: CodableTransformer {
    public typealias Value = BaseTransformer.Value?
    private let baseTransformer = BaseTransformer()

    public init() {}
    
    public func value(from decoder: Decoder) throws -> Value {
        return try baseTransformer.value(from: decoder)
    }

    public func encode(value: Value, to encoder: Encoder) throws {
        try baseTransformer.encode(value: value, to: encoder)
    }
}

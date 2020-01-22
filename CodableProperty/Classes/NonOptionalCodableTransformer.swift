//
//  NonOptionalCodableTransformer.swift
//  CodableProperty
//
//  Created by Giorgos Charitakis on 22/1/20.
//

import Foundation

public struct NonOptionalCodableTransformer<BaseTransformer: BaseCodableTransformer>: CodableTransformer {
    public typealias Value = BaseTransformer.Value
    private let baseTransformer = BaseTransformer()

    public init() {}
    
    public func value(from decoder: Decoder) throws -> Value {
        guard let value = try baseTransformer.value(from: decoder) else {
            throw DecodingError.valueNotFound(
                Value.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected \(Value.self) value but found null instead."
                )
            )
        }
        return value
    }

    public func encode(value: Value, to encoder: Encoder) throws {
        try baseTransformer.encode(value: value, to: encoder)
    }
}

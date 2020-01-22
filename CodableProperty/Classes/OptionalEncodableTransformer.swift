//
//  OptionalEncodableTransformer.swift
//  CodableProperty
//
//  Created by Giorgos Charitakis on 22/1/20.
//

import Foundation

public struct OptionalEncodableTransformer<BaseTransformer: BaseEncodableTransformer>: EncodableTransformer {
    public typealias Value = BaseTransformer.Value?
    private let baseTransformer = BaseTransformer()

    public init() {}
    
    public func encode(value: Value, to encoder: Encoder) throws {
        try baseTransformer.encode(value: value, to: encoder)
    }
}

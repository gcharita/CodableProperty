//
//  OptionalDecodableTransformer.swift
//  CodableProperty
//
//  Created by Giorgos Charitakis on 22/1/20.
//

import Foundation

public struct OptionalDecodableTransformer<BaseTransformer: BaseDecodableTransformer>: DecodableTransformer {
    public typealias Value = BaseTransformer.Value?
    private let baseTransformer = BaseTransformer()

    public init() {}
    
    public func value(from decoder: Decoder) throws -> Value {
        return try baseTransformer.value(from: decoder)
    }
}

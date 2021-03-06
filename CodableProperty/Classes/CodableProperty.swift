//
//  CodableProperty.swift
//  CodableProperty
//
//  Created by Giorgos Charitakis on 10/07/2019.
//

import Foundation

/// A property that conforms to `Codable` protocol and can be transformed from the specified `CodableTransformer`
@propertyWrapper public struct CodableProperty<Transformer: CodableTransformer>: Codable {
    public var wrappedValue: Transformer.Value
    private let transformer = Transformer()
    
    public init(from decoder: Decoder) throws {
        wrappedValue = try transformer.value(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try transformer.encode(value: wrappedValue, to: encoder)
    }
}

/// A property that conforms to `Encodable` protocol and can be transformed from the specified `EncodableTransformer`
@propertyWrapper public struct EncodableProperty<Transformer: EncodableTransformer>: Encodable {
    public var wrappedValue: Transformer.Value
    private let transformer = Transformer()
    
    public init(wrappedValue: Transformer.Value) {
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try transformer.encode(value: wrappedValue, to: encoder)
    }
}

/// A property that conforms to `Decodable` protocol and can be transformed from the specified `DecodableTransformer`
@propertyWrapper public struct DecodableProperty<Transformer: DecodableTransformer>: Decodable {
    public var wrappedValue: Transformer.Value
    private let transformer = Transformer()
    
    public init(from decoder: Decoder) throws {
        wrappedValue = try transformer.value(from: decoder)
    }
}

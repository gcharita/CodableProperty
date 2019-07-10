//
//  CodableTransformer.swift
//  CodableProperty
//
//  Created by Giorgos Charitakis on 10/07/2019.
//

import Foundation

/// A type that transforms the outcome of, both the encoding and decoding process.
public typealias CodableTransformer = EncodableTransformer & DecodableTransformer

/// A type that transforms the outcome of the decoding process.
public protocol DecodableTransformer {
    associatedtype Value
    
    /**
     Returns a new instance of `Value` type by decoding from the given decoder.
     
     This initializer throws an error if reading from the decoder fails, or
     if the data read is corrupted or otherwise invalid.
     
     - Parameter decoder: The decoder to read data from.
     
     - Throws: An error if reading from the decoder fails, or if the data read is corrupted or otherwise invalid.
     
     - Returns: A new instance of `Value` type.
     */
    static func value(from decoder: Decoder) throws -> Value
}

/// A type that transforms the outcome of the encoding process.
public protocol EncodableTransformer {
    associatedtype Value
    
    /**
     Encodes the passed value into the given encoder.
     
     If the value fails to encode anything, `encoder` will encode an empty
     keyed container in its place.
     
     This function throws an error if any values are invalid for the given
     encoder's format.
     
     - Parameters:
     - value: The value to be encoded
     - encoder: The encoder to write data to.
     
     - Throws: an error if any values are invalid for the given encoder's format.
     */
    static func encode(value: Value, to encoder: Encoder) throws
}

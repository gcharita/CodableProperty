# CodableProperty

[![CI Status](https://img.shields.io/travis/gcharita/CodableProperty.svg?style=flat)](https://travis-ci.org/gcharita/CodableProperty)
[![Version](https://img.shields.io/cocoapods/v/CodableProperty.svg?style=flat)](https://cocoapods.org/pods/CodableProperty)
[![License](https://img.shields.io/cocoapods/l/CodableProperty.svg?style=flat)](https://cocoapods.org/pods/CodableProperty)
[![Platform](https://img.shields.io/cocoapods/p/CodableProperty.svg?style=flat)](https://cocoapods.org/pods/CodableProperty)

CodableProperty is a framework written in Swift that works along with the build in `Codable` protocol. Uses the new `propertyWrapper` feature of Swift 5.1 to make type transformation easier.

- [Example](#example)
- [Requirements](#requirements)
- [How to use](#how-to-use)
- [Communication](#communication)
- [Installation](#installation)
- [Special thanks](#special-thanks)
- [License](#license)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+ / macOS 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 11+
- Swift 5.1+

## How to use

To use `CodableProperty` just implement `CodableTransformer` protocol and use it inside your `Codable` model like this:

```swift
@CodableProperty<CustomCodableTransformer> var someProperty: SomeType
```

For example if you have the following JSON:

```json
{
    "currency": "PLN",
    "rates": {
        "USD": 3.76,
        "EUR": 4.24,
        "SEK": 0.41
    }
}
```

And you want to map it in a model like this:

```swift
struct CurrencyConversion {
    var currency: String
    var rates: [ExchangeRate]
}

struct ExchangeRate {
    let currency: String
    let rate: Double
}
```

You can transform the JSON type to your model type by implementing `CodableTransformer` protocol:

```swift
class RatesTransformer: CodableTransformer {
    typealias Value = [ExchangeRate]

    static func value(from decoder: Decoder) throws -> Value {
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: Double].self)

        return dictionary.map { key, value in
            ExchangeRate(currency: key, rate: value)
        }
    }

    static func encode(value: Value, to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let dictionary = value.reduce(into: [String: Double]()) { (result: inout [String: Double], exchangeRate: ExchangeRate) in
            result[exchangeRate.currency] = exchangeRate.rate
        }
        try container.encode(dictionary)
    }
}
```

And use it in your `Codable` model like this:

```swift
struct CurrencyConversion: Codable {
    var currency: String
    @CodableProperty<RatesTransformer> var rates: [ExchangeRate]
}

struct ExchangeRate {
    let currency: String
    let rate: Double
}
```

If you model implements `Decodable` protocol instead of `Codable` you can specialize the type transformation only in decoding process by implementing `DecodableTransformer` protocol:

```swift
class RatesTransformer: DecodableTransformer {
    typealias Value = [ExchangeRate]

    static func value(from decoder: Decoder) throws -> Value {
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: Double].self)

        return dictionary.map { key, value in
            ExchangeRate(currency: key, rate: value)
        }
    }
}
```

And use it like this:

```swift
struct CurrencyConversion: Decodable {
    var currency: String
    @DecodableProperty<RatesTransformer> var rates: [ExchangeRate]
}
```

The same applies also to `Encodable` models:

```swift
class RatesTransformer: EncodableTransformer {
    typealias Value = [ExchangeRate]

    static func encode(value: Value, to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let dictionary = value.reduce(into: [String: Double]()) { (result: inout [String: Double], exchangeRate: ExchangeRate) in
            result[exchangeRate.currency] = exchangeRate.rate
        }
        try container.encode(dictionary)
    }
}

struct CurrencyConversion: Encodable {
    var currency: String
    @EncodableProperty<RatesTransformer> var rates: [ExchangeRate]
}
```

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.

## Installation

### CocoaPods

CodableProperty is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CodableProperty'
```

## Special thanks

Special thanks to [John Sundell](https://github.com/JohnSundell). His example in [this](https://www.swiftbysundell.com/posts/customizing-codable-types-in-swift) article inspired me to write this project.

## License

CodableProperty is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

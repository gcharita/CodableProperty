import XCTest
import CodableProperty

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTransformer() {
        let jsonString = """
        {
            "currency": "PLN",
            "rates": {
                "USD": 3.76,
                "EUR": 4.24,
                "SEK": 0.41
            }
        }
        """
        do {
            let jsonDecoder = JSONDecoder()
            let jsonEncoder = JSONEncoder()
            
            var object = try jsonDecoder.decode(CurrencyConversion.self, from: Data(jsonString.utf8))
            XCTAssertEqual(object.currency, "PLN")
            XCTAssertEqual(object.rates.first(where: { $0.currency == "USD" })?.rate, 3.76)
            XCTAssertEqual(object.rates.first(where: { $0.currency == "EUR" })?.rate, 4.24)
            XCTAssertEqual(object.rates.first(where: { $0.currency == "SEK" })?.rate, 0.41)
            
            var data = try jsonEncoder.encode(object)
            object = try jsonDecoder.decode(CurrencyConversion.self, from: data)
            XCTAssertEqual(object.currency, "PLN")
            XCTAssertEqual(object.rates.first(where: { $0.currency == "USD" })?.rate, 3.76)
            XCTAssertEqual(object.rates.first(where: { $0.currency == "EUR" })?.rate, 4.24)
            XCTAssertEqual(object.rates.first(where: { $0.currency == "SEK" })?.rate, 0.41)
            
            var optionalObject = try jsonDecoder.decode(OptionalRatesCurrencyConversion.self, from: Data(jsonString.utf8))
            XCTAssertEqual(optionalObject.currency, "PLN")
            XCTAssertEqual(optionalObject.rates?.first(where: { $0.currency == "USD" })?.rate, 3.76)
            XCTAssertEqual(optionalObject.rates?.first(where: { $0.currency == "EUR" })?.rate, 4.24)
            XCTAssertEqual(optionalObject.rates?.first(where: { $0.currency == "SEK" })?.rate, 0.41)
            
            data = try jsonEncoder.encode(object)
            optionalObject = try jsonDecoder.decode(OptionalRatesCurrencyConversion.self, from: data)
            XCTAssertEqual(optionalObject.currency, "PLN")
            XCTAssertEqual(optionalObject.rates?.first(where: { $0.currency == "USD" })?.rate, 3.76)
            XCTAssertEqual(optionalObject.rates?.first(where: { $0.currency == "EUR" })?.rate, 4.24)
            XCTAssertEqual(optionalObject.rates?.first(where: { $0.currency == "SEK" })?.rate, 0.41)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

struct CurrencyConversion: Codable {
    var currency: String
    
    @CodableProperty<NonOptionalCodableTransformer<RatesTransformer>>
    var rates: [ExchangeRate]
}

struct OptionalRatesCurrencyConversion: Codable {
    var currency: String
    
    @CodableProperty<OptionalCodableTransformer<RatesTransformer>>
    var rates: [ExchangeRate]?
}

struct ExchangeRate {
    let currency: String
    let rate: Double
}

struct RatesTransformer: BaseCodableTransformer {
    typealias Value = [ExchangeRate]

    func value(from decoder: Decoder) throws -> Value? {
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: Double].self)

        return dictionary.map { key, value in
            ExchangeRate(currency: key, rate: value)
        }
    }

    func encode(value: Value?, to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let dictionary = value?.reduce(into: [String: Double]()) { (result: inout [String: Double], exchangeRate: ExchangeRate) in
            result[exchangeRate.currency] = exchangeRate.rate
        }
        try container.encode(dictionary)
    }
}

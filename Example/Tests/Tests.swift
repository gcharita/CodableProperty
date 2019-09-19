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
        let object = try? JSONDecoder().decode(CurrencyConversion.self, from: Data(jsonString.utf8))
        XCTAssertEqual(object?.currency, "PLN")
        XCTAssertEqual(object?.rates.first(where: { $0.currency == "USD" })?.rate, 3.76)
        XCTAssertEqual(object?.rates.first(where: { $0.currency == "EUR" })?.rate, 4.24)
        XCTAssertEqual(object?.rates.first(where: { $0.currency == "SEK" })?.rate, 0.41)
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
    @CodableProperty<RatesTransformer> var rates: [ExchangeRate]
}

struct ExchangeRate {
    let currency: String
    let rate: Double
}

struct RatesTransformer: CodableTransformer {
    typealias Value = [ExchangeRate]

    func value(from decoder: Decoder) throws -> Value {
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: Double].self)

        return dictionary.map { key, value in
            ExchangeRate(currency: key, rate: value)
        }
    }

    func encode(value: Value, to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let dictionary = value.reduce(into: [String: Double]()) { (result: inout [String: Double], exchangeRate: ExchangeRate) in
            result[exchangeRate.currency] = exchangeRate.rate
        }
        try container.encode(dictionary)
    }
}

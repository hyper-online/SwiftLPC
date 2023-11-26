import XCTest
@testable import SwiftLPC

final class SwiftLPCTests: XCTestCase {
    let lpc = LinearPredictiveCoding()
    
    func testLpc() throws {
        let input: [Float] = [0.0, 1, 2]
        
        let output = lpc.computeLpc(input, order: 2)
        let expectedOutput: [Float] = [1, -1.2, 0.8]
        
        for (index, value) in output.enumerated() {
            XCTAssertEqual(value, expectedOutput[index], accuracy: 1e-6)
        }
    }
}

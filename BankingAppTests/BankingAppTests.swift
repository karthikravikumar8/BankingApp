import XCTest
import Combine
@testable import BankingApp

final class BankingAppTests: XCTestCase {
    var sut: TransactionListViewModel!
    private var transactionService: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        transactionService = MockAPIClient()
        sut = TransactionListViewModel(transactionService: transactionService)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCumulativeBalance() {
        let cumulativeTotal = sut.calculateCumulativeBalance()
        XCTAssertEqual(cumulativeTotal, 2700.0)
    }
    
    /*func testMonthlyBalance() {
        let monthlyBalance = sut.accumulateTransactions()
        XCTAssertEqual(monthlyBalance, 2700.0)
    }*/
}

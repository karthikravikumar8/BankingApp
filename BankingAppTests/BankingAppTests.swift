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
    
    func testCumulativeTransaction() {
        let transactions: [Transaction] = [
            Transaction(id: 1, date: "08/14/2023", merchant: "Food", amount: 50.0, type: "debit"),
            Transaction(id: 2, date: "08/1/2023", merchant: "Payroll", amount: 2550.0, type: "credit"),
            Transaction(id: 3, date: "07/8/2023", merchant: "Travel", amount: 150.0, type: "debit"),
            Transaction(id: 4, date: "07/8/2023", merchant: "Travel", amount: 350.0, type: "credit")
        ]
        
        
        let cumulativeTotal = sut.calculateCumulativeBalance(transaction: transactions)
        
        XCTAssertEqual(cumulativeTotal, 2700.0)
                
    }
    
    
}

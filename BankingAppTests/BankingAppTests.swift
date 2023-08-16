import XCTest
import Combine
import Collections
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
    
    
    func testGetTransactions() {
        // given
        let expectation = XCTestExpectation(description: "Fetching transactions from API")
        var receivedTransactions: [Transaction]?
        // when
        let cancellable = transactionService.getTransactions().sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("API request failed with error: \(error)")
                }
                expectation.fulfill()
            },
            receiveValue: { transactions in
                receivedTransactions = transactions
            }
        )
        wait(for: [expectation], timeout: 5.0)
        // then
        XCTAssertNotNil(receivedTransactions)
        XCTAssertEqual(receivedTransactions?.count, 4)
        cancellable.cancel()
        
        
    }
    
    func testGetTransactions_NoResponse() {
        // given
        let service: APIClient = MockAPIClientNoResponse()
        let expectation = XCTestExpectation(description: "Fetching transactions from API")
        var receivedTransactions: [Transaction]?
        // when
        let cancellable = service.getTransactions().sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("API request failed with error: \(error)")
                }
                expectation.fulfill()
            },
            receiveValue: { transactions in
                receivedTransactions = transactions
            }
        )
        wait(for: [expectation], timeout: 5.0)
        // then
        XCTAssertNotNil(receivedTransactions)
        XCTAssertEqual(receivedTransactions?.count, 0)
        cancellable.cancel()
    }
    
    
    func testCumulativeBalance() {
        // when
        let cumulativeTotal = sut.calculateCumulativeBalance()
        // then
        XCTAssertEqual(cumulativeTotal, 2700.0)
    }
    
    func testMonthlyBalance() {
        // given
        let monthlyBalance = sut.accumulateTransactions()
        // when
        var monthBalance = 0.0
        if let balance = monthlyBalance.last {
            monthBalance = balance.1
        }
        // then
        XCTAssertEqual(monthBalance, 2500.0)
    }
    
    func testMonthlyBalanceGroupedTransactionByMonth() {
        // given
        let service: APIClient = MockAPIClientGroupedTransactionByMonth()
        sut = TransactionListViewModel(transactionService: service)
        var monthlyBalance = 0.0
        // when
        let groupedTransactions = sut.groupTransactionsByMonth()
        for (_, transactions) in groupedTransactions {
            monthlyBalance = sut.calculateMonthlyBalance(transactions: transactions)
        }
        // then
        XCTAssertEqual(monthlyBalance, 2000.0)
    }
    
    func testGroupTransactionsByMonth() {
        // given
        let groupTransaction = sut.groupTransactionsByMonth()
        var expectedResult: OrderedDictionary<String, [Transaction]>
        // when
        expectedResult = ["elokuu 2023": [Transaction(id: 1, date: "08/14/2023", merchant: "Food", amount: 50.0, type: "debit"), Transaction(id: 2, date: "08/1/2023", merchant: "Payroll", amount: 2550.0, type: "credit")], "heinäkuu 2023": [Transaction(id: 3, date: "07/8/2023", merchant: "Travel", amount: 150.0, type: "debit"), Transaction(id: 4, date: "07/8/2023", merchant: "Travel", amount: 350.0, type: "credit")]]
        
        /* Below texts were not working in finnish laptop as it picks months in finnish*/
        
        /*expectedResult = ["August 2023": [Transaction(id: 1, date: "08/14/2023", merchant: "Food", amount: 50.0, type: "debit"), Transaction(id: 2, date: "08/1/2023", merchant: "Payroll", amount: 2550.0, type: "credit")], "July 2023": [Transaction(id: 3, date: "07/8/2023", merchant: "Travel", amount: 150.0, type: "debit"), Transaction(id: 4, date: "07/8/2023", merchant: "Travel", amount: 350.0, type: "credit")]]*/
        // then
        XCTAssertEqual(groupTransaction, expectedResult)
    }
}

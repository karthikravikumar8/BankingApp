import Foundation
import Combine
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    private var cancellables = Set<AnyCancellable>()
    private let transactionService: APIClient
    
    init(transactionService: APIClient) {
        self.transactionService = transactionService
        getTransactions()
    }
    
    func getTransactions() {
        transactionService.getTransactions().sink { completion in
            switch completion {
            case .failure(let error):
                print("Error fetching transactions:", error.localizedDescription)
                self.loadLocalJSONFile()
            case .finished:
                print("Finished fetching transactions")
            }
        } receiveValue: { [weak self] result in
            self?.transactions = result
        }
        .store(in: &cancellables)
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        return groupedTransactions
    }
    
    func calculateCumulativeBalance() -> Double {
        guard !transactions.isEmpty else { return 0.0 }
        return transactions.reduce(0.0) {$0 + $1.signedAmount}
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        guard !transactions.isEmpty else {
            return []
        }
        
        // it can be Date() for real time data.
        let today = "08/16/2023".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter{ $0.dateParsed == date }
            let dailyTotal = dailyExpenses.reduce(0) { $0 + $1.signedAmount}
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
        }
        return cumulativeSum
    }
    
    func calculateMonthlyBalance(transactions: [Transaction]) -> Double {
        return transactions.reduce(0.0) { $0 + $1.signedAmount }
    }
    
    func loadLocalJSONFile() {
        guard let url = Bundle.main.url(forResource: "TransactionList", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            transactions = try decoder.decode([Transaction].self, from: data)
        } catch {
            print("Error fetching local transactions:")
        }
    }
}

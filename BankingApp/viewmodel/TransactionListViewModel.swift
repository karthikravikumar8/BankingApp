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
            case .finished:
                print("Finished fetching transactions")
            }
        } receiveValue: { [weak self] result in
            self?.transactions = result
            //dump(self?.transactions)
        }
        .store(in: &cancellables)
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        
        //print(groupedTransactions)
        
        return groupedTransactions
    }
    
    func calculateCumulativeBalance() -> Double {
        //transaction: [Transaction]
        guard !transactions.isEmpty else { return 0.0 }
        
        return transactions.reduce(0.0) {$0 + $1.signedAmount}
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        guard !transactions.isEmpty else {
            return []
        }
        
        let today = "08/16/2023".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter{ $0.dateParsed == date }
            let dailyTotal = dailyExpenses.reduce(0) { $0 + $1.signedAmount}
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "dailyTotal:", dailyTotal, "sum:", sum)
            
        }
        return cumulativeSum
    }
    
}

import Foundation

struct Transaction: Identifiable {
    let id: Int
    let date: String
    var merchant: String
    let amount: Double
    let type: TransactionType.RawValue
}

enum TransactionType: String {
    case debit = "debit"
    case credit = "credit"
}

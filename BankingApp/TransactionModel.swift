import Foundation

struct Transaction: Identifiable {
    let id: Int
    let date: String
    var merchant: String
    let amount: Double
    let type: TransactionType.RawValue
    
    var dateParsed: Date {
        date.dateParsed()
    }

    var signedAmount: Double {
        return type == TransactionType.credit.rawValue ? amount : -amount
    }
}

enum TransactionType: String {
    case debit = "debit"
    case credit = "credit"
}

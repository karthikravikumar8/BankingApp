import Foundation

struct Transaction: Identifiable, Decodable, Hashable {
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
    
    var month: String {
        dateParsed.formatted(.dateTime.year().month(.wide))
    }
}

enum TransactionType: String {
    case debit = "debit"
    case credit = "credit"
}

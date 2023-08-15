import Foundation

var transactionPreviewData = Transaction(id: 1, date: "08/14/2023", merchant: "Apple", amount: 20.50, type: "debit")

var transactionListPreviewData = [Transaction] (repeating: transactionPreviewData, count: 10)

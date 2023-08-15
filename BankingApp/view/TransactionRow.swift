import SwiftUI

struct TransactionRow: View {
    var transation: Transaction
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(transation.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                Text(transation.dateParsed, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
            }
            
            Spacer()
            
            Text(transation.signedAmount, format: .currency(code: "EUR"))
                .bold()
                .foregroundColor(transation.type == TransactionType.credit.rawValue ? Color.text : .primary)
            
        }
        .padding([.top, .bottom], 8)
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionRow(transation: transactionPreviewData)
            TransactionRow(transation: transactionPreviewData)
                .preferredColorScheme(.dark)
        }
        
    }
}

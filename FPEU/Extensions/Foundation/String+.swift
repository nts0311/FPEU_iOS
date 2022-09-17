//
//  String+.swift
//  FPEU
//
//  Created by son on 08/08/2022.
//

import Foundation

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

extension Swift.Optional where Wrapped == String {
    var url: URL? {
        return URL(string: self ?? "")
    }
}

extension String {
    var toEmoneyAmount: String {
        return String(self.filter { !" \n\t\r,".contains($0) })
    }
    
    var formatCurrency: Double {
        if self.contains(".") {
            return (Double(self.replacingOccurrences(of: ".", with: "")) ?? 0)/100
        }
        return (Double(self) ?? 0)
    }
    
    var toDouble: Double {
        return Double(self.toEmoneyAmount) ?? 0
    }
    
    private static let currencyFormatter: NumberFormatter = {
           $0.numberStyle = .currency
           $0.minimumFractionDigits = 0
           $0.maximumFractionDigits = 2
           $0.usesSignificantDigits = false
           //$0.currencySymbol = .empty
        $0.currencySymbol = ""
           $0.locale = Locale(identifier: "en_US")
           return $0
       }(NumberFormatter())
    
    var toCurrencyFormat: String {
        guard let amount = Double(self) else { return self }
        return String.currencyFormatter.string(from: NSNumber(value: amount)) ?? self
    }
    
    var formatAmount: String? {
        guard let amount = Double(self.toEmoneyAmount) else { return self }
        let formatedPrice = String.currencyFormatter.string(from: NSNumber(value: amount))
        return "\(formatedPrice ?? "--")đ"
    }
}

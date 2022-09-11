//
//  Double+.swift
//  FPEU
//
//  Created by son on 12/09/2022.
//

import Foundation

extension Double {
  var prettyDistance: String {
    guard self > -.infinity else { return "?" }

    let formatter = LengthFormatter()
    formatter.numberFormatter.maximumFractionDigits = 2

    if self >= 1000 {
      return formatter.string(fromValue: self / 1000, unit: LengthFormatter.Unit.kilometer)
    } else {
      let value = Double(Int(self))
      return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
    }
  }
}

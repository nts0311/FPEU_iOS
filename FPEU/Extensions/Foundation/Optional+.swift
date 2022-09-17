//
//  Optional+.swift
//  FPEU
//
//  Created by son on 08/08/2022.
//

import Foundation

extension Swift.Optional {
    var safeString: String {
      if self == nil || self is NSNull {
        return ""
      }
      if self is String, let obj = self as? String {
        return obj
      }
      if self is Int, let obj = self as? Int {
        return String(obj)
      }
        if self is Double, let obj = self as? Double {
          return String(obj)
        }
      return ""
    }
}

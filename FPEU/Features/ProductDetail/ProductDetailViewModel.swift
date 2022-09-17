//
//  ProductDetailViewModel.swift
//  FPEU
//
//  Created by son on 16/09/2022.
//

import Foundation
import RxSwift
import RxRelay

class ProductDetailViewModel: FPViewModel {
    
    let canAddToCard = BehaviorRelay(value: false)
    
    var product: MerchantProduct!
    
    //AttrId: [OptionIds]
    var optionSelection: [Int:[Int]] = [:]
    
    func getOptionsForAtrribute(index: Int) -> [ProductAttributeOption] {
        return product.attributes[index].options
    }
    
    func getAttributeAt(index: Int) -> ProductAttribute {
        return product.attributes[index]
    }
    
    func getOptionAt(attributeIndex: Int, optionIndex: Int) -> ProductAttributeOption {
        return product.attributes[attributeIndex].options[optionIndex]
    }
    
    func isOptionSelected(attributeIndex: Int, optionIndex: Int) -> Bool {
        let attr = getAttributeAt(index: attributeIndex)
        let optionId = attr.options[optionIndex].id ?? -1
        if let selectedOptions = optionSelection[attr.id ?? -1] {
            return selectedOptions.contains(optionId)
        }
        
        return false
    }
    
    func changeOptionsState(attributeIndex: Int, optionIndex: Int) {
        let attr = getAttributeAt(index: attributeIndex)
        
        guard let attrId = attr.id, let optionId = attr.options[optionIndex].id else {
            return
        }
        
        let isOptionSelected = isOptionSelected(attributeIndex: attributeIndex, optionIndex: optionIndex)
        
        let deselectingLastOption = isOptionSelected && optionSelection[attrId]?.count == 1
        
        if (attr.isRequired && deselectingLastOption) {
            return
        }
        
        if (isOptionSelected) {
            optionSelection[attrId]?.removeAll(where: { $0 == optionId })
        } else {
            if optionSelection[attrId] == nil {
                optionSelection[attrId] = []
            }
            
            if (attr.isMultiple) {
                optionSelection[attrId]?.append(optionId)
            } else {
                optionSelection[attrId] = [optionId]
            }
            
        }
        
        validateInput()
    }
    
    func validateInput() {
        for pattribute in product.attributes {
            if let attrId = pattribute.id, pattribute.isRequired,
               !(optionSelection[attrId]?.isEmpty ?? true) {
                canAddToCard.accept(true)
                return
            }
        }
        
        canAddToCard.accept(false)
    }
}

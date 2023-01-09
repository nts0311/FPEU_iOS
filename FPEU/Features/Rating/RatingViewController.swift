//
//  RatingViewController.swift
//  FPEU
//
//  Created by son on 15/12/2022.
//

import UIKit
import Cosmos
import RxSwift
import RxRelay
import SwiftEntryKit

class RatingViewController: FPViewController {
    
    var orderId: Int! = 3489
    
    @IBOutlet weak var merchantRatingView: CosmosView!
    @IBOutlet weak var driverRatingView: CosmosView!
    
    let viewModel = RatingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.orderId = orderId
        bindViewModel()
    }
    
    func bindViewModel() {
        
        viewModel.outApiResult.asObservable().subscribe(onNext: {_ in
            self.showNotificationMessage()
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        
        merchantRatingView.didFinishTouchingCosmos = {rating in
            self.viewModel.inMerchantRating.accept(Int(rating))
        }
        
        driverRatingView.didFinishTouchingCosmos = {rating in
            self.viewModel.inDriverRating.accept(Int(rating))
        }
    }

    @IBAction func buttonSendTapped(_ sender: Any) {
        viewModel.sendRate()
    }
    
    private func showNotificationMessage(textColor: EKColor = .white ) {
        
        var attributes: EKAttributes = .bottomFloat
        attributes.displayMode = .inferred
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .gradient(
            gradient: .init(
                colors: [Color.BlueGradient.dark, Color.BlueGradient.light],
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)
            )
        )
        attributes.entryInteraction = .delayExit(by: 3)
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.statusBar = .dark
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.minEdge),
            height: .intrinsic
        )
        
        let title = EKProperty.LabelContent(
            text: "Thành công",
            style: .init(
                font: .systemFont(ofSize: 16, weight: .medium),
                color: textColor,
                displayMode: .inferred
            ),
            accessibilityIdentifier: "Thành công"
        )
        let description = EKProperty.LabelContent(
            text: "Đánh giá thành công!",
            style: .init(
                font: .systemFont(ofSize: 14, weight: .light),
                color: textColor,
                displayMode: .inferred
            ),
            accessibilityIdentifier: "Đánh giá thành công!"
        )

        let simpleMessage = EKSimpleMessage(
            title: title,
            description: description
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

extension UIScreen {
    var minEdge: CGFloat {
        return UIScreen.main.bounds.width
    }
}


struct Color {
    struct BlueGray {
        static let c50 = EKColor(rgb: 0xeceff1)
        static let c100 = EKColor(rgb: 0xcfd8dc)
        static let c300 = EKColor(rgb: 0x90a4ae)
        static let c400 = EKColor(rgb: 0x78909c)
        static let c700 = EKColor(rgb: 0x455a64)
        static let c800 = EKColor(rgb: 0x37474f)
        static let c900 = EKColor(rgb: 0x263238)
    }
    
    struct Netflix {
        static let light = EKColor(rgb: 0x485563)
        static let dark = EKColor(rgb: 0x29323c)
    }
    
    struct Gray {
        static let a800 = EKColor(rgb: 0x424242)
        static let mid = EKColor(rgb: 0x616161)
        static let light = EKColor(red: 230, green: 230, blue: 230)
    }
    
    struct Purple {
        static let a300 = EKColor(rgb: 0xba68c8)
        static let a400 = EKColor(rgb: 0xab47bc)
        static let a700 = EKColor(rgb: 0xaa00ff)
        static let deep = EKColor(rgb: 0x673ab7)
    }
    
    struct BlueGradient {
        static let light = EKColor(red: 100, green: 172, blue: 196)
        static let dark = EKColor(red: 27, green: 47, blue: 144)
    }
    
    struct Yellow {
        static let a700 = EKColor(rgb: 0xffd600)
    }
    
    struct Teal {
        static let a700 = EKColor(rgb: 0x00bfa5)
        static let a600 = EKColor(rgb: 0x00897b)
    }
    
    struct Orange {
        static let a50 = EKColor(rgb: 0xfff3e0)
    }
    
    struct LightBlue {
        static let a700 = EKColor(rgb: 0x0091ea)
    }
    
    struct LightPink {
        static let first = EKColor(rgb: 0xff9a9e)
        static let last = EKColor(rgb: 0xfad0c4)
    }
}

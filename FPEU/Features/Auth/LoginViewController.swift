//
//  LoginViewController.swift
//  FPEU
//
//  Created by son on 04/09/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class LoginViewController: FPViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var labelWrongInfo: UILabel!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        textUsername.rx.text
            .bind(to: viewModel.inUsername)
            .disposed(by: disposeBag)
        
        textPassword.rx.text
            .bind(to: viewModel.inPassword)
            .disposed(by: disposeBag)
        
        btnLogin.rx.tap
            .bind(to: viewModel.inLogin)
            .disposed(by: disposeBag)
        
        
        viewModel.outEnableLoginButton
            .bind(to: btnLogin.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.outHasLoggedInSuccess.subscribe(onNext: {hasLoggedIn in
            if (hasLoggedIn) {
                self.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
        
        viewModel.outErrorLogin.do(onNext: {error in
            self.labelWrongInfo.text = error
        })
        .map { $0 == nil }
        .bind(to: labelWrongInfo.rx.isHidden)
        .disposed(by: disposeBag)
        
        viewModel.errorDescription.skip(1).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
}

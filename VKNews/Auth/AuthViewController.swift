//
//  AuthViewController.swift
//  VKNews
//
//  Created by Eugene Kiselev on 20.12.2020.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
    }
}

extension AuthViewController {
    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
}


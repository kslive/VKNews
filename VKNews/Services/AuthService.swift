//
//  AuthService.swift
//  VKNews
//
//  Created by Eugene Kiselev on 20.12.2020.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: class {
    func authServiceShootShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appId = "7705405"
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.uiDelegate = self
        vkSdk.register(self)
    }
    
    func wakeUpSession() {
        let scope = ["wall, friends, photos"]
        VKSdk.wakeUpSession(scope) { [weak self] (state, error) in
            guard let self = self else { return }
            switch state {
            case .initialized:
                VKSdk.authorize(scope)
            case .authorized:
                self.delegate?.authServiceSignIn()
            default:
                self.delegate?.authServiceSignInDidFail()
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        delegate?.authServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShootShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}

//
//  ViewController.swift
//  SecureToken
//
//  Created by Sreelal Hamsavahanan on 21/07/20.
//  Copyright © 2020 EY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var secureText: UITextField!
    var isSecureTextHidden = true
    let errorInDecryptionMessage = "Error in decryption"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showToken(_ sender: Any) {
        let senderButton = sender as! UIButton
        if isSecureTextHidden {
            //Get the Key and IV from SecureKey and inject those into CryptoManager
            let secureKeys = SecureKeys()
            let cryptoManager = CryptoManager.shared
            cryptoManager.key = secureKeys.key
            cryptoManager.iv = secureKeys.iv
            do {
                //Fetch the secret value from encrypted plist file by passing encrypted file name , key of the secret value and the Bundle object
                let secureTextValue = try cryptoManager.fetchSecretValue(inResourceFile: "SecureToken", forKey: "demotoken", fromBundle: Bundle.main)
                secureText.text = secureTextValue ?? errorInDecryptionMessage
            } catch let error as CryptError {
                secureText.text = error.errorMessage()
            } catch {
                secureText.text = errorInDecryptionMessage
            }
            senderButton.setTitle("Hide Secret Token", for: .normal)
        } else {
            secureText.text = nil
            senderButton.setTitle("Show Secret Token", for: .normal)
        }
        isSecureTextHidden = !isSecureTextHidden
    }
    
}


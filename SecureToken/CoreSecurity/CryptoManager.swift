//
//  CryptoManager.swift
//  SecureToken
//
//  Created by Sreelal Hamsavahanan on 21/07/20.
//  Copyright © 2020 EY. All rights reserved.
//

import UIKit
import CryptoSwift
import CommonCrypto

enum CryptError: Error {
    case notReady
    case fileNotFound
    case invalidCipher
    case invalidIV
    case invalidKey
    func errorMessage() -> String {
        switch self {
        case .notReady:
            return "Unable to complete request. Please try again."
        case .fileNotFound:
            return "File not found.Please check whether the file has been added to bundle."
        case .invalidCipher:
            return "Cipher is invalid. Please check and try again."
        case .invalidIV:
            return "IV seems to be onvalid. Please check and try again."
        case .invalidKey:
            return "Key seems to be invalid. Please check and try again."
        }
    }
}

class CryptoManager: NSObject {
    public static let shared = CryptoManager()
    public var iv: [UInt8]?
    public var key: [UInt8]?
    private var bundleContext: Bundle?
    /// Secure file extension kind
    private var kind: String = "enc"
    
    /// To fetch the secret value from encrypted file
    /// - Parameters:
    ///   - resourceFile: Name of the encrypted file in Bundle
    ///   - forKey: Key of the Secret Value in Encrypted file
    ///   - fromBundle: Bundle object
    
    public func fetchSecretValue(inResourceFile resourceFile: String, forKey: String, fromBundle: Bundle?) throws -> String? {
        guard fromBundle != nil else { throw CryptError.notReady }
        self.bundleContext = fromBundle
        guard let plist = try getDictionaryFrom(resourceFile) else {
            throw CryptError.fileNotFound
        }
        
        return plist[forKey] as? String
    }
    
    
    /// This is a private method which decrypts the file and return the Plist data as Dictionary
    /// - Parameter res:  Name of the encrypted file in Bundle
    private func getDictionaryFrom(_ res: String) throws -> [String: Any]? {
        guard let secureFile = bundleContext?.url(forResource: res,
                                                  withExtension: kind) else {
            return nil
        }
        guard let key = key else { throw CryptError.invalidKey }
        guard let iv = iv else { throw CryptError.invalidIV }
        var format = PropertyListSerialization.PropertyListFormat.xml
        let clipper = try AES(key: key, blockMode: CBC(iv: iv))
        let data = try Data(contentsOf: secureFile)
        let decrypted = try clipper.decrypt(data.bytes)
        let secureContext = try PropertyListSerialization.propertyList(
            from: Data(decrypted),
            options: .mutableContainersAndLeaves,
            format: &format
        )
        return secureContext as? [String: Any]
    }
}

# How to keep secret  files encrypted in the project bundle of Xcode?

I have seen a lot of posts and queries regarding this topic and so thought of documenting the best approach which might be helpful for developers to add more security to the app.
It has been seen that sensitive information’s like API keys are mostly saving onto plist files.
If we are developing an application using Google APIs, then Google itself is providing all the API Keys and tokens as a plist file and developers are adding it to the project bundle directly
But what if any another developer got access to the IPA file, they can easily decode the IPA file and can access the plist files , it will become a security threat right?
So, here is a simple approach to keep the plist files encrypted always in source code and decryption will be done only by the code during runtime.

I am using AES encryption to encrypt the file , with an IV (initialization vector) and Key

###	Step 1 - Define a Key and IV (initialization vector).  
There is a common misconception that, the key for encryption should be memorable. This is wrong, it is only the password that should be memorable, and key can be any random string which you can keep secretly somewhere. 
So for this demo app I am using a random HEX key and IV generated from the following website:
https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx

###	Step 2 - Encrypt the plist file   
Before doing this encryption make sure to install Open SSL (https://www.openssl.org/) on your machine.
Now open terminal and execurte the following command to encrypt the file 

```sh
openssl enc -aes-128-cbc -K <KEY_VALUE> -iv <IV_VALUE> -nosalt -in <PLIST_FILE>.plist -out <PLIST_FILE>.enc
```
  
This command will generate the encrypted plist file with extension `enc`. You can define any custom extension here.
Now just to very that the generated encrypted file is valid, try execute the following command and check  whether the decrypted file is same as our original plist   file

```sh
openssl enc -d -aes-128-cbc -K <KEY_VALUE> -iv <IV_VALUE> -nosalt -in <PLIST_FILE>.enc -out SecureToken2.plist
```
###	Step 3  - Copy the encrypted file into the project.  
  > Add this encrypted file with extension `.enc` to the Xcode project bundle.

###	Steps4 – Read the encrypted value    
To read the value from the encrypted file , we need to first decrypt it and then parse the data to read the exact value.

						
In the demo app `CryptoManager` is the main class which will do this core operations.
`fetchSecretValue` method will read the encrypted file , decrypt it and then return the secret value.
I am using “CryptoSwift” to handle the cryptogrphy operations.
So , to decrypt the encrypted file we need to have the Key and IV .This is saved as `UINT8` array in the source code itself in `SecureKeys.swift`.
To convert our initial HEX key to UInt8 , you can use this website.   
https://cryptii.com/pipes/integer-encoder

This will convert the IV and Key in HEX to [uint8] array, which can be used to decrypt the file.	 

**Project Structure**

|  |  |
| ------ | ------ |
| **`CoreSecurity`** | This folder holds the classes specific for Cryptography |
| **`CryptoManager`** | This is the core class which implement methods to decryt the encrypted file and read the secret value.  |
| **`SecureKeys`**  | This class holds the Key and IV used for encrypting the plist file. This key and IV will be in [uint8] format |






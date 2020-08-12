# How to keep secret  files encrypted in the project Bundle of Xcode?

I have seen a lot of posts regarding this topic and so thought of writing this which might be helpful for developers to add more security to the app.
It has been seen that sensitive information’s like API keys are mostly saving onto plist files.
If we are developing an application using Google APIs, then Google itself is providing all the API Keys and tokens as a plist file and developers are adding it to the project bundle directly
But what if any another developer got access to the IPA file, they can easily decode the IPA file and can access the plist files , it will become a security threat right?
So, here is a simple approach to keep the plist files encrypted always in source code and decryption will be done only by the code during runtime.
I am using AES encryption to encrypt the file , with an IV (initialization vector) and Key




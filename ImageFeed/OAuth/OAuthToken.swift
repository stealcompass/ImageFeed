
  //OAuthToken.swift
  //ImageFeed

  //Created by Veniamin on 09.02.2023.


import UIKit


class OAuth2TokenStorage {

    var token: String? {
        get {
           return UserDefaults.standard.string(forKey: "token") ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}

//
//  AuthManager.swift
//  Spotify
//
//  Created by admin on 2/16/21.
//

import Foundation
import UIKit


final class AuthManager{
    static let shared = AuthManager()
    
    struct Constatns{
        static let clientId = "6fcfed95bdf04e8b98ea60e9c32ac9c3"
        static let cliendSecret = "4ea9172f22ec43ce8389706fb13ec9e1"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    private init(){
        
    }
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirect_url = "https://www.iosacademy.io"
        let string = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(Constatns.clientId)&scope=\(scopes)&redirect_uri=\(redirect_url)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    var isSigned: Bool{
    return accessToken != nil
    }
    
    private var accessToken : String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken : String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    private var tokenExpirationDate : Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool{
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes : TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToker(code: String , completion : @escaping (Bool) -> Void){
        guard let url = URL(string: Constatns.tokenAPIURL) else{
            return
        }
        
        var components = URLComponents()
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.iosacademy.io"),
    
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constatns.clientId + ":" + Constatns.cliendSecret
        let data = basicToken.data(using: .utf8)
        guard let base64data = data?.base64EncodedString()  else{
            print("Failed while getting base 64 ")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64data)", forHTTPHeaderField: "Authorization")
       let task =  URLSession.shared.dataTask(with: request){ [weak self] data , _ , error in
            guard let data = data , error == nil else{
                completion(false)
                return
            }
            
        do{
            let result = try JSONDecoder().decode(AuthResponse.self, from : data)
            
            self?.cacheToken(result: result)
            
            completion(true)
        }
        catch{
            print(error.localizedDescription)
            completion(false)
        }
            
        }
        task.resume()
    }
    
  
    
    public func cacheToken(result : AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}

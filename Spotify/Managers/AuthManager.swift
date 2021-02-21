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
    
    private var refreshingToken = false
    
    struct Constatns{
        static let clientId = "6fcfed95bdf04e8b98ea60e9c32ac9c3"
        static let cliendSecret = "4ea9172f22ec43ce8389706fb13ec9e1"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes  = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init(){
        
    }
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
       
        let string = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(Constatns.clientId)&scope=\(scopes)&redirect_uri=\(Constatns.redirectURI)&show_dialog=TRUE"
        
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
            URLQueryItem(name: "redirect_uri", value: Constatns.redirectURI),
    
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
    
    private var onRefreshingBlocks = [((String) -> Void)]()
    
    public func withValidToken(complition: @escaping(String) -> Void){
        
        guard !refreshingToken else {
            onRefreshingBlocks.append(complition)
            return
        }
        if shouldRefreshToken {
            refreshAccessTokenIfNeeded{ [weak self] success in

                    if let token = self?.accessToken , success{
                        complition(token)
                    
                }
                
            }
           
                
            }
        else if let token = accessToken {
            complition(token)
        }
        }
        
    

    
    public func refreshAccessTokenIfNeeded(completion :@escaping (Bool) -> (Void)){
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // Refreshin the token
        
        guard let url = URL(string: Constatns.tokenAPIURL) else{
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
    
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
        
        self?.refreshingToken = false
            guard let data = data , error == nil else{
                completion(false)
                return
            }
            
        do{
            let result = try JSONDecoder().decode(AuthResponse.self, from : data)
            self?.onRefreshingBlocks.forEach({
                $0(result.access_token)
            })
            self?.onRefreshingBlocks.removeAll()
            print("Successfully refreshed !")
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
        if let _ = result.refresh_token{
        UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}

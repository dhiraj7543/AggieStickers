

import UIKit
import Alamofire

class Api: NSObject {
    
    
    private static var api:Api!
    
    private static var apiLinker:ApiLinker!

    
    
    
    class func share() -> Api{
        if api == nil {
            api = Api()
            apiLinker = ApiLinker()
        }
        return api
    }
    

    
}

// Mark: - Auth Api
extension Api {
    // Mark: - Signup
  
    
    
    
    
    
    func signup(url: String, params: [String: AnyObject], completion:@escaping (Bool, String?, UserModel?)->Void) {
        
        Loader.shared.show()
        
        Api.apiLinker.requestMethod(method: .post).execute(url: url, parameters: { () -> [String : AnyObject]? in
            params
        }, onResponse: { (response) in
            Loader.shared.hide()
            if let resp = response{
                let status = resp["success"] as? Bool ?? false
                if status{
                    if resp["data"] != nil{
                        let status = resp["success"] as? Bool
                        if (status ?? false) {
                            let responseData = resp["data"] as! Dictionary<String, Any>
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: responseData , options: .prettyPrinted)
                                do {
                                    let jsonDecoder = JSONDecoder()
                                    let opportunitesListData = try jsonDecoder.decode(UserModel.self, from: jsonData)
                                    print(opportunitesListData)
                                                                    
                                    
                                    Loader.shared.hide()
                                    
                                    UserDefaults.standard.set(try? PropertyListEncoder().encode(opportunitesListData), forKey:DefaultsKeys.USER_DETAILS)
                                    
                                    if let data = UserDefaults.standard.value(forKey:DefaultsKeys.USER_DETAILS) as? Data {
                                        let userData = try? PropertyListDecoder().decode(UserModel.self, from: data)
                                    }
                                       
                                        completion(true, "", opportunitesListData)
                                    return
                                } catch {
                                    print("Unexpected error: \(error).")
                                    Loader.shared.hide()
                                    completion(false, error.localizedDescription, nil)
                                }
                                
                            } catch {
                                print(error.localizedDescription)
                                //  completion(false, nil)
                                completion(false, error.localizedDescription, nil)
                                Loader.shared.hide()
                            }
                           // completion(false, "", nil)
                            
                        } else{
                            let msg = resp["message"] ?? "Some error Occured"
                            completion(false, msg as! String, nil)
                        }
                    }
                    else{
                        let msg = resp["message"] ?? "Some error Occured"
                        completion(false, msg as! String, nil)
                        
                    }
                } else {
                    let msg = resp["message"] ?? "Some error Occured"
                    completion(false, msg as! String, nil)
                    
                }
            }}) { (error) in
                completion(false, error ?? "", nil)
                Loader.shared.hide()
        }
        
        
        
    }
    
    
    
    func fetchStickers(url: String, params: [String: AnyObject], completion:@escaping (Bool, String?, [StickerDataModel]?)->Void) {
        
        Loader.shared.show()
        
        Api.apiLinker.requestMethod(method: .post).execute(url: url, parameters: { () -> [String : AnyObject]? in
            params
        }, onResponse: { (response) in
            Loader.shared.hide()
            if let resp = response{
                let status = resp["success"] as? Bool ?? false
                if status{
                    if resp["data"] != nil{
                        let status = resp["success"] as? Bool
                        if (status ?? false) {
                            let responseData = resp["data"] as! [Dictionary<String, Any>]
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: responseData , options: .prettyPrinted)
                                do {
                                    let jsonDecoder = JSONDecoder()
                                    let opportunitesListData = try jsonDecoder.decode([StickerDataModel].self, from: jsonData)
                                    print(opportunitesListData)
                                                                    
                                    
                                    Loader.shared.hide()
                                    completion(true, "", opportunitesListData)
                                    return
                                } catch {
                                    print("Unexpected error: \(error).")
                                    Loader.shared.hide()
                                    completion(false, error.localizedDescription, nil)
                                }
                                
                            } catch {
                                print(error.localizedDescription)
                                completion(false, error.localizedDescription, nil)
                                Loader.shared.hide()
                            }
                            
                            
                        } else{
                            let msg = resp["message"] ?? "Some error Occured"
                            completion(false, msg as! String, nil)
                        }
                    }
                    else{
                        let msg = resp["message"] ?? "Some error Occured"
                        completion(false, msg as! String, nil)
                        
                    }
                } else {
                    let msg = resp["message"] ?? "Some error Occured"
                    completion(false, msg as! String, nil)
                    
                }
            }}) { (error) in
                completion(false, error ?? "", nil)
                Loader.shared.hide()
        }
        
        
        
    }
    

    
   
}



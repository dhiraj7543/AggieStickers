//
//  ApiManager.swift
//  ThumbARide
//
//  Created by Charanjit Singh on 02/04/19.
//  Copyright © 2019 Charanjit Singh. All rights reserved.
//

import UIKit
import Alamofire


class ApiManager: NSObject {
    static let  shared:ApiManager = ApiManager()
    func requestApi(url:String, parameters:Dictionary<String, Any>, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void){
      //  if IS_LOG_ENABLED{
            print("url = \(url)")
            print("parameters = \(parameters)")
    //    }
        
        
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
         //   if IS_LOG_ENABLED {
                print("response = \(response)")
      //      }
            
            
           // if response.error != nil {
           //    completion(nil,"Something went wrong.")
                // Loader.shared.hide()
          //      return
          //  }
            
            response.result.ifSuccess {
                /// Success
                
                if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
                    
                    let status = (dict["status"]) as? Int
                    if status == 0 {
                        completion(dict, dict["message"] as? String ?? "")
                        return
                        
                    }else{
                        completion(nil, dict["message"] as? String ?? "")
                    }
                }
            }
            response.result.ifFailure {
                /// Failed
                if let error = response.result.error {
                    print(error)
                   completion(nil,"Something went wrong.")
                    
                    return
                }
            }
            
        })
    }
    
    func addVideo(url:String, parameters:Dictionary<String, String>, videoUrl:URL, videoName:String, thumb:UIImage, thumbName:String, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void, uploadProgress:@escaping (_ progress:Double)->Void){
        
        Alamofire.upload (
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                   // if IS_LOG_ENABLED {
                        print("\(key) = \(value)")
                  //  }
                    
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                multipartFormData.append(videoUrl, withName: videoName , fileName: "video.mp4", mimeType: "video/mp4")
                multipartFormData.append(thumb.jpegData(compressionQuality: 0.4) ?? Data(), withName: thumbName, fileName: "image.png", mimeType:  "image/png")
                
        },
            to: url,
            headers: [:],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload,_, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                        uploadProgress(progress.fractionCompleted)
                    })
                    
                    upload.responseJSON { (response) in
                        
                        
                        if response.error != nil {
                            completion(nil,"We are facing some technical issue. Please try again later.")
                            // Loader.shared.hide()
                            return
                        }
                        
                        response.result.ifSuccess {
                            /// Success
                            
                            if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
                                
                                let status = (dict["status"]) as? Int
                                if status == 0 {
                                    completion(dict, (dict["message"] as? String) ?? "")
                                    return
                                    
                                }else{
                                    completion(nil,"We are facing some technical issue. Please try again later.")
                                }
                            }
                        }
                        response.result.ifFailure {
                            /// Failed
                            if let error = response.result.error {
                                print(error)
                                completion(nil,"We are facing some technical issue. Please try again later.")
                                
                                return
                            }
                        }
                        
                    }
                case .failure(_):
                    completion(nil,"We are facing some technical issue. Please try again later.")
                }
        }
        )
    }
    
    func uploadFile(url:String, parameters:Dictionary<String, String>,data:Data, fileName:String, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void, uploadProgress:@escaping (_ progress:Double)->Void) {
        
        Alamofire.upload (
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    //if IS_LOG_ENABLED {
                        print("\(key) = \(value)")
                //    }
                    
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                multipartFormData.append(data, withName: fileName, fileName: "test.pdf", mimeType:  "application/pdf")
                
        },
            to: url,
            headers: [:],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload,_, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                        uploadProgress(progress.fractionCompleted)
                    })
                    upload.responseJSON { (response) in
                        
                        
                        if response.error != nil {
                            completion(nil,"We are facing some technical issue. Please try again later.")
                            // Loader.shared.hide()
                            return
                        }
                        
                        response.result.ifSuccess {
                            /// Success
                            
                            if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
                                
                                let status = (dict["status"]) as? Int
                                if status == 0 {
                                    completion(dict, (dict["message"] as? String) ?? "")
                                    return
                                    
                                }else{
                                    completion(nil,"We are facing some technical issue. Please try again later.")
                                }
                            }
                        }
                        response.result.ifFailure {
                            /// Failed
                            if let error = response.result.error {
                                print(error)
                                completion(nil,"We are facing some technical issue. Please try again later.")
                                
                                return
                            }
                        }
                        
                    }
                case .failure(_):
                    completion(nil,"We are facing some technical issue. Please try again later.")
                }
        }
        )
    }
    
    
    func uploadImage(url:String, parameters:Dictionary<String, String>,image:UIImage?, imageName:String, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void, uploadProgress:@escaping (_ progress:Double)->Void){
        
        
        Alamofire.upload (
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                   // if IS_LOG_ENABLED {
                        print("\(key) = \(value)")
                 //   }
                    
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                if let img = image {
                    multipartFormData.append(img.jpegData(compressionQuality: 0.4) ?? Data(), withName: imageName, fileName: "image.png", mimeType:  "image/png")
                }
                
                
        },
            to: url,
            headers: [:],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload,_, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                        uploadProgress(progress.fractionCompleted)
                    })
                    upload.responseJSON { (response) in
                        
                        
                        if response.error != nil {
                            completion(nil,"We are facing some technical issue. Please try again later.")
                            // Loader.shared.hide()
                            return
                        }
                     //   if IS_LOG_ENABLED {
                            print(response)
                     //   }
                        response.result.ifSuccess {
                            /// Success
                            upload.uploadProgress { progress in
                                
                                print(progress.fractionCompleted)
                            }
                            if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
                                
                                let status = (dict["status"]) as? Int
                                if status == 0 {
                                    completion(dict, (dict["message"] as? String) ?? "")
                                    return
                                    
                                }else{
                                     completion(nil,"We are facing some technical issue. Please try again later.")
                                }
                            }
                        }
                        response.result.ifFailure {
                            /// Failed
                            if let error = response.result.error {
                                print(error)
                                completion(nil,"We are facing some technical issue. Please try again later.")
                                
                                return
                            }
                        }
                        
                    }
                case .failure(_):
                    completion(nil,"We are facing some technical issue. Please try again later.")
                }
        }
        )
    }
    
    //Save device token
  
 
}

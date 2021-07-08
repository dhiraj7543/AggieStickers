
import UIKit
import Alamofire

public typealias StringResponseHandler = (_ success:Bool ,_ message:String?,_ error:String?)->()
public typealias JsonResponseHandler = (_ success:Bool ,_ response:AnyObject?,_ error:String?)->()

/*
 *Request Type Methods
 */
enum ApiMethod {
    case get
    case post
    case httpPost
    case stringGet
    case stringPost
    case put
}



/*
 *Class For Server Tasks
 */
class ApiLinker: NSObject {
    
    fileprivate var netErrorMessage = "Your request can not be completed because your are not connected to internet. Please verify your Internet Connection and Try Again"
    fileprivate var netErrorTitle = "Connection Error!"
    
    fileprivate var isProgress:Bool = false
    fileprivate var progressMessage:String!
    fileprivate var requestCode:Int!
    fileprivate var requestMethod = ApiMethod.post
    fileprivate var object:UIViewController!
    fileprivate var url:String!
    fileprivate var headers = [String:String]()
    
    fileprivate var progressView = UIView()
   
    init(object:UIViewController) {
        self.object = object
    }
    
    
    override init() {
        
    }
    
    /*
     *Use for progress message
     *Set TRUE if progress is required else FALSE
     */
    func setProgress(isProgress:Bool)->ApiLinker{
        self.isProgress = isProgress
        return self
    }
    
    /*
     *Set Message on progress bar to show
     */
    func withMessage(message:String)->ApiLinker{
        self.progressMessage = message
        return self
    }
    
    /*
     *Set Request Method Type to Cummunicate with server api
     */
    func requestMethod(method:ApiMethod)->ApiLinker{
        self.requestMethod = method
        return self
    }
    
    /*
     *Execute the task  acc. to current set parameters
     *Useful in case of post methods
     */
    func execute(url:String,parameters: () -> [String:AnyObject]?,onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
        self.url = url
        
        //Check Internet Connection first
        //        if !AppDelegate.share().reachability.isReachable{
        //           displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
        //            return
        //        }
        //
        
        if isProgress {
            showProgress()
        }
        
        let params = parameters()
        
        switch requestMethod {
        case .get:
            get(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .post:
            post(params: params!, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .httpPost:
            httpPost(params: params, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .stringGet:
            stringGet(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .stringPost:
            stringPost(params: params, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
        case .put:
            put(params: params, response: { (response) in
                onResponse(response)
                if self.isProgress{
                    self.hideProgress()
                }
            },error: { (error) in
                onError(error)
                if self.isProgress{
                    self.hideProgress()
                }
            })
            break
        }
        
        
    }
    
    /*
     *Execute the task  acc. to current set parameters
     *Useful in case of post and get methods
     */
    func execute(url:String,onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
        
        
        //Check Internet Connection first
        //        if !AppDelegate.share().reachability.isReachable{
        //            displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
        //            return
        //        }
        //
        self.url = url
        if isProgress {
            showProgress()
        }
        
        
        
        switch requestMethod {
        case .get:
            get(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .post:
            post(params: nil, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .httpPost:
            httpPost(params: nil, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .stringGet:
            stringGet(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        default:
            break
        }
        
        
    }
    
    /*
     *Execute the task  acc. to current set parameters
     *Useful in case of post multipart request methods
     */
    func execute(url:String,image:UIImage,withName:String,parameters: @escaping () -> [String:AnyObject],onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
        self.url = url
        
        //Check Internet Connection first
        //        if !AppDelegate.share().reachability.isReachable{
        //            displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
        //            return
        //        }
        
        
        if isProgress {
            showProgress()
        }
        
        
        DispatchQueue.global(qos: .background).async {
            self.postRequestMultipart(withName: withName,image: image, parameters: parameters(), response: { (resp) in
                onResponse(resp)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (err) in
                onError(err)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            
        }
    }
    
    func executeVideo(url:String,videoData:Data,withName:String,parameters: @escaping () -> [String:AnyObject],onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
        self.url = url
        
        //Check Internet Connection first
        //        if !AppDelegate.share().reachability.isReachable{
        //            displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
        //            return
        //        }
        
        
        if isProgress {
            showProgress()
        }
        
        
        DispatchQueue.global(qos: .background).async {
            self.postRequestMultipartVideo(withName: withName, videoData: videoData, parameters: parameters(), response: { (resp) in
                onResponse(resp)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (err) in
                if self.isProgress {
                    self.hideProgress()
                }
            })
            
        }
    }
    
    
//    func executeVideo(url:String,video:Data,withName:String,parameters: @escaping () -> [String:AnyObject],onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
//        self.url = url
//        
//        //Check Internet Connection first
//        //        if !AppDelegate.share().reachability.isReachable{
//        //            displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
//        //            return
//        //        }
//        
//        
//        if isProgress {
//            showProgress()
//        }
//        
//        
//        DispatchQueue.global(qos: .background).async {
//            self.postRequestMultipart(withName: withName,image: image, parameters: parameters(), response: { (resp) in
//                onResponse(resp)
//                if self.isProgress {
//                    self.hideProgress()
//                }
//            }, error: { (err) in
//                onError(err)
//                if self.isProgress {
//                    self.hideProgress()
//                }
//            })
//            
//        }
//    }
    /*
     *Show progress to user for current task
     */
    fileprivate func showProgress(){
        // An animated UIImage
        
        //SVProgressHUD.setDefaultMaskType(.black)
       // SVProgressHUD.show()
    }
    
    /*
     *Hide/dismiss progress
     */
    fileprivate func hideProgress(){
        
         //progressView.removeFromSuperview()
        //SVProgressHUD.dismiss()
    }
    
    
    /*
     *For create get request to the server
     */
    fileprivate func get(response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        Alamofire.request(url ,headers: headers).responseString{ response in }.responseJSON{ respons in
            
            
            if (respons.result.error == nil){
                let responseObject = respons.result.value
                response(responseObject as AnyObject)
                
            }else{
                error(respons.result.error.debugDescription)
                
            }
        }
    }
    fileprivate func stringGet(response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        Alamofire.request(url ,headers: headers).responseString{resposne  in
            if (resposne.result.error == nil){
                let responseObject = resposne.result.value
                response(responseObject as AnyObject)
                
            }else{
                error(resposne.result.error.debugDescription)
                
            }
        }
    }
    
    /*
     *For create put request to the server
     */
    fileprivate func put(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        
        Alamofire.request(url,method:.put,parameters: parameters,/*encoding: JSONEncoding.default,*/headers:getHeaders()).responseString{response in}
            .responseJSON{ resp in
                
                if (resp.result.error == nil){
                    let responseObject = resp.result.value
                    
                    response(responseObject as AnyObject)
                }else{
                    error(resp.result.error.debugDescription)
                }
        }
        
    }
    
    /*
     *For create post request to the server
     */
    fileprivate func post(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        print(parameters)
      
       
        
        
        Alamofire.request(url, method: .post, parameters: parameters, headers: getHeaders())
            .responseString{response in
            print("Responseeee-------",response)
            

            }
            .responseJSON{ resp in
                
                if (resp.result.error == nil){
                    let responseObject = resp.result.value
                    
                    response(responseObject as AnyObject)
                } else{
                    error(resp.result.error.debugDescription)
                }
        }
        
        
    }
    
    /*
     *For create post request to the server
     */
    fileprivate func stringPost(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        
        Alamofire.request(url,method:.post,parameters: parameters,/*encoding: JSONEncoding.default,*/headers:getHeaders()).responseString{responses in
            
            
            if (responses.result.error == nil){
                let responseObject = responses.result.value
                
                response(responseObject as AnyObject)
            }else{
                error(responses.result.error.debugDescription)
            }
        }
        
    }
    
    /*
     *For create http post request to the server
     */
    fileprivate func httpPost(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(options:[]), headers: headers).responseJSON { (resp) in
            
            
            switch resp.result {
            case .failure(let err):
                print(err)
                
                if let data = resp.data, let responseString = String(data: data, encoding: .utf8) {
                    error(responseString)
                }
            case .success(let responseObject):
                response(responseObject as AnyObject)
                
            }
        }
    }
    
    /**
     *Create multipart post request to server
     */
    fileprivate func    postRequestMultipart(withName:String,image:UIImage!,parameters:[String:AnyObject],response: @escaping (_ response:AnyObject)->Void,error:@escaping (_ error:String)->Void){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: withName, fileName: "file0.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data!(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { resp in
                    
                    
                    if let JSON = resp.result.value {
                        print("JSON: \(JSON)")
                        response(JSON as AnyObject)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                error(encodingError.localizedDescription)
                
                
            }
            
        }
    }
    
    
    fileprivate func postRequestMultipartVideo(withName:String,videoData:Data!,parameters:[String:AnyObject],response: @escaping (_ response:AnyObject)->Void,error:@escaping (_ error:String)->Void){
        Alamofire.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(videoData, withName: withName, fileName: "video.mp4", mimeType: "video/mp4")
            for (key, value) in parameters {
                multipartFormData.append(value.data!(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: url, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { resp in
                    
                    
                    if let JSON = resp.result.value {
                        print("JSON: \(JSON)")
                        response(JSON as AnyObject)
                    }
                }
//                upload.responseJSON { response in
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                        response(JSON as AnyObject)
//                    } else {
//                        completion(false)
//                        print(response)
//                    }
//                }
            case .failure(let encodingError):
                print(encodingError)
                error(encodingError.localizedDescription)
            }
        })
    }
    
    
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: withName, fileName: "file0.jpeg", mimeType: "public.movie")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data!(using: String.Encoding.utf8.rawValue)!, withName: key)
//            }
//        }, to:url)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//                })
//
//                upload.responseJSON { resp in
//
//
//                    if let JSON = resp.result.value {
//                        print("JSON: \(JSON)")
//                        response(JSON as AnyObject)
//                    }
//                }
//
//            case .failure(let encodingError):
//                //self.delegate?.showFailAlert()
//                print(encodingError)
//                error(encodingError.localizedDescription)
//
//
//            }
//
//        }
    
    
    
    
    func download(downloadUrl:String,fileName:String,dirName:String, completion: ((Bool, String?) -> Void)?){
        if isProgress{
            showProgress()
        }
        let destination: DownloadRequest.DownloadFileDestination  = {_,_ in
            
           /* if(createDirectoryAtDocumentDirectory(dirName))
            {
                print("btk created")
            }else{
                print("error when creating btk")
                
            }
            */
            /* let directoryUrl = getDocumentDirectoryStringPath().appendingFormat("/%@", dirName)
             let file = directoryUrl.appendingFormat("/%@", fileName)*/
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(dirName)
            let file = directoryURL.appendingPathComponent(fileName, isDirectory: false)
            
            return (file, [.createIntermediateDirectories, .removePreviousFile])
            
        }
        
        Alamofire.download(downloadUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil, to:destination ).downloadProgress { (progress) in
            print(progress)
            }.responseString { (response) in
                if self.isProgress{
                    self.hideProgress()
                }
                if response.result.error == nil {
                    completion!(true,response.result.value)
                } else {
                    print(response.result.error!.localizedDescription)
                    completion!(false,nil)
                }
        }
    }
    
    
    
    
    func setHeader(headers:[String:String]) -> ApiLinker{
        self.headers = headers
       return self
    }
    
    fileprivate func getHeaders() -> [String:String] {
        return headers
    }
    
    
    fileprivate func displayAlert(title: String, andMessage message: String)
    {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}


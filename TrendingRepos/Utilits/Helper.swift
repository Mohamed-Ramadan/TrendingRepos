//
//  Helper.swift
//  Jadeer
//
//  Created by taha hamdi on 1/5/20.
//  Copyright © 2020 taha hamdi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
protocol isInternet {
    func isConnected(connected:Bool)
}
class Helper: NSObject {
    private static let defaults:UserDefaults = UserDefaults.standard
    public static func getFromDefault(key:String)->String
    {
        if let value:String  = defaults.string(forKey: key)
        {
            return value
            
        }
        return ""
    }
    public static func isValidEmail(txtString:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: txtString)
    }
    
    public static func validateUsername(str: String) -> Bool {
        do
        {
            let regex = try NSRegularExpression(pattern: "^(?=.{2,20}$)[a-zA-Z0-9]+ ?[a-zA-Z0-9]+$", options: .caseInsensitive)
            if regex.matches(in: str, options: [], range: NSMakeRange(0, str.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
    
    static func checkInternetConnection(isConnected:isInternet) {
        isConnectingToInternet(completion: {(isConnect) -> Void in
            if isConnect {
                isConnected.isConnected(connected: true)
            } else {
                //                if let topVC = Helper.getCurrentViewController(), !topVC.isKind(of: NoInternertVC.self)  {
                //                     showInternetMessage(isConnect: isConnected)
                //                }
            }
        })
    }
    
    
    public static func customTitleViewWithTitle(_ title: String) -> UIView {
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 12),
            imageView.widthAnchor.constraint(equalToConstant: 12)
        ])
        imageView.backgroundColor = .clear
        imageView.image = #imageLiteral(resourceName: "titleViewDicor")
        if (Helper.getCurrentLanguage() == "ar") {
            imageView.transform = imageView.transform.rotated(by: CGFloat(Double.pi/2))
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: AppFontName.GESSTwoBold, size: 20)
        titleLabel.textColor = UIColor.seaweedGreen
        
        let hStack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        hStack.spacing = -3
        hStack.alignment = .top
        
        return hStack
    }
    
    
    public static func showInternetMessage(isConnect:isInternet? = nil) {
        //        let internetVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoInternertVC") as! NoInternertVC
        //        internetVC.isConnected = isConnect
        //        internetVC.modalPresentationStyle = .overFullScreen
        //        internetVC.modalTransitionStyle = .crossDissolve
        //        UIApplication.topViewController()?.present(internetVC, animated: true, completion: nil)
    }
    
    public static func showBlockedMessage(_ msg:String) {
        //        let blockedVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlockedViewController") as! BlockedViewController
        //        blockedVC.msg = msg
        //        blockedVC.modalPresentationStyle = .overFullScreen
        //        blockedVC.modalTransitionStyle = .crossDissolve
        //        UIApplication.topViewController()?.present(blockedVC, animated: true, completion: nil)
    }
    
    // Returns the most recently presented UIViewController (visible)
    class func getCurrentViewController() -> UIViewController? {
        
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    // Returns the navigation controller if it exists
    class func getNavigationController() -> UINavigationController? {
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    public static func isConnectingToInternet( completion: @escaping (Bool) -> ())
    {
        let reachability = Reachability()!
        
        var isConnet = false
        reachability.whenReachable =
            { reachability in
                if reachability.connection == .wifi
                {
                    print("Reachable via WiFi")
                }
                else
                {
                    print("Reachable via Cellular")
                }
                isConnet = true
                completion(isConnet)
                
        }
        reachability.whenUnreachable =
            { _ in
                print("Not reachable")
                isConnet = false
                completion(isConnet)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    public static func moveToProvider(providerID:Int,navigationController:UINavigationController!)
    {
        //        let providerVC = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "DetaisVC") as! DetaisVC
        //        providerVC.projectId = "\(providerID)"
        //        // providerVC.setSalonId(id: salonId,isEdit: isEdit,isReorder:isReorder)
        //        navigationController.pushViewController(providerVC, animated: true)
    }
    
    public static func playVideo(videoId:String,controller:UIViewController) {
        
    }
    
    @objc public static func fileComplete(note: NSNotification) {}
    
    //    public static func getTitle(titles:[LanguageModel],key:String)-> String
    //    {
    //        if let filteredIndex = titles.firstIndex(where: { $0.key == key }) {
    //            return titles[filteredIndex].name
    //        }else{
    //            return ""
    //        }
    //    }
    
    public static func isPreIphoneX()-> Bool
    {
        switch UIDevice().type {
        case .iPhone6, .iPhone7 ,.iPhone7Plus, .iPhone8,.iPhone8Plus, .iPhone6S ,.iPhone6Plus ,.iPhone6SPlus:
            return true
        default:
            return false
        }
    }
    public static func moveToVideos(salonId:Int,navigationController:UINavigationController!)
    {
        //        let providerVC = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "MediaPlayerVC") as! MediaPlayerVC
        //        // providerVC.setSalonId(id: salonId,isEdit: isEdit,isReorder:isReorder)
        //        navigationController.pushViewController(providerVC, animated: true)
    }
    
    public static func moveToNewsPage(navigationController:UINavigationController!)
    {
        //        let providerVC = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LatestNewsVC") as! LatestNewsVC
        //        // providerVC.setSalonId(id: salonId,isEdit: isEdit,isReorder:isReorder)
        //        navigationController.pushViewController(providerVC, animated: true)
    }
    
    public static func moveToMapsPage(navigationController:UINavigationController!)
    {
        //        let providerVC = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "MapsViewController") as! MapsViewController
        //        navigationController.pushViewController(providerVC, animated: true)
    }
    
    public static func moveToNewsDetailsPage(articleId:String,navigationController:UINavigationController!)
    {
        //        let NewPageVC = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "NewPageVC") as! NewPageVC
        //        NewPageVC.articleId = articleId
        //        // providerVC.setSalonId(id: salonId,isEdit: isEdit,isReorder:isReorder)
        //        navigationController?.pushViewController(NewPageVC, animated: true)
    }
    
    public static func showFloatyMessage(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            
            alert.dismiss(animated: true)
        }
    }
    
    public static func showLanguageDialog(language:String,controller:UIViewController,onComplete: @escaping (String) -> ()) {
        
        let alert = UIAlertController(title: nil, message:"Are You Sure You Want Change Language".localized, preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler:{ (action) -> Void in
            onComplete("cancel")
        })
        
        let arabicButton = UIAlertAction(title: "العربية", style: .default, handler: { (action) -> Void in
            if Helper.getCurrentLanguage() == "ar" {
                onComplete("Nothing")
                return
            }
            
            Helper.setAppLanguage(value: "ar")
            onComplete("Arabic")
        })
        
        let englishButton = UIAlertAction(title: "English", style: .default, handler: { (action) -> Void in
            if Helper.getCurrentLanguage() == "en" {
                onComplete("Nothing")
                return
            }
            
            Helper.setAppLanguage(value: "en")
            onComplete("English")
        })
        
        alert.addAction(arabicButton)
        alert.addAction(englishButton)
        alert.addAction(cancelButton)
        controller.present(alert, animated: true, completion: nil)
    }
    
    public static func ShowHome() {
        
        //let sb = UIStoryboard(name: "Settings", bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        // delegate.window?.rootViewController = sb.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
    }
    // savein default
    public static func saveInDefault(key:String,value:String)
    {
        defaults.set(value , forKey: key)
    }
    public static func getCurrentLanguage()->String {
        return Helper.getFromDefault(key: "language").isEmpty ? "en" : Helper.getFromDefault(key: "language")
    }
    public static func setAppLanguage(value:String)
    {
        defaults.set(value , forKey: "language")
    }
    
    public class func removeAllUserDefualtKey(){
        //        Helper.saveInDefault(key: "userId", value: "")
        Helper.saveInDefault(key: "token", value: "")
    }
}

class Alerts {
    static func showActionsheet(viewController: UIViewController, title: String?, message: String?, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
        }
        if let popoverController = alertViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            //            viewController.present(popoverController, animated: true, completion: nil)
        }
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    class func alertWith(title: String, message: String, controller: UIViewController, actionTitle: String, actionStyle: UIAlertAction.Style, withCancelAction: Bool, completion: @escaping () -> Void) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: { (action) in
            completion()
        }))
        alert.view.tintColor = UIColor.hexColor(string: "023f82")
        if withCancelAction {
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        }
        controller.present(alert, animated: true, completion: nil)
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

@objcMembers class Utilities: NSObject {
    static let shared = Utilities()
    
    func displayError(_ error: NSError, originViewController: UIViewController) {
        OperationQueue.main.addOperation {
            originViewController.dismiss(animated: true) {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                originViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

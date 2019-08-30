import Flutter
import UIKit
    
public class SwiftFlutterSharePlugin: NSObject, FlutterPlugin {
    
  private var result: FlutterResult?
  private var viewController: UIViewController?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_share", binaryMessenger: registrar.messenger())
    let viewController: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
    let instance = SwiftFlutterSharePlugin(viewController: viewController)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
  init(viewController: UIViewController?) {
    super.init()

    self.viewController = viewController
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    if (self.result != nil) {
        self.result!(FlutterError(code: "multiple_request", message: "Cancelled by a second request", details: nil))
        self.result = nil
    }
    
    if ("share" == call.method) {
        self.result = result
        result(share(call: call))
    } else if ("shareFile" == call.method) {
        self.result = result
        result(shareFile(call: call))
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
    
    public func share(call: FlutterMethodCall) -> Bool {
        let args = call.arguments as? [String: Any?]
        
        let title = args!["title"] as? String
        let text = args!["text"] as? String
        let linkUrl = args!["linkUrl"] as? String
        
        if (title == nil || title!.isEmpty) {
            return false
        }
        
        var sharedItems : Array<NSObject> = Array()
        var textList : Array<String> = Array()
        
        // text
        if (text != nil && text != "") {
            textList.append(text!)
        }
        // Link url
        if (linkUrl != nil && linkUrl != "") {
            textList.append(linkUrl!)
        }
        
        var textToShare = ""
        
        if (!textList.isEmpty) {
            textToShare = textList.joined(separator: "\n\n")
        }
        
        sharedItems.append((textToShare as NSObject?)!)
        
        let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
        
        // Subject
        if (title != nil && title != "") {
            activityViewController.setValue(title, forKeyPath: "subject");
        }
        
        DispatchQueue.main.async {
            self.viewController?.present(activityViewController, animated: true, completion: nil)
        }
        
        return true
    }
    
    public func shareFile(call: FlutterMethodCall) -> Bool {
        let args = call.arguments as? [String: Any?]
        
        let title = args!["title"] as? String
        let text = args!["text"] as? String
        let filePath = args!["filePath"] as? String
        
        if (title == nil || title!.isEmpty || filePath == nil || filePath!.isEmpty) {
            return false
        }
        
        var sharedItems : Array<NSObject> = Array()
        
        // text
        if (text != nil && text != "") {
            sharedItems.append((text as NSObject?)!)
        }
        
        // File url
        if (filePath != nil && filePath != "") {
            let filePath = URL(fileURLWithPath: filePath!)
            sharedItems.append(filePath as NSObject);
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
        
        // Subject
        if (title != nil && title != "") {
            activityViewController.setValue(title, forKeyPath: "subject");
        }
        
        DispatchQueue.main.async {
            self.viewController?.present(activityViewController, animated: true, completion: nil)
        }
        
        return true
    }
}

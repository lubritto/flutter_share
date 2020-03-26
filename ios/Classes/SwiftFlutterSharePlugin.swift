import Flutter
import UIKit
    
public class SwiftFlutterSharePlugin: NSObject, FlutterPlugin {
    
  private var result: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_share", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SwiftFlutterSharePlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
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
            self.present(activityViewController: activityViewController)
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
          self.present(activityViewController: activityViewController)
        }
        
        return true
    }
  
    private func present(activityViewController: UIActivityViewController) {
      guard let topViewController = UIApplication.topViewController() else { return }
      if UIDevice.current.userInterfaceIdiom == .pad {
        // On iPad, UIActivityViewController must be presented using a popover.
        // Since every popover must have a point of origin, we set it to be the center bottom
        // mimicking the behaviour of iPhones.
        activityViewController.popoverPresentationController?.sourceView = topViewController.view
        let popover = UIPopoverController.init(contentViewController: activityViewController)
        popover.present(
          from: CGRect(x: topViewController.view.frame.width / 2, y: topViewController.view.frame.size.height, width: 0, height: 0),
          in: topViewController.view,
          permittedArrowDirections: .any,
          animated: true
        )
      } else {
        topViewController.present(activityViewController, animated: true)
      }
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

//
//  ViewController.swift
//  UI_internalWebVC
//
//  Created by Andrii Bryzhnychenko on 8/21/19.
//  Copyright © 2019 itomych. All rights reserved.
//

import UIKit
import SafariServices

private struct Constants {
    static let safariString = "open with Safari"
    static let safariVCString = "open with Safari view controller"
    static let webViewString = "open with webView"
}

class ViewController: UIViewController {
    @IBOutlet var labeledTextView: UITextView!
    @IBOutlet var plainTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabeledTextView()
        setupPlainTextField()
    }

    func setupLabeledTextView() {
        let string = """
        This is an example app that demonstates different ways to open links within iOS app
        1. The first way is to \(Constants.safariString)
        2. The second way is to \(Constants.safariVCString)
        3. The third way is to \(Constants.webViewString)
        """
        let attributedString = NSMutableAttributedString(string: string)
        let url = URL(string: "https://www.apple.com")!
        
        // Set the substring to be the link
        if let safariRange: Range = string.range(of: Constants.safariString) {
            attributedString.setAttributes([.link: url, .font : UIFont.systemFont(ofSize: 15)], range: NSRange(safariRange, in: string))
        }
        if let safariVCRange: Range = string.range(of: Constants.safariVCString) {
            attributedString.setAttributes([.link: url, .font : UIFont.systemFont(ofSize: 15)], range: NSRange(safariVCRange, in: string))
        }
        if let webViewRange: Range = string.range(of: Constants.webViewString) {
            attributedString.setAttributes([.link: url, .font : UIFont.systemFont(ofSize: 15)], range: NSRange(webViewRange, in: string))
        }
        

        labeledTextView.attributedText = attributedString
        labeledTextView.isUserInteractionEnabled = true
        labeledTextView.isEditable = false
        labeledTextView.delegate = self
        
        // Set how links should appear: blue and underlined
        labeledTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    func setupPlainTextField() {
        let string = plainTextView.text ?? ""
        let url = URL(string: "https://www.apple.com")!
        let attributedString = NSMutableAttributedString(string: string)
        
        if let range = string.range(of: "lamet") {
            attributedString.setAttributes([.link: url, .font : UIFont.systemFont(ofSize: 15)], range: NSRange(range, in: string))
        }
        
        plainTextView.attributedText = attributedString
        plainTextView.isUserInteractionEnabled = true
        plainTextView.isEditable = false
        plainTextView.delegate = self
        
        // Set how links should appear: blue and underlined
        plainTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let text = textView.text.prefix(characterRange.upperBound).suffix(characterRange.upperBound - characterRange.lowerBound)
        switch String(text) {
        case Constants.safariString:
            return true
        case Constants.safariVCString:
            let config = SFSafariViewController.Configuration()
            config.barCollapsingEnabled = true
            config.entersReaderIfAvailable = false
            
            let controller = SFSafariViewController(url: URL, configuration: config)
            controller.dismissButtonStyle = .close
            controller.preferredBarTintColor = .clear
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        case Constants.webViewString:
            let controller = WebViewContainer(url: URL)
            present(controller, animated: true, completion: nil)
        default:
            return false
        }
        
        return false
    }
}

extension ViewController: SFSafariViewControllerDelegate {
    /*!
     @abstract Allows you to exclude certain UIActivityTypes from the UIActivityViewController presented when the user taps the action button.
     @discussion Called when the view controller is about to show a UIActivityViewController after the user taps the action button.
     @param URL the URL of the current web page.
     @param title the title of the current web page.
     @result Returns an array of any UIActivityType that you want to be excluded from the UIActivityViewController.
     */
    func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
        return []
    }
    
    /*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
     func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
     
     }
    
    /*! @abstract Invoked when the initial URL load is complete.
     @param didLoadSuccessfully YES if loading completed successfully, NO if loading failed.
     @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
     to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
     */
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("ok")
    }
    
    /*! @abstract Called when the browser is redirected to another URL while loading the initial page.
     @param URL The new URL to which the browser was redirected.
     @discussion This method may be called even after -safariViewController:didCompleteInitialLoad: if
     the web page performs additional redirects without user interaction.
     */
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
    }
}

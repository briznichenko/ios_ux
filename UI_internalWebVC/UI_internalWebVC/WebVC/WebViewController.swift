//
//  WebViewController.swift
//  UI_internalWebVC
//
//  Created by Andrii Bryzhnychenko on 8/21/19.
//  Copyright © 2019 itomych. All rights reserved.
//

import UIKit
import WebKit

final class WebViewContainer: UINavigationController {
    init(url: URL) {
        let rootController = WebViewController(url: url)
        super.init(rootViewController: rootController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

private final class WebViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        return webView
    }()
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        webView.load(URLRequest(url: url))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finish(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func finish(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

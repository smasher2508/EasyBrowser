//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Barkha Maheshwari on 29/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com", "stackoverflow.com"]
    var websiteSubURL: String?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        let url = URL(string: "https://" + websiteSubURL!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        addToolBarItems()
        addObservor()
    }

    func addToolBarItems() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresher = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        toolbarItems = [forwardButton, spacer, backButton, spacer, progressButton, spacer, refresher]
        navigationController?.isToolbarHidden = false
    }

    func addObservor() {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }

    @objc func openTapped() {
        let actionSheet = UIAlertController(title: "Choose the website you wanna go to...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            actionSheet.addAction(UIAlertAction(title: website, style: .default, handler: goToSite))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }

    func goToSite(action: UIAlertAction) {
        guard let actionTitle = action.title, let url = URL(string: "https://" + actionTitle) else {
            return
        }
        webView.load(URLRequest(url: url))
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func showAlert() {
        let alertVC = UIAlertController(title: "UnTrusted Site", message: "You are not allowed to visit here.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    // Allows us to visit only the pages we consider as safe
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        showAlert()
        decisionHandler(.cancel)
    }
}

//
//  WebKitArticleTab.swift
//  Vienna
//
//  Copyright 2020 Tassilo Karge
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

class WebKitArticleTab: BrowserTab, ArticleContentView {

    // make articleWebView property something like an "override" of BrowserTab's webView property
    var articleWebView: WebKitArticleView
    override var webView: CustomWKWebView {
        get {
            return articleWebView
        }
        set {
            if let newArticleWebView = newValue as? WebKitArticleView {
                self.webView = newArticleWebView
            }
        }
    }

    var listView: ArticleViewDelegate?

    var articles: [Article] = [] {
        didSet {
            guard !articles.isEmpty else {
                self.articleWebView.clearHTML()
                return
            }

            articleWebView.deleteHtmlFile()
            let htmlPath = articleWebView.converter.prepareArticleDisplay(self.articles)

            webView.loadFileURL(htmlPath, allowingReadAccessTo: htmlPath.deletingLastPathComponent())
        }
    }

    override var tabUrl: URL? {
        get { super.tabUrl }
        set { super.tabUrl = newValue }
    }

    override var loadingProgress: Double {
        didSet {
            updateLoadingProgress(oldValue)
        }
    }

    @objc
    init() {
        self.articleWebView = WebKitArticleView.init(frame: CGRect.zero)
        super.init()
        self.registerNavigationEndHandler { [weak self] _ in self?.articleWebView.deleteHtmlFile() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.isEditable = false
        hideAddressBar(true)
    }

    func printDocument(_ sender: Any) {
        // TODO
    }

    func scrollToTop() {
        // TODO
    }

    func scrollToBottom() {
        // TODO
    }

    func makeTextSmaller(_ sender: Any) {
        // TODO
    }

    func makeTextLarger(_ sender: Any) {
        // TODO
    }

    // MARK: gui

    override func activateAddressBar() {
        // TODO: ignored intentionally. Find more elegant solution
    }

    override func activateWebView() {
        // TODO: ignored intentionally. Find more elegant solution
    }

    func updateLoadingProgress(_ oldProgress: Double) {
        guard let animationLayer = self.view.layer else {
            return
        }

        let toValue = max(0.75, Float(loadingProgress))
        let fromValue = max(0.50, animationLayer.presentation()?.opacity ?? animationLayer.opacity)

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = fromValue < toValue ? 0.3 : 0.05
        animationLayer.add(animation, forKey: "opacityAnimation")

        animationLayer.opacity = toValue
    }

    // MARK: Navigation delegate

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // TODO: how do forms work in the article view?
        // i.e. navigationAction.navigationType == .formSubmitted or .formResubmitted
        // TODO: in the future, we might want to allow limited browsing in the primary tab
        if navigationAction.navigationType == .linkActivated {
            // prevent navigation to links opened through klick
            decisionHandler(.cancel)
            // open in new preferred browser instead, or the alternate one if the option key is pressed
            let openInPreferredBrower = !navigationAction.modifierFlags.contains(.option)
            // TODO: maybe we need to add an api that opens a clicked link in foreground to the AppController
            NSApp.appController.open(navigationAction.request.url, inPreferredBrowser: openInPreferredBrower)
        } else {
            decisionHandler(.allow)
        }
    }
}

import SwiftUI



struct BusView: View {
    
    @EnvironmentObject var appState: AppState // 注入狀態
    
    @StateObject private var WebBus = WebView_Provider(
        initialURL: "https://www.taiwanbus.tw/eBUSPage/Query/RouteQuery.aspx?key=%E5%AE%9C%E8%98%AD%E5%A4%A7%E5%AD%B8&lan=C",
        userAgent: .desktop
    )
    
    @State private var showOverlay = true
    @State private var overlayText: LocalizedStringKey = "loading"
    // @State private var overlayText = "載入中..."
    
    let jsHideElements = """
    const selectors = [
        "#topNav",
        "head",
        "#main > div.container > nav",
        "#main > div.container > div.srch-input",
        "#main > div.page-title.page-title-srch",
        "#main > a",
        "#footer > a",
        "#footer > div.footer-info",
        "#btnFPMenuOpen",
        "#MasterPageBodyTag > a",
        "#main > div.bus-header.container-md > div:nth-child(1) > div.bus-title.mb-1.mb-md-3 > div.bus-title__icon > i"
    ];
    selectors.forEach(sel => {
        const el = document.querySelector(sel);
        if (el) el.style.display = 'none';
    });
    const bodyDiv = document.querySelector("#MasterPageBodyTag > div");
    if (bodyDiv) bodyDiv.style.paddingTop = "10px";
    """
    // --- JS：暗黑模式樣式 ---
    let jsDarkMode = """
    document.lastElementChild.appendChild(document.createElement('style')).textContent = `
      html { filter: invert(0.90) !important; }
      video, img, div.image, div.bus-header-section,
      div.bus-title.mb-1.mb-md-3, i.fas.fa-bus::before, i.fas.fa-wheelchair::before {
          filter: invert(100%) !important;
      }
      #main > div.bus-header.container-md > div:nth-child(1) > div.bus-title.mb-1.mb-md-3 > h2,
      #main > div.bus-header.container-md > div:nth-child(1) > div.bus-title.mb-1.mb-md-3 > div.bus-title__text {
          color: white !important;
      }
    `;
    """
    
    // --- 系統是否為深色模式 ---
    @Environment(\.colorScheme) var colorScheme
    
    public var body: some View {
        AppBar_Framework(title: "Bus") {
            ZStack {
                WebViewContainer(webView: WebBus.webView)
                    .opacity(WebBus.isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: WebBus.isVisible)
                    .ignoresSafeArea(edges: .bottom)
                        
                ProgressOverlay(isVisible: $showOverlay, text: overlayText)
            }
            .onAppear {
                WebBus.setVisible(false)
                            
                WebBus.onPageFinished = { url in
                    guard let url = url else { return }
                                
                    // --- 語系自動切換 ---
                    var modifiedURL = url
                    if url.contains("rno=") { // 僅在詳細頁才切換
                        if Locale.current.language.languageCode?.identifier.contains("zh") == true {
                            if url.contains("&lan=E") {
                                modifiedURL = url.replacingOccurrences(of: "&lan=E", with: "&lan=C")
                                WebBus.load(url: modifiedURL)
                                return
                            }
                        } else {
                            if url.contains("&lan=C") {
                                modifiedURL = url.replacingOccurrences(of: "&lan=C", with: "&lan=E")
                                WebBus.load(url: modifiedURL)
                                return
                            }
                        }
                    }
                                
                    // --- 若為 eBUS 頁面才注入 JS ---
                    if url.contains("www.taiwanbus.tw/eBUSPage/") {
                        WebBus.evaluateJS(jsHideElements) { _ in
                            if colorScheme == .dark {
                                WebBus.evaluateJS(jsDarkMode) { _ in
                                    showPage()
                                }
                            } else {
                                showPage()
                            }
                        }
                    }
                }
                            
                // --- 載入進度監聽 ---
                WebBus.onProgressChanged = { progress in
                    overlayText = LocalizedStringKey("loading")
                    // overlayText = "載入中... \(Int(progress * 100))%"
                    WebBus.setVisible(false)
                    if progress < 1.0 {
                        showOverlay = true
                    }
                }
            }
        }
    }
    
    // 顯示畫面（模仿 Android 的 hideProgressOverlay + setVisibility）
    private func showPage() {
        DispatchQueue.main.async {
            WebBus.setVisible(true)
            showOverlay = false
        }
    }
}

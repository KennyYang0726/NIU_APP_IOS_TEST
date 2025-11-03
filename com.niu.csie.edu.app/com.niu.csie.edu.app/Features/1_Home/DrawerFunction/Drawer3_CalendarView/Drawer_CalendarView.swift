import SwiftUI
import PDFViewer

struct Drawer_CalendarView: View, DownloadManagerDelegate {
    
    @State private var loadingPDF: Bool = false
    @State private var progressValue: Float = 0.0
    @State private var pdfReady: Bool = false
    @ObservedObject var downloadManager = DownloadManager.shared()
    
    let pdfURL = "https://academic.niu.edu.tw/var/file/3/1003/img/1202/280557416.pdf"
    
    var body: some View {
        ZStack {
            VStack {
                if loadingPDF {
                    VStack {
                        ProgressView(value: $progressValue, visible: $loadingPDF)
                        Text("正在下載 PDF...")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                } else if pdfReady {
                    // ✅ 使用自定義嵌入版
                    EmbeddedPDFView(pdfURLString: pdfURL)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                } else {
                    // 預設載入時的 placeholder（還沒準備好）
                    Text("正在準備 PDF...")
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            if fileExistsInDirectory() {
                self.pdfReady = true
            } else {
                self.downloadPDF(pdfUrlString: self.pdfURL)
            }
        }
    }
    
    
    // MARK: - File Handling
    private func fileExistsInDirectory() -> Bool {
        guard let cachesDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let lastPathComponent = URL(string: pdfURL)?.lastPathComponent else {
            return false
        }
        let url = cachesDirectoryUrl.appendingPathComponent(lastPathComponent)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    private func downloadPDF(pdfUrlString: String) {
        guard let url = URL(string: pdfUrlString) else { return }
        downloadManager.delegate = self
        downloadManager.downloadFile(url: url)
    }
    
    
    // MARK: - DownloadManagerDelegate
    func downloadDidFinished(success: Bool) {
        DispatchQueue.main.async {
            self.loadingPDF = false
            if success {
                self.pdfReady = true
            } else {
                print("PDF 下載失敗")
            }
        }
    }
    
    func downloadDidFailed(failure: Bool) {
        DispatchQueue.main.async {
            self.loadingPDF = false
            print("PDFCatalogueView: Download failure")
        }
    }
    
    func downloadInProgress(progress: Float, totalBytesWritten: Float, totalBytesExpectedToWrite: Float) {
        DispatchQueue.main.async {
            self.loadingPDF = true
            self.progressValue = progress
        }
    }
}

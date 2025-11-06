import SwiftUI
import PDFViewer



struct Drawer_CalendarView: View, DownloadManagerDelegate {
    
    @State private var loadingPDF: Bool = false
    @State private var progressValue: Float = 0.0
    @State private var pdfReady: Bool = false
    @State private var pdfURL: String = ""
    @ObservedObject var downloadManager = DownloadManager.shared()
    @ObservedObject var appSettings = AppSettings()  // 用來取 semester
    
    
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
                    // 使用自定義嵌入版
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
            let semester = appSettings.semester
            let path = "行事曆/\(semester)"
            print(path)
            // 從 Firebase 讀取對應的 PDF 連結
            FirebaseDatabaseManager.shared.readData(from: path) { value in
                if let urlString = value as? String {
                    self.pdfURL = urlString
                    if self.fileExistsInDirectory(urlString: urlString) {
                        self.pdfReady = true
                    } else {
                        self.downloadPDF(pdfUrlString: urlString)
                    }
                }
            }
        }
    }
    
    
    // MARK: - File Handling
    private func fileExistsInDirectory(urlString: String) -> Bool {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileName = URL(string: urlString)?.lastPathComponent ?? "calendar.pdf"
        return fileManager.fileExists(atPath: cachesDirectory.appendingPathComponent(fileName).path)
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

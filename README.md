<img style="width:64px" src="https://user-images.githubusercontent.com/13403218/228755470-34ae31ec-eb1a-4c1c-9461-bdbaa04d9fef.png" />

# NIU App (iOS)
> Swift / SwiftUI version — Application for National Ilan University

這是一個給宜大學生使用的 iOS APP，整合了大部分常使用到的功能，包含數位學習 M 園區、分數查詢、課表、活動報名、畢業門檻查詢、選課、請假，並提供公車動態查詢與 Zuvio。


## 目錄
- [App Store 連結](#)
- [安裝](#安裝)
  - [Xcode](#xcode)
  - [iOS IPA](#ios-ipa)
- [使用方式](#使用方式)
- [功能](#功能)


## 安裝
### Xcode
1. 安裝 [Xcode](https://developer.apple.com/xcode/) （建議版本：26.0.1 以上）
2. 使用以下指令將專案 clone 至本地端：
   ```bash
   git clone https://github.com/KennyYang0726/NIU_APP_IOS.git
   ```
3. 進入專案資料夾後，開啟：
   - `NIU_APP.xcodeproj` 或  
   - `NIU_APP.xcworkspace`  
4. **Xcode 會自動根據 `Package.resolved` 下載並安裝所有依賴項目。**

---

### CocoaPods
本專案部分模組透過 **CocoaPods** 管理（例如 Firebase、Google MLKit 等）。

若 Xcode 未自動載入依賴，請手動執行以下步驟：

1. 安裝 CocoaPods（若尚未安裝）：
   ```bash
   sudo gem install cocoapods
   ```
2. 在專案目錄中初始化與安裝 Pods：
   ```bash
   pod install
   ```
3. 安裝完成後，請使用 `.xcworkspace` 開啟專案。

> ✅ 建議始終以 `.xcworkspace` 方式開啟，以確保 CocoaPods 依賴正常載入。

### iOS IPA
- [Release 下載連結](https://github.com/KennyYang0726/NIU_APP_IOS/releases/tag/iOS)  
  可直接下載測試用 IPA 或使用 TestFlight 測試版本。


## 使用方式
1. 安裝並開啟應用程式  
2. 使用宜蘭大學帳號密碼登入  
3. 進入主畫面後即可瀏覽各項校園功能  

> ⚠️ 僅限擁有宜蘭大學帳號的學生登入。


## 功能
| 功能列表 | 功能概述 |
| -------- | -------- |
| **M園區** | 觀看上課教材、繳交作業 |
| **成績查詢** | 查詢期中、學期成績 |
| **我的課表** | 顯示上課地點、時間、授課老師 |
| **活動報名** | 報名宜大校園活動 |
| **聯絡我們** | 回報錯誤、提供建議 |
| **畢業門檻** | 查詢畢業所需條件 |
| **選課系統** | 開啟校內選課頁面 |
| **公車查詢** | 即時查詢公車動態 |
| **Zuvio** | 保留作業與簽到等常用功能 |
| **請假系統** | 進入校務行政請假頁面 |
| **校園公告** | 查看最新公告 |
| **學校行事曆** | 查看校內行事曆 |
| **成就系統** | 蒐集成就圖鑑 |
| **使用說明** | 使用指南與教學 |

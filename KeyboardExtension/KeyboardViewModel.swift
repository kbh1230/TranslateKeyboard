import Foundation

class KeyboardViewModel: ObservableObject {
    
    private let translationService = TranslationService()
    private var debounceTask: Task<Void, Never>?
    
    @Published var englishText: String = ""
    @Published var japaneseText: String = ""
    @Published var isLoading: Bool = false
    
    // 입력된 텍스트가 바뀔 때마다 호출
    func textDidChange(_ text: String) {
        
        // 마지막 단어만 추출 (공백 기준)
        let lastWord = text.components(separatedBy: " ").last ?? ""
        
        // 한국어가 아니면 번역 안함
        guard isKorean(lastWord), !lastWord.isEmpty else {
            englishText = ""
            japaneseText = ""
            return
        }
        
        // 이전 번역 작업 취소
        debounceTask?.cancel()
        
        // 0.5초 후에 번역 실행
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run { isLoading = true }
            
            do {
                let result = try await translationService.translateBoth(text: lastWord)
                await MainActor.run {
                    self.englishText = result.english
                    self.japaneseText = result.japanese
                    self.isLoading = false
                }
            } catch {
                await MainActor.run { isLoading = false }
            }
        }
    }
    
    // 한국어 감지
    private func isKorean(_ text: String) -> Bool {
        for scalar in text.unicodeScalars {
            if scalar.value >= 0xAC00 && scalar.value <= 0xD7A3 {
                return true
            }
        }
        return false
    }
}
import Foundation

struct TranslationService {
    
    // 번역 함수 (영어 또는 일본어)
    func translate(text: String, to targetLang: String) async throws -> String {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.mymemory.translated.net/get?q=\(encodedText)&langpair=ko|\(targetLang)"
        
        guard let url = URL(string: urlString) else {
            throw TranslationError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TranslationResponse.self, from: data)
        
        return response.responseData.translatedText
    }
    
    // 영어 + 일본어 동시에 번역
    func translateBoth(text: String) async throws -> (english: String, japanese: String) {
        async let english = translate(text: text, to: "en")
        async let japanese = translate(text: text, to: "ja")
        return try await (english, japanese)
    }
}

// 에러 종류
enum TranslationError: Error {
    case invalidURL
    case noData
}

// API 응답 구조
struct TranslationResponse: Codable {
    let responseData: ResponseData
    
    struct ResponseData: Codable {
        let translatedText: String
    }
}
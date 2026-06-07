import UIKit

class KeyboardViewController: UIInputViewController {
    
    private let viewModel = KeyboardViewModel()
    private let translationBar = TranslationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTranslationBar()
        setupObservers()
    }
    
    private func setupTranslationBar() {
        translationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(translationBar)
        
        NSLayoutConstraint.activate([
            translationBar.topAnchor.constraint(equalTo: view.topAnchor),
            translationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            translationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            translationBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 영어 번역어 탭했을 때
        translationBar.onSelectEnglish = { [weak self] word in
            self?.insertTranslation(word)
        }
        
        // 일본어 번역어 탭했을 때
        translationBar.onSelectJapanese = { [weak self] word in
            self?.insertTranslation(word)
        }
    }
    
    private func setupObservers() {
        // 번역 결과 감지
        viewModel.$englishText.combineLatest(viewModel.$japaneseText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] english, japanese in
                self?.translationBar.update(english: english, japanese: japanese)
            }
            .store(in: &cancellables)
        
        // 로딩 상태 감지
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.translationBar.setLoading(isLoading)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // 번역어를 입력창에 삽입
    private func insertTranslation(_ word: String) {
        // 현재 입력 중인 마지막 단어 삭제
        if let currentText = textDocumentProxy.documentContextBeforeInput {
            let lastWord = currentText.components(separatedBy: " ").last ?? ""
            for _ in 0..<lastWord.count {
                textDocumentProxy.deleteBackward()
            }
        }
        // 번역어 + 공백 삽입
        textDocumentProxy.insertText(word + " ")
    }
    
    // 텍스트 변경 감지
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        let currentText = textDocumentProxy.documentContextBeforeInput ?? ""
        viewModel.textDidChange(currentText)
    }
}
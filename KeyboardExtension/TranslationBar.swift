import UIKit

class TranslationBar: UIView {
    
    var onSelectEnglish: ((String) -> Void)?
    var onSelectJapanese: ((String) -> Void)?
    
    // 영어 버튼
    private let englishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("...", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 일본어 버튼
    private let japaneseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("...", for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 0.23, blue: 0.19, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 구분선
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        
        addSubview(englishButton)
        addSubview(divider)
        addSubview(japaneseButton)
        
        NSLayoutConstraint.activate([
            // 영어 버튼 (왼쪽)
            englishButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            englishButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            englishButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            // 구분선 (중앙)
            divider.centerXAnchor.constraint(equalTo: centerXAnchor),
            divider.centerYAnchor.constraint(equalTo: centerYAnchor),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 20),
            
            // 일본어 버튼 (오른쪽)
            japaneseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            japaneseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            japaneseButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
        ])
        
        englishButton.addTarget(self, action: #selector(englishTapped), for: .touchUpInside)
        japaneseButton.addTarget(self, action: #selector(japaneseTapped), for: .touchUpInside)
    }
    
    // 번역 결과 업데이트
    func update(english: String, japanese: String) {
        englishButton.setTitle(english.isEmpty ? "..." : "🇺🇸 \(english)", for: .normal)
        japaneseButton.setTitle(japanese.isEmpty ? "..." : "🇯🇵 \(japanese)", for: .normal)
    }
    
    // 로딩 상태
    func setLoading(_ loading: Bool) {
        englishButton.setTitle(loading ? "번역 중..." : "...", for: .normal)
        japaneseButton.setTitle(loading ? "번역 중..." : "...", for: .normal)
    }
    
    @objc private func englishTapped() {
        guard let title = englishButton.title(for: .normal),
              title != "..." else { return }
        let word = title.replacingOccurrences(of: "🇺🇸 ", with: "")
        onSelectEnglish?(word)
    }
    
    @objc private func japaneseTapped() {
        guard let title = japaneseButton.title(for: .normal),
              title != "..." else { return }
        let word = title.replacingOccurrences(of: "🇯🇵 ", with: "")
        onSelectJapanese?(word)
    }
}
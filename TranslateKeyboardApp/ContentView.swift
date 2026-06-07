import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                // 앱 아이콘 영역
                Image(systemName: "keyboard")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding(.top, 50)
                
                Text("번역 키보드")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("한국어를 입력하면\n영어/일본어로 자동 번역됩니다")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.horizontal)
                
                // 설정 안내
                VStack(alignment: .leading, spacing: 16) {
                    Text("키보드 활성화 방법")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Text("1")
                            .frame(width: 24, height: 24)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        Text("아이폰 설정 앱 열기")
                            .font(.body)
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Text("2")
                            .frame(width: 24, height: 24)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        Text("일반 → 키보드 → 새 키보드 추가")
                            .font(.body)
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Text("3")
                            .frame(width: 24, height: 24)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        Text("번역 키보드 선택 후 완전한 접근 허용")
                            .font(.body)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // 설정 열기 버튼
                Button(action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("설정 열기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
# Handy Talk

Flutter + Firebase + Cursor 기반으로 개발된, 친구와 실시간으로 손글씨/드로잉 메모를 주고받는 서비스입니다.

---

## 🛠️ 주요 기술 스택
- **Flutter**: 크로스플랫폼 UI 프레임워크
- **Firebase**: 인증, 실시간 데이터베이스, 스토리지, 푸시 알림 등 백엔드
- **Cursor**: AI 기반 Pair Programming 및 코드 생산성 향상
- **Google/Kakao 로그인**: 소셜 인증

---

## 📱 주요 기능
- 구글/카카오 소셜 로그인
- 닉네임/프로필 설정 및 관리
- 친구 페어링(상호 팔로우) 기반 메모 송수신
- 손글씨/드로잉 캔버스 (감성적 UI)
- 달력 기반 히스토리/메모 관리
- 푸시 알림, 위젯

---

## 🚀 프로젝트 실행 방법

1. **의존성 설치**
   ```sh
   flutter pub get
   ```
2. **Firebase 설정 파일 추가**
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
3. **iOS CocoaPods 설치**
   ```sh
   cd ios
   pod install
   cd ..
   ```
4. **앱 실행**
   ```sh
   flutter run -d <device_id>
   ```

---

> 커서는 신이야.

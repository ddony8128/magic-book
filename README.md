# 마법의 고민해결 책 (Magic Book)

Flutter 앱 프로젝트.

## APK 빌드 & 핸드폰 설치

### 1. APK 빌드

```bash
cd C:\not_system\project\26-02\magic_book
flutter build apk --release
```

생성 위치: `build\app\outputs\flutter-apk\app-release.apk` (약 65MB)

### 2. 핸드폰에 설치하는 방법

**방법 A: APK 파일 복사 후 설치**

1. 위 경로의 `app-release.apk`를 USB로 연결한 폴더 공유, 또는 카카오톡/드라이브 등으로 **핸드폰으로 전송**
2. 핸드폰에서 파일 관리자(또는 다운로드)에서 `app-release.apk` 실행
3. **출처를 알 수 없는 앱** 설치 허용이 필요하면 설정에서 허용 후 다시 설치
4. 설치 완료 후 앱 실행

**방법 B: USB 디버깅으로 바로 설치 (ADB)**

1. 핸드폰에서 **개발자 옵션** 켜기 → **USB 디버깅** 켜기
2. USB로 PC와 연결 후 “USB 디버깅 허용” 확인
3. PC에서:

```bash
cd C:\not_system\project\26-02\magic_book
adb devices
flutter install --release
```

또는 APK만 설치:

```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

- `adb`가 없으면 [Android Platform Tools](https://developer.android.com/studio/releases/platform-tools) 설치 후 `adb`를 PATH에 추가

### 3. 빌드 명령어 참고

| 명령어 | 설명 |
|--------|------|
| `flutter build apk --release` | 단일 APK (기본 arm64-v8a 등) |
| `flutter build apk --split-per-abi` | CPU별로 나눈 APK (용량 작음, 여러 개 생성) |
| `flutter build appbundle` | Play 스토어 업로드용 AAB |

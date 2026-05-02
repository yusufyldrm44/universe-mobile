# UniVerse Mobile

Üniversite öğrencilerini tek bir evrende buluşturan platformun Flutter ile yazılmış native mobil uygulaması. Web ile aynı backend'e bağlanır.

## Stack

- Flutter (Material 3, Inter fontu)
- Dio — HTTP istekleri
- Provider — durum yönetimi
- go_router — yönlendirme (auth-aware redirect)
- flutter_secure_storage — JWT saklama
- socket_io_client — anlık mesajlaşma (Hafta 11)
- google_fonts — Inter
- image_picker — fotoğraf yükleme
- intl — tarih formatı

## Klasör yapısı

```
lib/
  main.dart                  MultiProvider + MaterialApp.router
  utils/
    constants.dart           kApiUrl, kSocketUrl, AppColors
    theme.dart               Inter fontu + Material 3 teması
    router.dart              go_router + auth-aware redirect
  services/
    api_service.dart         Dio singleton, JWT interceptor, 401 handler
    auth_service.dart        ChangeNotifier, login/register/logout, secure_storage
  screens/
    splash_screen.dart       Token kontrolü, /login veya /home'a yönlendirir
    auth/
      login_screen.dart      Editoryal split-screen tasarım
      register_screen.dart   .edu.tr doğrulama + min 6 karakter şifre
    home/
      home_screen.dart       BottomNavigationBar (5 sekme) + AppBar
      feed_screen.dart       Ana sayfa karşılama akışı
    listings/
      listings_screen.dart   Placeholder — Hafta 8
    events/
      events_screen.dart     Placeholder — Hafta 7
    messages/
      messages_screen.dart   Placeholder — Hafta 11
    profile/
      profile_screen.dart    Editoryal stil profil + çıkış
    widgets/
      placeholder_view.dart  Ortak placeholder bileşeni
```

## Backend sözleşmesi

Backend `http://localhost:5000/api` üzerinden çalışır.

- `POST /api/auth/register` — `{ full_name, university_email, password, university, department }` → `{ message, token, user }`
- `POST /api/auth/login` — `{ university_email, password }` → `{ message, token, user }`
- Tüm korumalı uçlar için header: `Authorization: Bearer {token}`
- Üniversite e-postası **sadece `.edu.tr`** olabilir
- 401 durumunda istemci otomatik olarak çıkış yapar ve `/login` ekranına yönlendirir

## Localhost adresleri

`lib/utils/constants.dart` içinde:

```dart
const String kApiUrl = 'http://10.0.2.2:5000/api';
const String kSocketUrl = 'http://10.0.2.2:5000';
```

| Platform | Adres |
| --- | --- |
| Android emülatörü | `10.0.2.2` (host makinedeki localhost'a bu IP üzerinden erişilir) |
| iOS simülatörü | `localhost` direkt çalışır |
| Web | `localhost` direkt çalışır |
| Fiziksel cihaz | Bilgisayarın yerel ağ IP'si (örn. `192.168.1.20`) |

> Not: Geliştirme için Android'de `10.0.2.2` zorunludur. Fiziksel cihazda test ederken `constants.dart` içindeki adresi güncelle.

## Android network konfigürasyonu

Localhost cleartext (HTTP) erişimi için aşağıdaki ayarlar dosyada hazırdır:

- `android/app/src/main/AndroidManifest.xml` → `android:usesCleartextTraffic="true"` ve `android:networkSecurityConfig="@xml/network_security_config"`
- `android/app/src/main/res/xml/network_security_config.xml` → 10.0.2.2, localhost, 127.0.0.1 için cleartext izni

## Kurulum

```bash
flutter pub get
```

### Backend'i başlat

Backend repo'sundan (`universe-backend`) `npm run dev` ile `http://localhost:5000` üzerinde çalıştır.

### Uygulamayı çalıştır

```bash
# Android emülatörü
flutter run -d emulator-5554

# iOS simülatörü
flutter run -d iPhone

# Web
flutter run -d chrome

# Bağlı olan cihazları listelemek için
flutter devices
```

## Tasarım kuralları

- Renk paleti: `primary #1A3C5E`, `background #FAF8F4` (stone-50), `text #1C2833`, `danger #EF4444`
- Tüm metinler Türkçe
- Hiçbir emoji kullanılmaz
- Material 3 + Inter fontu zorunlu
- AppBar elevation 0, surface tint yok
- Input ve buton border radius 12
- ScrollPhysics olarak `BouncingScrollPhysics`
- Bütün ekranlarda `SafeArea`
- Hata kutuları kırmızı arka plan + `Icons.error_outline`
- Backend'in döndürdüğü `response.data['message']` yakalanır ve kullanıcıya gösterilir

## Yol haritası

- Hafta 7 — Etkinlikler
- Hafta 8 — İlanlar
- Hafta 11 — Mesajlaşma (socket_io_client)

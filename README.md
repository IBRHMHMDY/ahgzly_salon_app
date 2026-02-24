# Ahgzly Salon App (Customer) — Flutter MVP

Customer mobile app for salon browsing and appointment booking.

## ✨ Features
- Authentication (Login / Register)
- Browse branches & services
- Select employee & available time slots
- Create appointment
- My appointments list
- Profile (view / update)

## 🧱 Tech Stack
- Flutter
- flutter_bloc + equatable
- Dio
- go_router
- get_it
- flutter_secure_storage
- Clean-ish layered structure (data / domain / presentation)

## Setup

### 1) Install dependencies
```bash
flutter pub get
```

### 2) Run with API base url (ENV)
You MUST provide BASE_URL when running outside your local network.

#### Android Emulator
```bash
flutter run --dart-define=ENV_NAME=dev --dart-define=BASE_URL=http://10.0.2.2:8000/api
```
#### Physical device (same Wi-Fi as backend)
```bash
flutter run --dart-define=ENV_NAME=dev --dart-define=BASE_URL=http://YOUR_LOCAL_IP:8000/api
```
#### Production
```bash
flutter build apk --release --dart-define=ENV_NAME=prod --dart-define=BASE_URL=https://api.yourdomain.com/api
```
## Auth & Route Guards

    Protected routes require authenticated state.

    On 401 Unauthorized, token is cleared and user is redirected to Login.

## 🧭 Project Structure
    lib/
    core/
        config/
        di/
        network/
        routing/
        utils/
        widgets/
    features/
        auth/
        booking/
        catalog/
        appointments/
        home/
        splash/
## Roadmap

- Appointment cancellation / reschedule

- Push notifications

- Offline caching for catalog

- Unit tests & bloc tests

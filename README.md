# 🛍️ Dukan (دكان) — E-Commerce Mobile Application

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-brightgreen)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC%20%2F%20Cubit-blue)](https://bloclibrary.dev/)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

**Dukan** is an enterprise-grade, high-performance E-Commerce mobile application built with **Flutter**, strictly following **Clean Architecture**, **SOLID principles**, and **Domain-Driven Design (DDD)** concepts. It delivers a seamless, reactive shopping experience with support for multiple languages, responsive landscape layouts, and secure payment processing.

---

## 📑 Table of Contents

- [Features](#-features)
- [Architecture & Design Principles](#-architecture--design-principles)
- [Tech Stack & Dependencies](#-tech-stack--dependencies)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Running Tests](#-running-tests)
- [Responsive & Landscape Design](#-responsive--landscape-design)
- [Localization](#-localization)

---

## 🌟 Features

### 🔐 1. Authentication & Security
- **Dual Authentication**: Tab-based Sign In and Sign Up screens with real-time form validation.
- **Secure Token Storage**: Persisted session tokens via `flutter_secure_storage`.
- **Automatic Auth Routing**: Seamless redirect and session verification via `SplashScreen` and `GoRouter`.

### 🛍️ 2. Home & Discovery
- **Promotional Banners & Carousels**: Engaging promotional banners and quick action sections.
- **Category Browsing**: Horizontal category chips and filtering.
- **Dynamic Product Grid**: Pull-to-refresh, shimmer loading states, and cached network images.

### 🔍 3. Product Details
- Detailed view with image gallery, pricing, description, and ratings.
- Quantity selection and dynamic total price preview.
- Direct "Add to Cart" integration with real-time status feedback.

### 🛒 4. Cart & Order Management
- **Cart Operations**: Increment, decrement, delete items, and clear cart.
- **Dynamic Price Breakdown**: Real-time subtotal, delivery fee, taxes, and total calculations.
- **Checkout Flow**: Multi-step checkout with address selection and payment options.
- **Online Payment WebView**: Integrated payment gateway with callback handling.
- **Order Tracking & History**: Order status badges, order timeline, and granular order details.

---

## 📐 Architecture & Design Principles

The application is architected following Uncle Bob's **Clean Architecture** with strict layer isolation:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│          (Views, Widgets, Cubits & State Models)        │
└───────────────────────────┬────────────────────────────┘
                            │ depends on
┌───────────────────────────▼────────────────────────────┐
│                      Domain Layer                      │
│            (Entities, Use Cases, Repositories)         │
└───────────────────────────▲────────────────────────────┘
                            │ implemented by
┌───────────────────────────┴────────────────────────────┐
│                       Data Layer                       │
│     (Models, Remote/Local DataSources, Repositories)   │
└───────────────────────────┘
```

### Key Engineering Practices:
- **SOLID Principles**: Single responsibility, open for extension, interface segregation, and dependency inversion across all layers.
- **Strict Domain Isolation**: Domain entities and use cases have zero external UI or data layer dependencies.
- **Functional Error Handling**: Returns `Either<Failure, T>` using `fpdart` to eliminate unhandled runtime exceptions.
- **Dependency Injection**: Loose coupling and testability via `get_it` service locator.
- **Anti-Jank & Zero Dirty Rebuilds**: Granular UI updates using `BlocSelector` and `BlocListener` with `RepaintBoundary` isolation on complex subtrees.

---

## 🛠️ Tech Stack & Dependencies

| Category | Package / Tool | Purpose |
| :--- | :--- | :--- |
| **State Management** | `flutter_bloc` & `bloc` | Reactive state management using Cubits |
| **Value Equality** | `equatable` | State comparison and rebuild prevention |
| **Routing** | `go_router` | Declarative routing with deep linking & shell routes |
| **Dependency Injection** | `get_it` | Service locator for modular DI |
| **Networking** | `dio` & `pretty_dio_logger` | Robust HTTP client with interceptors and structured logging |
| **Functional Programming** | `fpdart` | Type-safe functional error handling (`Either`) |
| **Storage** | `flutter_secure_storage` & `shared_preferences` | Encrypted authentication tokens & local app settings |
| **Responsiveness** | `flutter_screenutil` | Adaptive pixel-independent UI across phone and tablet sizes |
| **Localization** | `easy_localization` | Multi-language support (English & Arabic) |
| **Web Integration** | `webview_flutter` | In-app secure payment gateway rendering |
| **UI Enhancements** | `google_fonts`, `shimmer`, `lottie`, `animate_do` | Modern typography, skeleton loaders, and micro-interactions |

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── api/             # HTTP clients, interceptors, endpoints, and API contracts
│   ├── cache/           # Secure storage and SharedPreferences wrappers
│   ├── components/      # Shared reusable atomic components
│   ├── config/          # App constants, environment configs, and themes
│   ├── di/              # GetIt dependency injection container setup
│   ├── errors/          # Base exceptions and failure classes
│   ├── localization/    # Localization managers and translations
│   ├── network/         # Network connectivity checkers
│   ├── routes/          # GoRouter configuration and route constants
│   ├── services/        # System services (logging, device info, etc.)
│   ├── theme/           # Color palettes, typography, and theme data
│   ├── usecases/        # Base generic usecase contracts
│   ├── utils/           # Extensions, helper functions, and validators
│   └── widgets/         # Common app-wide UI widgets (buttons, text fields, app bars)
│
├── features/
│   ├── auth/            # Sign in, sign up, and auth state management
│   ├── cart/            # Shopping cart, item adjustments, and calculations
│   ├── home/            # Catalog, banners, categories, and product listings
│   ├── orders/          # Checkout, payment webview, and order tracking
│   ├── product_details/ # Product specifications, galleries, and buy actions
│   └── splash/          # Splash view and startup initialization
│
└── main.dart            # Application entry point
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.10.7` or later
- **Dart SDK**: `^3.10.7` or later
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS simulator

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Adhamessam2/Dukan.git
   cd Dukan
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Running Tests

Dukan includes a test suite with **70+ unit, repository, cubit, and widget tests**:

```bash
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage
```

---

## 📱 Responsive & Landscape Design

The application is tested and optimized across different viewport orientations:
- **Responsive Clamping**: Dynamic sizing via `flutter_screenutil` clamped with min/max constraints to prevent overflow on extreme aspect ratios.
- **Dual-Pane & Grids**: Dual-pane layouts on wide/landscape viewports (e.g., Cart items alongside Order Summary).
- **Anti-Overflow Safety**: All static and form screens are enclosed in scrollable viewports ensuring zero `RenderFlex` exceptions.

---

## 🌐 Localization

The app supports multiple languages (English & Arabic):
- Translation files are organized under `assets/lang/`.
- Managed using `easy_localization` for real-time locale switching.

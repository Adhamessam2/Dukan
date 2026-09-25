# 🛍️ Dukan (دكان) — E-Commerce Mobile Application

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-brightgreen)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC%20%2F%20Cubit-blue)](https://bloclibrary.dev/)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

**Dukan** is an enterprise-grade, high-performance E-Commerce mobile application built with **Flutter**, strictly following **Clean Architecture**, **SOLID principles**, and **Domain-Driven Design (DDD)** concepts. It delivers a seamless, reactive shopping experience with support for multiple languages, responsive landscape layouts, robust token session management, and secure payment processing.

---

## 📑 Table of Contents

- [📚 Project Documentation & Guidelines](#-project-documentation--guidelines)
- [🌟 Features & Capabilities](#-features--capabilities)
- [📐 Architecture & Engineering Standards](#-architecture--engineering-standards)
  - [Clean Architecture Layering](#clean-architecture-layering)
  - [Data Flow Lifecycle](#data-flow-lifecycle)
  - [SOLID Principles Compliance](#solid-principles-compliance)
  - [Rendering & Rebuild Performance Protocol](#rendering--rebuild-performance-protocol)
- [🛠️ Tech Stack & Dependencies](#-tech-stack--dependencies)
- [📂 Project Structure](#-project-structure)
- [⚙️ Core Infrastructure & Services](#-core-infrastructure--services)
  - [Network & Authentication Layer](#network--authentication-layer)
  - [Storage & Caching](#storage--caching)
  - [Dependency Injection Setup](#dependency-injection-setup)
  - [Error Handling & Failure System](#error-handling--failure-system)
- [📱 Responsive & Landscape Design](#-responsive--landscape-design)
- [🌐 Localization](#-localization)
- [🚀 Getting Started](#-getting-started)
- [🧪 Testing & Quality Assurance](#-testing--quality-assurance)
- [🤖 AI Agents & Automated Auditing](#-ai-agents--automated-auditing)
- [📖 Step-by-Step: Adding a New Feature](#-step-by-step-adding-a-new-feature)

---

## 📚 Project Documentation & Guidelines

Comprehensive engineering guides, architectural protocols, and audit rules are maintained within the repository:

| Document | Description | Path |
| :--- | :--- | :--- |
| **Agent Instructions** | Workspace agent overview and subagent execution rules | [AGENTS.md](file:///d:/projects/Dukan/AGENTS.md) |
| **Code Reviewer Guidelines** | Automated code review, performance, and UI audit protocols | [.agents/reviewer.md](file:///d:/projects/Dukan/.agents/reviewer.md) |
| **SOLID & Design Patterns** | SOLID principles inspection rules and design standards | [.agents/solid_rules.md](file:///d:/projects/Dukan/.agents/solid_rules.md) |

---

## 🌟 Features & Capabilities

### 🔐 1. Authentication & Security
- **Dual Authentication**: Tabbed Sign In and Sign Up with live inline validation and password visibility toggles.
- **Automated Token Management**: Interceptor-driven JWT refresh token rotation with transparent retry logic.
- **Secure Key Storage**: Credentials and session tokens persisted via `FlutterSecureStorage` (iOS Keychain / Android KeyStore).
- **Session Expiration Guard**: Automatic session cleanup, cookie clearing, and navigation redirect on authorization invalidation.

### 🛍️ 2. Home & Discovery
- **Promotional Carousels**: Dynamic promotional banners and sales announcements.
- **Category Browsing**: Horizontal category selector with real-time catalog filtering.
- **Dynamic Product Grid**: Responsive multi-column product cards with shimmer skeleton loading, cached network images, and pull-to-refresh.

### 🔍 3. Product Details
- **Product Showcase**: Detailed galleries, badge tags, description, and pricing.
- **Dynamic Pricing & Quantity**: Real-time quantity selection and total price computation.
- **Instant Cart Actions**: Add to cart with real-time UI status updates and feedback.

### 🛒 4. Cart & Order Management
- **Reactive Shopping Cart**: Increment, decrement, swipe-to-delete, and clear cart actions.
- **Live Price Breakdown**: Real-time subtotal, delivery fee, taxes, and final total calculations.
- **Multi-Step Checkout**: Delivery address specification and payment method selection (Cash on Delivery / Online Payment).
- **In-App Payment Gateway**: Embedded `WebView` for payment processing with automatic URL intercept and callback handling.
- **Order Tracking & History**: Order timeline, status badges, granular item receipts, and order cancellation.

---

## 📐 Architecture & Engineering Standards

### Clean Architecture Layering

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
└────────────────────────────────────────────────────────┘
```

1. **Domain Layer (`lib/features/<feature>/domain/`)**:
   - Contains pure business entities, repository interfaces, and use cases.
   - Completely agnostic of UI frameworks, external libraries, or data sources.
2. **Data Layer (`lib/features/<feature>/data/`)**:
   - Implements domain repository interfaces.
   - Contains DTOs/Data Models with `fromJson`/`toJson` serializations.
   - Manages remote data sources (via `ApiConsumer`) and local cache sources.
3. **Presentation Layer (`lib/features/<feature>/presentation/`)**:
   - Manages reactive state using **BLoC / Cubit**.
   - Contains pure presentation views, responsive widgets, and state models extending `Equatable`.

---

### Data Flow Lifecycle

```
[User Action] ──► [UI View] ──► [Cubit / State Machine]
                                        │
                                        ▼
                                [Execute UseCase]
                                        │
                                        ▼
                              [Repository Interface]
                                        │
                                        ▼
                           [Repository Implementation]
                          ┌─────────────┴─────────────┐
                          ▼                           ▼
                 [Remote DataSource]          [Local Cache]
                          │                           │
                          ▼                           ▼
                    (HTTP / Dio)             (SecureStorage / SP)
```

---

### SOLID Principles Compliance

- **Single Responsibility Principle (SRP)**:
  - UI screens only handle rendering and user gestures; business logic resides strictly in Cubits and UseCases.
  - Data sources only handle I/O transport; entity mapping happens in Repository implementations.
- **Open/Closed Principle (OCP)**:
  - Polymorphic use cases and extensible configurations without modifying existing core logic.
- **Liskov Substitution Principle (LSP)**:
  - Repository and API contracts return strongly typed `Either<Failure, T>`, ensuring interchangeable implementations (e.g., test mocks or alternative remote clients).
- **Interface Segregation Principle (ISP)**:
  - Fine-grained, focused interface definitions avoiding fat or monolithic contracts.
- **Dependency Inversion Principle (DIP)**:
  - High-level use cases and presentation layers depend strictly on abstract repository interfaces, wired together via `GetIt` dependency injection.

---

### Rendering & Rebuild Performance Protocol

- **Granular Rebuild Scope**: Screens NEVER wrap entire scaffolds in `BlocBuilder` or `BlocConsumer`. Side effects use `BlocListener`, and UI state rebuilds are scoped to leaf nodes via `BlocSelector` or scoped `BlocBuilder`.
- **Zero Keystroke Dirty Rebuilds**: Form input fields delegate text updates to `RenderEditable` and internal `FormFieldState` without binding `setState` to text controllers.
- **GPU Compositor Safety**: Ambient shadows and glows use vector `BoxShadow` and gradients rather than `BackdropFilter` or `ImageFilter.blur`, preventing offscreen GPU `saveLayer` passes during scrolling.
- **Repaint Isolation**: Static, complex visual elements (such as mascot headers or brand hero art) are wrapped in `const RepaintBoundary`.

---

## 🛠️ Tech Stack & Dependencies

| Category | Package / Tool | Purpose |
| :--- | :--- | :--- |
| **State Management** | `flutter_bloc` & `bloc` | Reactive state management using Cubits |
| **Value Equality** | `equatable` | State comparison and rebuild prevention |
| **Routing** | `go_router` | Declarative routing with deep linking & redirect guards |
| **Dependency Injection** | `get_it` | Service locator for decoupled dependency lifecycle |
| **Networking** | `dio` & `pretty_dio_logger` | Robust HTTP client with interceptors and structured logging |
| **Functional Programming** | `fpdart` | Type-safe functional error handling (`Either<Failure, T>`) |
| **Cookie Management** | `cookie_jar` & `dio_cookie_manager` | Persistent session cookie management |
| **Storage** | `flutter_secure_storage` & `shared_preferences` | Encrypted authentication tokens & local app settings |
| **Responsiveness** | `flutter_screenutil` | Adaptive pixel-independent UI across phone and tablet sizes |
| **Localization** | `easy_localization` | Multi-language support (English & Arabic) |
| **Web Integration** | `webview_flutter` | In-app secure payment gateway rendering |
| **Network Checker** | `internet_connection_checker_plus` | Real-time connectivity and offline state detection |
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
│   ├── errors/          # Base exceptions and failure classes (Either<Failure, T>)
│   ├── localization/    # Localization managers, language switchers, translations
│   ├── network/         # Internet connection and network status checkers
│   ├── routes/          # GoRouter configuration, route paths, and route guards
│   ├── services/        # System services (logging, device info, platform utilities)
│   ├── theme/           # Color palettes, typography, and theme definitions
│   ├── usecases/        # Base generic usecase contracts
│   ├── utils/           # Extensions, helper functions, constants, and validators
│   └── widgets/         # Common app-wide UI widgets (buttons, text fields, app bars)
│
├── features/
│   ├── auth/            # Sign in, sign up, token storage, and auth cubits
│   ├── cart/            # Shopping cart, item adjustments, and price calculations
│   ├── home/            # Catalog, banners, categories, and dynamic product grids
│   ├── orders/          # Checkout, payment webview, and order tracking
│   ├── product_details/ # Product specifications, galleries, and buy actions
│   └── splash/          # Splash view and startup initialization
│
└── main.dart            # Application entry point & configuration bootstrap
```

---

## ⚙️ Core Infrastructure & Services

### Network & Authentication Layer
- **Centralized `ApiConsumer` Interface**: All HTTP requests route through the `ApiConsumer` abstraction implemented by `DioConsumer`.
- **`AuthInterceptor`**:
  - Automatically attaches Bearer tokens from `SecureStorageService` to outgoing headers.
  - Transparently catches `401 Unauthorized` responses and triggers the refresh token flow using a dedicated isolated `Dio` instance.
  - Upon successful token refresh, saves the new access token and retries the original request.
  - If refresh fails, invokes `onSessionExpired` to clear secure storage and redirect the user to the login screen.
- **`PrettyDioLogger`**: Clean, formatted console logs for requests, headers, and responses in debug builds.

### Storage & Caching
- **`SecureStorageService`**: Encapsulates `FlutterSecureStorage` with keychain accessibility flags for secure persistence of access/refresh tokens.
- **`CacheService`**: Encapsulates `SharedPreferences` for user preferences, locale selection, and onboarding flags.

### Dependency Injection Setup
Located in `lib/core/di/injection_container.dart`:
- **Singletons / LazySingletons**: Core services (`Dio`, `ApiConsumer`, `NetworkInfo`, `CacheService`, `SecureStorageService`), Repositories, and UseCases.
- **Factories**: All Cubits are registered as factories (`sl.registerFactory(() => FeatureCubit(...))`) to guarantee fresh instances per view lifecycle.

### Error Handling & Failure System
Located in `lib/core/errors/`:
- **Exceptions**: `ServerException`, `UnauthorizedException`, `NotFoundException`, `NetworkException`, `CacheException`.
- **Failures**: Typed failure models (`ServerFailure`, `UnauthorizedFailure`, `NotFoundFailure`, `NetworkFailure`, `CacheFailure`).
- All repository methods return `Future<Either<Failure, T>>`, eliminating uncaught runtime exceptions and forcing explicit handling in Cubits.

---

## 📱 Responsive & Landscape Design

Dukan enforces complete responsiveness and landscape adaptability:
- **`ScreenUtil` Initialization**: Configured in `MyApp` with dynamic design sizes for both portrait (`375x812`) and landscape (`812x375`):
  ```dart
  designSize: orientation == Orientation.landscape
      ? AppConstants.designSizeLandscape
      : AppConstants.designSizePortrait,
  ```
- **Component Height Clamping**: Responsive heights for headers, search bars, and floating bars use `.h.clamp(min, max)` to prevent viewport exhaustion on short devices.
- **Dual-Pane Layouts**: On wide or landscape screens, complex screens (like Cart) render multi-column dual panes (e.g. items list on the left, order summary & checkout CTA on the right).
- **Anti-Overflow Safety**: All static centered screens (empty states, errors, auth views) are wrapped in scrollable viewports (`SingleChildScrollView`) with bounded constraints.

---

## 🌐 Localization

- Multi-language support for **English (`en`)** and **Arabic (`ar`)** with right-to-left (RTL) layout switching.
- Translation files are stored in `assets/lang/en.json` and `assets/lang/ar.json`.
- Managed using `easy_localization` and `LocalizationManager` for locale updates.

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.10.7`
- **Dart SDK**: `>=3.10.7`
- Android Studio / VS Code with Dart & Flutter plugins
- Physical device or emulator (Android / iOS)

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Adhamessam2/Dukan.git
   cd Dukan
   ```

2. **Install project dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation / asset check**:
   ```bash
   flutter analyze
   ```

4. **Launch the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Quality Assurance

Dukan includes a test suite covering unit tests, use cases, repositories, Cubits, and responsive widget rendering:

```bash
# Run all unit and widget tests
flutter test

# Run tests with code coverage output
flutter test --coverage

# Run static analysis and linting checks
flutter analyze
dart format --output=none --set-exit-if-changed .
```

### Landscape Orientation Testing Pattern
```dart
testWidgets('should render properly in landscape orientation without overflow', (tester) async {
  tester.view.physicalSize = const Size(1624, 750);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
});
```

---

## 🤖 AI Agents & Automated Auditing

The repository includes pre-configured AI auditor definitions and prompts for Clean Architecture, SOLID principles, and anti-jank performance reviews:

To invoke the subagent for SOLID and architectural review:
```json
{
  "TypeName": "code_reviewer",
  "Role": "SOLID & Design Pattern Auditor",
  "Prompt": "Perform a SOLID principles and Design Pattern review on lib/features/<feature_name>"
}
```

Refer to [.agents/reviewer.md](file:///d:/projects/Dukan/.agents/reviewer.md) and [.agents/solid_rules.md](file:///d:/projects/Dukan/.agents/solid_rules.md) for full inspection protocols.

---

## 📖 Step-by-Step: Adding a New Feature

When adding a new feature to Dukan, follow the standard Clean Architecture pattern:

1. **Domain Layer**:
   - Define entity in `lib/features/<feature>/domain/entities/<entity>.dart`.
   - Define abstract repository contract in `lib/features/<feature>/domain/repositories/<feature>_repository.dart`.
   - Create use cases in `lib/features/<feature>/domain/usecases/`.
2. **Data Layer**:
   - Create data model in `lib/features/<feature>/data/models/<model>.dart` with JSON serialization.
   - Define remote data source in `lib/features/<feature>/data/datasources/<feature>_remote_data_source.dart`.
   - Implement repository in `lib/features/<feature>/data/repositories/<feature>_repository_impl.dart`.
3. **Presentation Layer**:
   - Create states extending `Equatable` in `lib/features/<feature>/presentation/cubit/<feature>_state.dart`.
   - Create Cubit in `lib/features/<feature>/presentation/cubit/<feature>_cubit.dart`.
   - Build UI views and responsive widgets in `lib/features/<feature>/presentation/views/` and `widgets/`.
4. **Dependency Injection & Routing**:
   - Register DataSources, Repositories, UseCases, and Cubit Factory in `lib/core/di/injection_container.dart`.
   - Add routes and screen builders in `lib/core/routes/app_router.dart` and `routes.dart`.
5. **Testing**:
   - Write unit tests for use cases, repository implementations, and Cubits in `test/features/<feature>/`.

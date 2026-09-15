# SOLID Principles & Design Patterns Review Protocol (`code_reviewer`)

This document specifies the exact protocol used by the **`code_reviewer`** subagent when auditing Dart/Flutter code for SOLID principles and Design Pattern violations in `Dukan`.

---

## 📐 SOLID Principles Inspection Rules

### 1. Single Responsibility Principle (SRP)
- **Check**: No class should have more than one reason to change.
- **Rule**:
  - UI Screen widgets (`features/<feature>/views/`) must ONLY manage layout and rendering. No inline network requests, direct shared preference access, or complex data transformations.
  - Data sources must ONLY interact with external APIs or databases (Dio/Cache). No domain logic.
  - Caching services (`CacheService`, `SecureStorage`) must separate low-level storage primitives from business domain session logic.

### 2. Open/Closed Principle (OCP)
- **Check**: Code entities should be open for extension, but closed for modification.
- **Rule**:
  - Avoid rigid type checks (`switch(value.runtimeType)` or `if (value is X) ... else if (value is Y)`). Use polymorphism, abstract strategies, or generic type handlers.
  - Configuration classes (`AppConfig`, environment providers) must allow adding new environments without mutating core methods.

### 3. Liskov Substitution Principle (LSP)
- **Check**: Subtypes must be substitutable for their base types without altering correctness.
- **Rule**:
  - `ApiConsumer` and repository contracts must return strongly typed objects (or `Either<Failure, T>`), never raw `Future<dynamic>`.
  - Avoid shadowing Dart core types (e.g. use `UseCase<T, Params>` instead of `UseCase<Type, Params>`).
  - Base exception/failure classes must contain all common fields so downcasting (`as ValidationFailure`) is not required at call sites.

### 4. Interface Segregation Principle (ISP)
- **Check**: Clients should not be forced to depend on methods they do not use.
- **Rule**:
  - Break monolithic interface contracts into focused interface segments where applicable (e.g. `CacheReader` vs `CacheWriter`, or feature-specific API interfaces).
  - Storage interfaces should separate generic key-value access from user session/auth actions.

### 5. Dependency Inversion Principle (DIP)
- **Check**: High-level modules must depend on abstractions (interfaces), not concrete details.
- **Rule**:
  - Depend on abstract classes (`ApiConsumer`, `NetworkInfo`, `CacheService`, `AuthRepository`) rather than concrete implementations (`DioConsumer`, `InternetConnectionChecker`, `SharedPreferences`).
  - Do NOT call global Service Locator (`getIt<MyCubit>()` / `GetIt.I`) inside widget build methods or route builders; pass dependencies via constructors or BLoC providers.

---

## 🎨 Design Patterns & Architectural Rules

1. **Clean Architecture Layering**:
   - `domain/` must contain: Entities, Repository Interfaces, UseCases. MUST NOT import `data/` or `presentation/`.
   - `data/` must contain: Models (`fromJson`/`toJson`), DataSources, Repository Implementations.
   - `presentation/` must contain: Cubits/Blocs, Views, Widgets.

2. **State Management (Cubit/Bloc)**:
   - States must extend `Equatable` and be immutable.
   - Register Cubits as `Factory` in `GetIt` (`sl.registerFactory(() => FeatureCubit(...))`).
   - **Granular Rebuild Scope**: NEVER wrap the entire screen or large layout subtrees in `BlocConsumer` or `BlocBuilder`. Separate side effects into top-level `BlocListener` and isolate state rebuilds strictly to target widgets (e.g., action buttons, input fields) using `BlocSelector` or scoped `BlocBuilder`.

3. **Singleton Safety**:
   - Avoid `static late` singleton instances (`static late SharedPreferences sharedPreferences`). Register as `LazySingleton` or `Singleton` in `get_it`.

4. **Static Analysis & Deprecations**:
   - Ensure clean `flutter analyze` run.
   - Replace Flutter deprecations (`ColorScheme.background`, `.withOpacity()`).

5. **Anti-Over-Engineering, DRY & YAGNI**:
   - **No Duplicate Entities**: Core domain models (e.g. `ProductEntity`) must never be duplicated across features. Use shared domain entities and avoid writing artificial entity mappers (`Product.toCatalogProduct()`).
   - **Unified HTTP Client**: All network operations must route through the central `ApiConsumer` / `Dio` instance. Never add or use secondary HTTP libraries (`package:http`) for isolated services.
   - **No Micro-Widget Over-Abstraction**: Do not create single-use 1-line wrapper widgets that only wrap core widgets (like `CustomButton`) with hardcoded text/icons. Use core widgets directly with appropriate arguments.
   - **No Redundant Interceptors**: Keep network logging unified in `PrettyDioLogger` and do not stack redundant manual `debugPrint` interceptors.
   - **Lean Interfaces (YAGNI)**: Keep interface contracts strictly scoped to actual project usage. Do not introduce phantom boilerplate methods with zero callers.

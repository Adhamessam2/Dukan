# Agent Instructions for Dukan Project

## Active Subagents

### 1. Code Reviewer & SOLID Auditor Subagent (`code_reviewer`)
- **Role**: Automated Code Reviewer & SOLID/Design Pattern Auditor
- **Target Project**: `Dukan` (Flutter Clean Architecture)
- **Configuration & Rules**:
  - General Review Rules: [.agents/reviewer.md](file:///D:/projects/pharmacy/Dukan/.agents/reviewer.md)
  - SOLID & Design Patterns Protocol: [.agents/solid_rules.md](file:///D:/projects/pharmacy/Dukan/.agents/solid_rules.md)

---

## 🚀 How to Invoke the Subagent for SOLID & Design Pattern Reviews

To perform an automated audit or code review on any file, feature, or pull request in this project, invoke the `code_reviewer` subagent:

```json
{
  "TypeName": "code_reviewer",
  "Role": "SOLID & Design Pattern Auditor",
  "Prompt": "Perform a SOLID principles and Design Pattern review on lib/features/... and lib/core/..."
}
```

---

## 📐 Summary of Audit Protocol

### 1. SOLID Principles Checklist
- **SRP**: Single responsibility per class/file. No business/data logic in UI.
- **OCP**: Extensible via interfaces/polymorphism instead of rigid switch/type checks.
- **LSP**: Strongly typed return values (`Either<Failure, T>`), base exception completeness.
- **ISP**: Small, focused interfaces instead of fat APIs.
- **DIP**: High-level modules depend on abstract interfaces (`CacheService`, `ApiConsumer`).

### 2. Clean Architecture & Patterns
- Strict `domain/` isolation (no imports from `data/` or `presentation/`).
- Cubit states extend `Equatable` and are registered as `Factory` in `GetIt`.
- No global `static late` singletons; use `GetIt` for DI lifecycle management.
- **Granular Rebuild Scope**: NEVER wrap entire screens/scaffolds in `BlocConsumer` or `BlocBuilder`. Separate side effects into `BlocListener` and isolate state rebuilds strictly to target widgets with `BlocSelector` or scoped `BlocBuilder`.

### 3. Theme & Design System Conformance
- **Strict Theme Adherence**: Presentation widgets MUST depend on `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`. NEVER use `AppColors` directly for colors that change with theme modes (use `AppColors` strictly for invariant tokens that never change across themes).
- **Zero Magic Numbers (`AppConstants`)**: NEVER use raw numbers or ad-hoc durations. All spacings, paddings, margins, border radii, component heights, control/icon sizes, hairline stroke widths, animation durations, regex patterns, and validation thresholds MUST be sourced from `AppConstants.*`.

### 4. Rendering & Rebuild Performance (Zero Dirty Rebuilds & Anti-Jank)
- **Granular Rebuild Scope**: NEVER wrap entire screens, scaffolds, or layout trees in `BlocConsumer` or `BlocBuilder`. Separate side effects into `BlocListener` / `MultiBlocListener`. Isolate state rebuilds strictly to target leaf widgets (e.g. CTA buttons) with `BlocSelector` or scoped `BlocBuilder`.
- **Zero Keystroke Dirty Rebuilds**: NEVER add `controller.addListener(() => setState(...))` for typing; allow Flutter's `RenderEditable` and internal `FormFieldState` to handle text rendering and inline validation.
- **GPU Compositor Safety (No `BackdropFilter` Raster Thrashing)**: NEVER use `BackdropFilter` or `ImageFilter.blur` for ambient glows or shadows when vector `BoxShadow` or gradients can achieve the effect without forcing GPU `saveLayer` and frame-buffer copies during scrolling.
- **No Redundant Layout Animations**: Do not wrap self-sizing animated widgets (like `AnimatedCrossFade`) in redundant outer layout animators (like `AnimatedSize`).
- **Repaint Isolation**: Wrap complex, static UI subtrees (like mascot/logo headers) in `const RepaintBoundary` to prevent repainting during scroll, cursor blinking, or keyboard animations.

### 5. Anti-Over-Engineering & Code Simplicity (YAGNI & DRY)
- **Domain Model Cohesion**: Never duplicate core domain entities across features (e.g. having duplicate `ProductEntity` across `home` and `catalog`). Share unified domain models across features instead of writing artificial mapper extensions (`toCatalogProductEntity()`).
- **Unified HTTP Stack**: All remote requests must route through `ApiConsumer` / `Dio`. Never introduce secondary HTTP libraries (e.g. `package:http`) or instantiate raw ad-hoc clients.
- **Single Network Logger**: Keep network logging centralized through `PrettyDioLogger`. Never stack duplicate manual logging interceptors.
- **Avoid Micro-Widget Sprawl**: Do not create single-use wrapper widgets that merely wrap a core design system widget (like `CustomButton` or `CustomTextField`) with hardcoded text or icons. Use core widgets directly.
- **YAGNI in Service Interfaces**: Keep interfaces lean and focused on actual use cases. Avoid phantom interface methods with no callers in the application.

### 6. Mandatory Landscape & Responsive Layout Safety
- **Orientation & Wide Screen Adaptation**: Every screen, view, dialog, and action tray MUST gracefully support landscape orientation (`Orientation.landscape`).
- **Zero RenderFlex Overflow on Static Views**: All non-scrollable centered views (e.g. empty states, error screens, auth/onboarding cards) MUST be wrapped in a `SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics())` or provide clamped vertical spacing to guarantee zero `RenderFlex` overflows on shorter viewport heights.
- **Component Height Clamping**: Component heights that scale with screen height (headers, search bars, category chips, bottom navigation bars, floating checkout bars) MUST be clamped using `.h.clamp(min, max)` to prevent vertical screen real estate exhaustion.
- **Dual-Pane / Responsive Grid for Wide Viewports**: On wide/landscape viewports, screens with multiple distinct sections (such as cart items + order summary/checkout, or catalog listings) should leverage responsive multi-column layouts (e.g. dual-pane rows or grids) rather than stretching narrow content across the entire screen width.
- **Automated Landscape Tests**: Feature presentation test suites MUST include landscape orientation verification (`tester.view.physicalSize = Size(1624, 750)` with `AppConstants.designSizeLandscape`) ensuring zero overflow exceptions and proper rendering.



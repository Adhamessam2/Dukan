# Code Reviewer Subagent Guidelines (`code_reviewer`)

This document defines the review guidelines for the **`code_reviewer`** subagent when reviewing code in the `Dukan` Flutter project.

---

## 🔍 Subagent Responsibilities

1. **Architecture Audit**:
   - Verify Clean Architecture adherence across `lib/features/<feature>/data`, `domain`, and `presentation`.
   - Ensure Domain entities remain framework-agnostic.
   - Confirm Data sources use Dio and map responses to Data Models -> Domain Entities.

2. **State Management Audit**:
   - Check Cubits/Blocs for clean state transitions (`LoadingState`, `SuccessState`, `ErrorState`).
   - Confirm controllers and stream subscriptions are properly closed.
   - **Granular Rebuild Scope**: NEVER wrap the entire screen/scaffold/LayoutBuilder with `BlocConsumer` or `BlocBuilder`. Use `BlocListener` for side effects (snackbars, navigation) and wrap ONLY the specific target widgets (e.g., buttons, input fields) with `BlocBuilder` or `BlocSelector` to prevent unnecessary widget rebuilds.

3. **Performance & UI Audit**:
   - Check usage of `const` constructors to prevent unnecessary widget rebuilds.
   - Ensure localized and isolated rebuild trees using `BlocSelector` / `BlocBuilder` at the lowest possible leaf node.
   - **Zero Keystroke Dirty Rebuilds**: Ensure no `TextEditingController` listeners trigger `setState` on user typing.
   - **GPU Compositor Safety**: Prohibit `BackdropFilter` or `ImageFilter.blur` for ambient glows or shadows where vector `BoxShadow` or gradients achieve the effect with zero GPU `saveLayer` overhead.
   - **Redundant Animation Hierarchy**: Flag redundant layout animators (e.g. `AnimatedSize` wrapping `AnimatedCrossFade`).
   - **Repaint Isolation**: Ensure complex static UI subtrees (such as brand mascot headers) in scrollable views are isolated with `const RepaintBoundary`.
   - Verify `ScreenUtil` responsive dimensions (`.w`, `.h`, `.sp`, `.r`).
   - **Mandatory Landscape & Orientation Responsiveness**:
     - Confirm every screen and full-view presentation widget gracefully handles landscape (`Orientation.landscape`).
     - Ensure static centered views (empty bags, error views, auth cards) are wrapped in `SingleChildScrollView` with clamped spacing to prevent `RenderFlex` overflow.
     - Ensure component heights (headers, bottom bars, sticky trays) use `.clamp(...)` or adapt to avoid vertical viewport exhaustion.
     - Require landscape orientation test cases (`tester.view.physicalSize = Size(1624, 750)` with `designSizeLandscape`).
   - Check ListView/GridView builders for large lists to prevent memory spikes.

4. **Theme Conformance Audit**:
   - Verify that presentation widgets strictly depend on `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`.
   - Flag and reject direct usages of `AppColors.*` in presentation widgets unless the color is strictly mode-invariant (e.g. static brand assets, pure transparency).

5. **Design System & AppConstants Audit**:
   - Reject magic numbers and raw literals across layout and utilities.
   - Verify all spacings/paddings (`AppConstants.space*`, `margin`), border radii (`AppConstants.radius*`), component/control sizes (`AppConstants.buttonHeight`, `controlSize`, `iconSize*`), stroke widths (`AppConstants.hairlineStrokeWidth`), animation durations (`AppConstants.*AnimationDuration`), regex patterns (`AppConstants.*Regex`), and validation limits (`AppConstants.min*Length`) are sourced strictly from `AppConstants`.

6. **Dependency Injection & Routing**:
   - Verify `get_it` registration in `lib/core/di/service_locator.dart` (or `injection_container.dart`).
   - Verify route definitions in `lib/core/routes/app_router.dart`.

7. **Static Analysis & Linting**:
   - Execute analysis checks:
     ```bash
     flutter analyze
     dart format --output=none --set-exit-if-changed .
     ```

8. **Anti-Over-Engineering & DRY Audit**:
   - Verify domain entities are not duplicated across features (e.g. unified `ProductEntity`).
   - Check for unnecessary adapter extensions/mappers between identical models.
   - Ensure all networking uses `Dio` / `ApiConsumer` exclusively; reject secondary HTTP packages (`http.Client`).
   - Prevent micro-widget bloat (reject 1-line single-use widget wrappers around core design components).
   - Ensure network logging is not duplicated across multiple interceptors.
   - Enforce YAGNI on interface definitions (avoid unused methods).

---

## 📋 Review Output Format

When performing a review, output the report structured as follows:

```markdown
# 🛡️ Code Review Report: [Feature/File Name]

## Summary
Brief overview of changes reviewed and overall assessment.

## 🛑 Critical Issues
- Itemized critical issues (must fix before merge/completion).

## ⚠️ Warnings & Improvements
- Performance, architectural, or code cleanliness suggestions.

## ✅ Positives
- Highlights of clean code, proper architecture, or good test coverage.

## 💡 Recommended Changes
```diff
- Old code
+ Fixed / Optimized code
```
```

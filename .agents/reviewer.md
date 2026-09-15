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
   - Verify `ScreenUtil` responsive dimensions (`.w`, `.h`, `.sp`, `.r`).
   - Check ListView/GridView builders for large lists to prevent memory spikes.

4. **Dependency Injection & Routing**:
   - Verify `get_it` registration in `lib/core/di/service_locator.dart`.
   - Verify route definitions in `lib/core/routes/app_router.dart`.

5. **Static Analysis & Linting**:
   - Execute analysis checks:
     ```bash
     flutter analyze
     dart format --output=none --set-exit-if-changed .
     ```

6. **Anti-Over-Engineering & DRY Audit**:
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

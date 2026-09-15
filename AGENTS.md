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

### 3. Anti-Over-Engineering & Code Simplicity (YAGNI & DRY)
- **Domain Model Cohesion**: Never duplicate core domain entities across features (e.g. having duplicate `ProductEntity` across `home` and `catalog`). Share unified domain models across features instead of writing artificial mapper extensions (`toCatalogProductEntity()`).
- **Unified HTTP Stack**: All remote requests must route through `ApiConsumer` / `Dio`. Never introduce secondary HTTP libraries (e.g. `package:http`) or instantiate raw ad-hoc clients.
- **Single Network Logger**: Keep network logging centralized through `PrettyDioLogger`. Never stack duplicate manual logging interceptors.
- **Avoid Micro-Widget Sprawl**: Do not create single-use wrapper widgets that merely wrap a core design system widget (like `CustomButton` or `CustomTextField`) with hardcoded text or icons. Use core widgets directly.
- **YAGNI in Service Interfaces**: Keep interfaces lean and focused on actual use cases. Avoid phantom interface methods with no callers in the application.


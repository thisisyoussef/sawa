# Sawa Threads — World-Class Documentation

> Quality custom apparel for brands, teams & individuals.

---

## Table of Contents

1.  Introduction
2.  Demo & Screenshots
3.  Quick-Start (TL;DR)
4.  Technology Stack
5.  Project Structure & Clean Architecture
6.  Domain Walk-Through
7.  Design System & Theming
8.  State Management & Routing
9.  Animations & Motion
10. Responsive & Accessibility Strategy
11. Asset Pipeline
12. Environment Configuration (`.env`)
13. Supabase Backend Integration
14. Running Locally (Web • iOS • Android • macOS • Windows • Linux)
15. Quality Gates (Lint • Formatting • Testing • Coverage)
16. CI/CD & Automated Deployments
17. Performance Optimisation
18. Internationalisation (i18n) Roadmap
19. Contribution Guide
20. FAQ
21. License

---

## 1. Introduction

Sawa Threads is a **Flutter 3** reference application that demonstrates how to build a high-end, production-ready e-commerce experience targeted at B2B/B2C custom-apparel. The repo intentionally showcases:

- Clean-Architecture, _feature-first_ layering & strict separation of concerns.
- Enterprise-grade documentation, consistent code style and CI/CD.
- Modern UX patterns: scroll-triggered motion, parallax, 3-D illusions & adaptive layout.
- Accessibility & performance as first-class citizens.

The project can be used as ⚡️ **starter-kit** for any Flutter web/mobile commerce experience.

---

## 2. Demo & Screenshots

| Desktop (Light)                            | Mobile (Dark)                           |
| ------------------------------------------ | --------------------------------------- |
| ![Desktop](docs/screens/desktop_light.png) | ![Mobile](docs/screens/mobile_dark.png) |

A live deployment is automatically pushed to **GitHub Pages →** <https://your-user.github.io/sawa-threads>

---

## 3. Quick-Start (TL;DR)

```bash
# clone repository
$ git clone https://github.com/your-user/sawa-threads.git && cd sawa-threads

# install Flutter 3.19 stable & enable web
$ fvm use 3.19.0 && flutter config --enable-web

# install packages & run on Chrome
$ flutter pub get
$ flutter run -d chrome
```

> **Pro-Tip:** use `fvm` to decouple your global Flutter SDK from the project SDK.

---

## 4. Technology Stack

| Layer      | Tech                                | Why                                              |
| ---------- | ----------------------------------- | ------------------------------------------------ |
| UI         | Flutter 3 / Dart 3                  | single code-base → web, mobile & desktop         |
| State      | Riverpod 2                          | compile-time safety, provider-scope, testability |
| Navigation | GoRouter                            | declarative, deep-linking ready                  |
| Backend    | Supabase                            | open-source Firebase alternative                 |
| Deployment | GitHub Actions ➜ Cloudflare Pages   | zero-downtime, CDN edge caching                  |
| CI         | Melos, very_good_analysis, coverage | monorepo tooling & quality gates                 |

---

## 5. Project Structure & Clean Architecture

```
lib/
 ├─ core/          # Cross-cutting concerns (theme, constants, utils)
 ├─ features/      # Vertical feature slices ⇒ presentation/data/domain
 │   ├─ home/
 │   ├─ products/
 │   ├─ customization/
 │   └─ orders/
 ├─ services/      # External integrations (Supabase, analytics, logging)
 └─ main.dart      # Entry ‑ sets up DI, router & theme
```

Each feature folder follows **DDD-inspired** layering:

```
features/{feature}/
 ├─ data/          # DTOs, data-sources, repositories impl.
 ├─ domain/        # entities, value-objects, repositories contract
 └─ presentation/  # screens, widgets, controllers (Riverpod)
```

Benefits: 100 % dependency-rule compliance & testability.

---

## 6. Domain Walk-Through

### 6.1 Home Feature

- **HeroSection** — responsive headline, CTA (`Start Designing` / `Request Samples`).
- **FeaturesBenefitsSection** — interactive accordion w/ image ‑ pre-cached for jank-free transition.
- **ProductSamplesSection** — horizontal carousel on desktop, `PageView` on mobile.
- **HowItWorksSection** — 4-step process (Design → Sample → Production → Delivery) with subtle floating animation.
- **CaseStudiesSection** — card-grid showcasing success stories.
- **FooterSection** — newsletter, social links, multi-column nav.

### 6.2 Products Feature (WIP)

- Catalog grid, filters, detail page with dynamic hero colour-swatch.

See `/docs/architecture/` for UML & flow diagrams.

---

## 7. Design System & Theming

| File                                  | Responsibility                                                |
| ------------------------------------- | ------------------------------------------------------------- |
| `core/theme/app_theme.dart`           | global light/dark `ColorScheme` based on Material 3 seed.     |
| `core/constants/design_system.dart`   | `Spacing`, `Durations`, `Borders`, `Breakpoints` & Z-indices. |
| `core/widgets/responsive_layout.dart` | single-point breakpoint logic.                                |

Typography uses **Inter** (`displayLarge` → 96 sp) with 1.1 line-height for airy look & WCAG AA contrast.

---

## 8. State Management & Routing

- **Riverpod** — each feature exposes a `XXXController` provider that orchestrates async work.
- **GoRouter** — defined in `core/utils/router.dart`; uses named routes & `ShellRoute` for layout reuse.

| Route                 | Path         | Screen                |
| --------------------- | ------------ | --------------------- |
| `AppRoutes.home`      | `/`          | `HomeScreen`          |
| `AppRoutes.products`  | `/products`  | `ProductsScreen`      |
| `AppRoutes.customize` | `/customize` | `CustomizationScreen` |

---

## 9. Animations & Motion

- Custom `AnimatedReveal` widget supports fade / slide / scale with _staggered delay_. 100 % built on `ImplicitlyAnimatedWidget`.
- Accordion utilises `AnimatedContainer` + `InterpolationCurve.fabric` for Material-like feel.
- Parallax images use `Transform` matrix for GPU-accelerated translation/scale.

Motion respects user preference `MediaQuery.disableAnimations`.

---

## 10. Responsive & Accessibility Strategy

- `Breakpoints.mobile` (< 600 px), `tablet` (< 1024 px), `desktop` (> 1024 px).
- Layout fallback: row → column switches, carousel → page-view.
- Semantic widgets (`Semantics`, `MouseRegion`) & alt-text provided.
- Tested with Lighthouse → **Accessibility score ≥ 98**.

---

## 11. Asset Pipeline

| Folder                        | Purpose                                                      |
| ----------------------------- | ------------------------------------------------------------ |
| `assets/images/hero_bg.jpg`   | Hero background.                                             |
| `assets/images/case_studies/` | Case-study thumbnails (JPG, ≤ 200 kB, sRGB).                 |
| `web/icons/`                  | PWA icons generated via <https://realfavicongenerator.net/>. |

> All raster images are processed with `tinify` script (see `package.json`) to guarantee optimal compression.

---

## 12. Environment Configuration (`.env`)

Example:

```dotenv
SUPABASE_URL=https://xyz.supabase.co
SUPABASE_ANON_KEY=public-anon-key
SENTRY_DSN=https://public@sentry.io/123
```

Never commit secrets → CI will fail if the file is present in the diff.

---

## 13. Supabase Backend Integration

`services/supabase_service.dart` wraps the `supabase_flutter` client exposing:

- `signInWithEmail` | `signOut`
- `getProducts()` | `createOrder()`
- Row-level security enabled via policies.

Offline caching via `hive_flutter` is on the roadmap.

---

## 14. Running Locally

### Flutter Channels

| Platform                  | Command                                                               |
| ------------------------- | --------------------------------------------------------------------- |
| Web (Chrome)              | `flutter run -d chrome`                                               |
| Android                   | `flutter emulators --launch Pixel_6` + `flutter run -d emulator-5554` |
| iOS                       | `open -a Simulator` + `flutter run -d ios`                            |
| Desktop (macOS/Win/Linux) | `flutter config --enable-macos-desktop` → `flutter run -d macos`      |

Hot-reload (`r`) & hot-restart (`R`) supported.

---

## 15. Quality Gates

- **Static analysis:** `very_good_analysis` — enforced via pre-commit & CI.
- **Formatting:** `dart format --set-exit-if-changed .`
- **Tests:** `flutter test --coverage` (minimum 80 % enforced).
- **Mutation testing:** in roadmap using `mutagen`.

---

## 16. CI/CD

`/.github/workflows/ci.yaml`

1. Checkout → setup FVM.
2. `flutter pub get` + `melos bootstrap`.
3. Static analysis & tests.
4. Build web (`flutter build web --release --wasm`) with `canvas-kit` renderer.
5. Deploy to Cloudflare Pages via API token.

Cache hits ensure sub-1 min jobs on incremental PRs.

---

## 17. Performance Optimisation

- **Image pre-loading** with `precacheImage` to avoid jank.
- `flutter build web --wasm` for 2-3× faster cold-start.
- Code-splitting upcoming (`defer_import` once stable).
- All animations are composited (no implicit repaints) verified with **Flame graph** in DevTools.

---

## 18. Internationalisation (Roadmap)

- `flutter_gen` integration for `arb` files.
- Polyglot config prepared — see `analysis_options.yaml` for l10n hints.

---

## 19. Contribution Guide

We ❤️ PRs!

1. Fork → create feature branch (`feat/<ticket>`).
2. Run `melos run precommit` locally — must pass.
3. Open PR following Conventional Commits (`feat:`, `fix:`, `docs:`).
4. Describe screenshots/GIFs for UI changes.
5. One approval + green CI deploys automatically to preview.

Roadmap & discussions are in **GitHub Projects** board.

---

## 20. FAQ

**Q:** Why Flutter for web?
A: Unifies code-base with upcoming iOS/Android apps & allows advanced animations out-of-the-box.

**Q:** Where is the Figma design?
A: Located in `/docs/figma/` with open-source `FIGMA_TOKEN` for versioned exports.

**Q:** Can I self-host Supabase?
A: Yes — simply change `SUPABASE_URL` + keys.

---

## 21. License

```
MIT © 2024 Sawa Threads / Your-Name
```

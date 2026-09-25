# Dukaan MVP — Business Requirements Document (BRD)

**Document version:** 1.0
**Platform:** Flutter (iOS/Android)
**Backend:** Dukaan production-ready e-commerce API (NestJS), Paymob payment gateway
**Region:** Egypt (EGP currency confirmed in payment flow)

---

## 1. Business Objective
Ship a small, functional e-commerce mobile app — browse products, add to cart, check out with cash or card, and track order status — using an existing production-ready backend API. The goal is a working MVP, not a feature-complete storefront: scope was deliberately narrowed to what the backend cleanly supports today, deferring everything else (reviews, saved addresses, promo codes, order cancellation) to a later phase.

## 2. Stakeholders
- Product owner / developer: Adham (Flutter developer, sole builder)
- Backend: existing third-party Dukaan API, not built or maintained by this team

## 3. Business Scope

**In scope for MVP:**
- Account creation and login
- Product browsing and search by category
- Cart management
- Checkout with two payment methods: Cash on Delivery and Credit Card (via Paymob)
- Order history and order detail viewing
- Retry payment for orders left unpaid (Credit Card, payment abandoned/failed)

**Out of scope for MVP (explicitly deferred):**
- Saved address book (multiple addresses, address CRUD) — address is entered fresh at checkout every time
- Product reviews (read or write)
- Promo codes / discount codes
- Password reset / change password flow
- Email verification flow
- Order cancellation
- Image/file uploads (e.g. review photos)
- Order tracking with courier name, live ETA, or shipment tracking numbers
- Admin-side functionality (product/category/order management) — this is a customer-facing app only

## 4. Success Criteria
- A user can complete the full loop: sign up → browse → add to cart → checkout (either payment method) → see the order in their history — without errors, using only endpoints confirmed to work via live testing against the API.
- No screen displays data the API cannot actually provide (this was a recurring issue caught and corrected during design: delivery tracking banners, unused payment methods, and address fields with no backing endpoint were all removed before implementation).

## 5. Out-of-Scope Statement
Everything listed in §3 as deferred is intentionally excluded from this version's acceptance criteria. These are candidates for a v1.1 scope, not defects — the app is considered feature-complete for MVP purposes without them.

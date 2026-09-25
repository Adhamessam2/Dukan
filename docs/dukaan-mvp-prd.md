# Dukaan MVP — Product Requirements Document (PRD)

**Document version:** 1.0
**Platform:** Flutter (iOS/Android)
**Backend:** Dukaan production-ready e-commerce API (NestJS), Paymob payment gateway
**Region:** Egypt (EGP currency confirmed in payment flow)

---

## 1. Screens (confirmed built, per latest screenshots)

| Screen | Status | Notes |
|---|---|---|
| Splash | ✅ Built | "Hello from Dukan," region selector (Egypt), version tag |
| Home / Product list | ✅ Built | Search, category chips (All/men/women/kids), featured banner, product grid |
| Product Detail | ✅ Built | Image, category, name, rating placeholder, SKU, price, stock count, description, quantity stepper, Add to Bag |
| Cart | ✅ Built | Item list, quantity stepper, remove item, Order Summary, Proceed to Checkout — responsive (tablet layout confirmed) |
| Checkout | ✅ Built (design finalized) | Shipping form (Full Name, Phone, Street, Building, City — State/ZIP removed), Order Summary, Payment Method (Cash / Visa) |
| Payment (Card) | ✅ Built | Paymob-hosted card entry inside app, shown in EGP, "Powered by Paymob" |
| Order History | ✅ Built | Filter tabs (All/Pending/Processing/Shipped), search, order cards with status badge, item thumbnail, total, action buttons |
| Order Detail | Designed, pending final data wiring | Status, items, delivery address, payment details (branches by payment method — see §4) |

## 2. Functional Requirements by Module

**Auth**
- Sign up (`POST /api/v1/auth/sign-up`)
- Sign in (`POST /api/v1/auth/sign-in`)
- Token refresh (`GET /api/v1/auth/refresh`)
- Logout (`DELETE /api/v1/auth/logout`)

**Product Browsing**
- List categories (`GET /api/v1/categories`)
- List products, filterable by category (`GET /api/v1/products`)
- Product detail (`GET /api/v1/products/{id}`)

**Cart**
- Get cart (`GET /api/v1/cart`)
- Clear cart (`DELETE /api/v1/cart`) — used after successful order placement
- Add item (`POST /api/v1/cart-item`)
- Get item (`GET /api/v1/cart-item`)
- Update item quantity (`PUT /api/v1/cart-item`)
- Remove item (`DELETE /api/v1/cart-item`)

**Checkout & Orders**
- Create order (`POST /api/v1/order`) — requires `Idempotency-Key` header (fresh UUID per attempt); body takes inline `address` (`shippingCity`, `shippingStreet`, `shippingBuilding`) and `paymentMethod` (`CASH` | `CREDIT_CARD`); no saved-address or promo-code fields used
- List orders (`GET /api/v1/order`) — includes `id` and `items` (product name/price/image/quantity) per order
- Order detail (`GET /api/v1/order/{id}`) — confirmed identical shape to a list item; client may reuse the in-memory object from the list instead of re-fetching when navigating from Order History
- Payment status (`GET /api/v1/order/{id}/payment-status`) — not yet tested; required to confirm Credit Card payment resolution after the Paymob WebView closes

**Payment**
- Card payment handled via Paymob-hosted checkout (`payment.checkoutUrl` returned on order creation), rendered in-app
- Cash payment requires no further API call after order creation — `payment` is `null` in the response

## 3. Confirmed Data Contracts

**OrderStatus enum:** `PENDING`, `PROCESSING`, `SHIPPED`, `DELIVERED`, `CANCELLED`
**paymentMethod enum:** `CASH`, `CREDIT_CARD`
**PaymentProvider enum:** `PAYMOB`, `STRIPE`, `PAYPAL` (only Paymob confirmed active in tested responses)

**Known API quirks to defend against in code:**
- `totalAmount` returns as a string, not a number — parse as double
- Reusing an `Idempotency-Key` returns `data` as a JSON-encoded string instead of a nested object — parse both shapes defensively
- `GET /api/v1/order` list responses were observed missing the `id` field in earlier testing, then present in later testing — treat as resolved but worth a regression check before final release

## 4. Payment Retry Flow (new requirement, confirmed via screenshots)
Order History must support a "Payment Pending" state for Credit Card orders where payment was not completed (abandoned checkout, failed transaction). This state shows a distinct status badge and a "Pay Now" action that re-opens the Paymob checkout for that same order — no duplicate order is created, per the MVP decision to skip order cancellation and keep one order per checkout attempt.

**Requirement:** determine whether "Payment Pending" is a value returned directly by the API (via `orderStatus` or `payment-status`) or a client-side interpretation of `orderStatus: PENDING` + `paymentMethod: CREDIT_CARD` + no successful payment status. This must be confirmed against the `payment-status` endpoint response before finalizing the Order History status-mapping logic.

## 5. Payment Details Section (Order Detail)
Branches on `paymentMethod`:
- **Cash on Delivery:** simple label only — "Payment Method: Cash on Delivery" — no status badge, reference number, or gateway name (no `payment` object exists for cash orders)
- **Credit Card:** gateway name, paid status, reference number — field values pending confirmation from the `payment-status` endpoint (not yet tested against a completed transaction)

## 6. Design System
Two theme variants (light/dark) were created and merged into a single token-based design system ("Warm Architectural Minimalism"), using semantic color tokens (`primary`, `on-surface`, `surface-container-lowest`, etc.) so components render correctly under either palette. Typography, spacing, and elevation rules follow the light theme's specification for both modes. One gap identified: no dedicated "success" color token exists for the `DELIVERED` order status, which conventionally reads as green — needs a decision (add a token, or represent `DELIVERED` via icon/label only within the existing palette).

## 7. Open Items / Risks

| Item | Status | Action needed |
|---|---|---|
| `GET /api/v1/order/{id}/payment-status` response shape | Untested | Test after completing one sandbox Paymob payment |
| Paymob redirect URL pattern (success/failure) | Unknown | Check Paymob docs or observe during sandbox test, to detect when to close the in-app WebView |
| "Payment Pending" status source of truth | Unclear | Confirm whether this is a real API state or a client-derived one |
| `DELIVERED` status color | Undecided | Add a `success` token to the design system, or use icon-only differentiation |
| Order Detail line-items source when navigating cold (e.g. deep link) | Partially resolved | Falls back to `GET /api/v1/order/{id}` correctly; confirmed working |

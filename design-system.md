---
name: Warm Architectural Minimalism
colors:
  light:
    surface: '#f9f9f9'
    surface-dim: '#dadada'
    surface-bright: '#f9f9f9'
    surface-container-lowest: '#ffffff'
    surface-container-low: '#f3f3f3'
    surface-container: '#eeeeee'
    surface-container-high: '#e8e8e8'
    surface-container-highest: '#e2e2e2'
    on-surface: '#1a1c1c'
    on-surface-variant: '#59413a'
    inverse-surface: '#2f3131'
    inverse-on-surface: '#f0f1f1'
    outline: '#8d7168'
    outline-variant: '#e1bfb5'
    surface-tint: '#ab3504'
    primary: '#a83301'
    on-primary: '#ffffff'
    primary-container: '#ca4a1c'
    on-primary-container: '#fffbff'
    inverse-primary: '#ffb59d'
    secondary: '#5f5e61'
    on-secondary: '#ffffff'
    secondary-container: '#e4e1e6'
    on-secondary-container: '#656467'
    tertiary: '#5a5c5d'
    on-tertiary: '#ffffff'
    tertiary-container: '#737576'
    on-tertiary-container: '#fcfcfd'
    error: '#ba1a1a'
    on-error: '#ffffff'
    error-container: '#ffdad6'
    on-error-container: '#93000a'
    primary-fixed: '#ffdbd0'
    primary-fixed-dim: '#ffb59d'
    on-primary-fixed: '#390b00'
    on-primary-fixed-variant: '#842500'
    secondary-fixed: '#e4e1e6'
    secondary-fixed-dim: '#c8c5ca'
    on-secondary-fixed: '#1b1b1e'
    on-secondary-fixed-variant: '#47464a'
    tertiary-fixed: '#e2e2e3'
    tertiary-fixed-dim: '#c6c6c7'
    on-tertiary-fixed: '#1a1c1d'
    on-tertiary-fixed-variant: '#454748'
    background: '#f9f9f9'
    on-background: '#1a1c1c'
    surface-variant: '#e2e2e2'
  dark:
    surface: '#131313'
    surface-dim: '#131313'
    surface-bright: '#393939'
    surface-container-lowest: '#0e0e0e'
    surface-container-low: '#1c1b1b'
    surface-container: '#201f1f'
    surface-container-high: '#2a2a2a'
    surface-container-highest: '#353534'
    on-surface: '#e5e2e1'
    on-surface-variant: '#e0c0b5'
    inverse-surface: '#e5e2e1'
    inverse-on-surface: '#313030'
    outline: '#a78a81'
    outline-variant: '#58423a'
    surface-tint: '#ffb59c'
    primary: '#ffb59c'
    on-primary: '#5c1900'
    primary-container: '#f06a38'
    on-primary-container: '#541600'
    inverse-primary: '#a93804'
    secondary: '#ffb59d'
    on-secondary: '#5d1800'
    secondary-container: '#a83301'
    on-secondary-container: '#ffc8b8'
    tertiary: '#c8c6c6'
    on-tertiary: '#303030'
    tertiary-container: '#949393'
    on-tertiary-container: '#2c2c2c'
    error: '#ffb4ab'
    on-error: '#690005'
    error-container: '#93000a'
    on-error-container: '#ffdad6'
    primary-fixed: '#ffdbcf'
    primary-fixed-dim: '#ffb59c'
    on-primary-fixed: '#390c00'
    on-primary-fixed-variant: '#822700'
    secondary-fixed: '#ffdbd0'
    secondary-fixed-dim: '#ffb59d'
    on-secondary-fixed: '#390b00'
    on-secondary-fixed-variant: '#842500'
    tertiary-fixed: '#e4e2e1'
    tertiary-fixed-dim: '#c8c6c6'
    on-tertiary-fixed: '#1b1c1c'
    on-tertiary-fixed-variant: '#474747'
    background: '#131313'
    on-background: '#e5e2e1'
    surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 2.25rem
    fontWeight: '700'
    lineHeight: 2.75rem
    letterSpacing: -0.03em
  display-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 1.875rem
    fontWeight: '700'
    lineHeight: 2.25rem
    letterSpacing: -0.025em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 1.5rem
    fontWeight: '600'
    lineHeight: 2rem
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 1.25rem
    fontWeight: '600'
    lineHeight: 1.75rem
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 1.125rem
    fontWeight: '600'
    lineHeight: 1.5rem
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 1rem
    fontWeight: '400'
    lineHeight: 1.5rem
    letterSpacing: -0.005em
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.875rem
    fontWeight: '400'
    lineHeight: 1.375rem
    letterSpacing: 0em
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.75rem
    fontWeight: '400'
    lineHeight: 1.125rem
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.875rem
    fontWeight: '600'
    lineHeight: 1.25rem
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.75rem
    fontWeight: '600'
    lineHeight: 1rem
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 0.6875rem
    fontWeight: '600'
    lineHeight: 0.875rem
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Merge note

This file combines the light and dark theme docs into a single design system. Color palettes are kept separate (`light` / `dark`) since that's the whole point of theming, but everywhere else the two source files disagreed — typography, spacing rhythm, elevation style — the **light theme's rules win** and apply to both modes. Component and layout descriptions below reference semantic tokens (e.g. `primary`, `on-surface`, `surface-container`) rather than hardcoded hex, so the same rule set renders correctly whichever palette is active.

## Brand & Style

This design system embodies a modern, tactile minimalism tailored for a discerning mobile-first retail experience. The aesthetic balances clean Japanese and Nordic retail sensibilities with an inviting, earthy warmth. It strips away ornamental clutter to celebrate product photography, crisp structural layouts, and deliberate typographic rhythm.

### Personality & Emotional Resonance
- **Composed & Effortless:** Interfaces prioritize breathing room, deliberate negative space, and unhurried browsing. The user should feel clarity and calm, never cognitive overwhelm or transactional pressure.
- **Tactile & Refined:** Surfaces feel like smooth matte ceramics or soft paper stock, punctuated by a single vibrant terracotta tone that conveys artisanal craftsmanship and premium care.
- **Architectural Clarity:** Layouts rely on strict underlying alignments, razor-thin framing lines, and soft structural roundedness (large radii on outer shells, tighter radii on inner controls).

### Design Style Archetype
A blend of **Minimalism** and **Tactile Modernism**. Surfaces feature warm neutral whites/near-blacks bounded by faint hairline borders. Interactions are physical yet quiet: cards nest within soft inset background containers, micro-interactions use gentle physical spring curves, and high-contrast typography ensures instant legibility under variable lighting conditions.

## Colors

The palette establishes an intentional contrast between an airy, warm monochromatic base and a singular, saturated terracotta accent, expressed as two token sets (`light` / `dark`) under the `colors` key above.

### Palette Application Rules
- **`primary`:** Reserved strictly for primary calls-to-action (Add to Bag, Checkout), active tab indicators, promotional tags, and interactive focus states. Never used for large background fills or non-interactive decorations to preserve its conversion power.
- **`on-surface`:** The bedrock of typographic hierarchy and high-contrast structural elements. Used for primary text headings, key icons, solid badge surfaces, and dark pill buttons.
- **`on-surface-variant` / `outline`:** For secondary metadata, breadcrumbs, inactive states, and supporting labels.
- **`background`:** The foundational viewport background, giving the product catalog a warm editorial foundation rather than a stark clinical blue-white (light) or a cold pure-black (dark).
- **`surface-container-low` / `surface-container`:** Secondary surface used for container wells, card backgrounds, search inputs, and chips.
- **`surface-container-lowest`:** Elevated cards, floating bottom sheets, sticky action bars, and modal dialogs.
- **`outline-variant`:** 1px structural dividing lines with no heavy shadows.

## Typography

The typography leverages **Plus Jakarta Sans** across all levels and both themes, to maintain a cohesive, contemporary geometry. Its subtle humanist curves soften tabular information while maintaining strict clarity at small mobile sizes.

### Typographic Hierarchy Rules
- **Headings & Numerical Display:** Product names and prices use medium-to-bold weights with negative tracking (`-0.02em` to `-0.03em`) to create a cohesive, editorial magazine presence.
- **Tabular Numerals:** All pricing, quantity steppers, and cart tallies must employ tabular figures (`tnum`) to avoid layout jitter during quantity updates.
- **Labels & Badges:** Microcopy, categories, and status tags are styled with `label-sm` or `label-md`, rendered slightly heavier (600 weight) with relaxed tracking (`0.02em` to `0.04em`) to ensure instant legibility against neutral backgrounds.

## Layout & Spacing

The layout is built on the 4px/8px incremental rhythm defined in `spacing` above, engineered specifically for thumb-zone ergonomics and edge-to-edge breathing room.

### Grid Architecture
- **Mobile (Base, <640px):** 4-column fluid layout with `margin: 1rem` (16px) and `gutter: 0.75rem` (12px). Product card grids default to 2 columns with a 12px gap.
- **Tablet / Large Mobile (640px – 1024px):** 6-column to 8-column layout with `margin: 1.5rem` (24px) and `gutter: 1rem` (16px).
- **Desktop (>1024px):** Fixed-width centered viewport container (max-width `1200px`) using a 12-column system, `gutter: 1.5rem` (24px).

### Spacing Principles
- **Airy Enclosure:** Card content requires generous padding (`space-md` on mobile cards, `space-lg` on detailed views) so elements never touch edges or feel crowded.
- **Horizontal Product Carousels:** Bleed into margins using negative margin offsets with matching inner horizontal scroll padding, allowing items to trail off the screen seamlessly.
- **Safe Area Anchors:** Bottom navigation bars and floating checkout trays must incorporate `env(safe-area-inset-bottom)` plus `space-md` to avoid accidental gestures.

## Elevation & Depth

This design system avoids dark or heavy drop shadows, opting instead for structural depth created through **tonal planes** and **subtle ambient diffusion** — applied consistently in both themes, just against each theme's own background tone.

### Elevation Hierarchy
- **Level 0 (Canvas Base):** `background` tone. Inactive areas and full-page viewport backing.
- **Level 1 (Inset / Recessed Wells):** `surface-container-low` tone with no border or shadow. Used for search inputs, segmented controls, and thumbnail placeholders.
- **Level 2 (Elevated Product Card):** `surface-container-lowest` surface framed with a hairline border (`1px solid` `outline-variant`). On active interaction or hover, apply an ambient shadow: `0 8px 24px -4px rgba(24, 24, 27, 0.04)`.
- **Level 3 (Floating Bars & Bottom Trays):** `surface-container-lowest` surface with a delicate top hairline border (`1px solid` `outline-variant`) combined with an upward diffused elevation: `0 -8px 32px 0 rgba(24, 24, 27, 0.05)`.
- **Level 4 (Modals & Action Sheets):** `surface-container-lowest` with backdrop blur (`backdrop-filter: blur(8px)`) over a 30% `inverse-surface` scrim, paired with `0 20px 40px -8px rgba(24, 24, 27, 0.12)`.

## Shapes

The design system employs a tiered corner radius language that pairs large, friendly outer contours with tighter, functional interior elements.

### Radius Application Rules
- **Base Containers & Modal Sheets (`rounded-3xl` / 1.5rem):** Outer application cards, bottom sheets, full-width hero banners, and checkout dialogs.
- **Interactive Product Cards (`rounded-2xl` / 1rem):** Standard grid cards, collection tiles, and image display viewports.
- **Action Buttons & Steppers (`rounded-xl` / 0.75rem or Full Pill):** Primary action buttons, segmented controls, and stepper counters.
- **Badges & Tags (`rounded-full` / 9999px):** Status badges, discount pills, and category indicator dots.
- **Hairline Restraint:** All rounded outlines must maintain consistent stroke width (`1px`) without clipping inner artwork or bleed effects.

## Components

### Buttons
- **Primary CTA:** Background `primary`, text `on-primary`, height `52px`, `rounded-xl` or `rounded-full`. Font weight 600 (`label-lg`). Pressed state dims smoothly (scale to `98%`) with a slightly deepened `primary`.
- **Secondary / Charcoal:** Background `on-surface`, text `background`, height `52px`, `rounded-xl`. Used for high-emphasis neutral actions like "Apply Code" or "View Bag".
- **Ghost / Tertiary:** Background transparent, text `on-surface`, hairline border `1px solid` `outline-variant`.

### Cards
- **Product Card:** Surface `surface-container-lowest`, border `1px solid` `outline-variant`, `rounded-2xl`. Image wrapper has an aspect ratio of `4:5` or `1:1` on a `surface-container-low` ground. Product title in `body-md` (`on-surface`), price in `label-lg` (`on-surface`). Terracotta discount labels sit pinned at top-left with `0.5rem` offset.
- **Editorial Promo Card:** Edge-to-edge photography, `rounded-3xl`, internal content padded with `space-lg`, text layered with subtle contrast gradients.

### Chips & Category Filters
- **Default State:** Background `surface-container-low`, text `on-surface-variant`, border `1px solid transparent`, height `36px`, `rounded-full`, padding `0 1rem`.
- **Selected State:** Background `on-surface`, text `background`, border `1px solid` `on-surface`.

### Quantity Steppers
- Horizontal rounded capsule (`rounded-full` or `rounded-xl`), background `surface-container-low`, height `36px`. Features minus, numerical counter (using `tnum`), and plus arranged with equal spacing. Interactive taps provide tactile micro-vibration cues where available.

### Input Fields
- Height `48px`, background `surface-container-low`, border `1px solid transparent`, `rounded-xl`, padding `0 1rem`.
- **Focused State:** Background `surface-container-lowest`, border `1px solid` `primary`, subtle ring glow `0 0 0 3px` (primary at 12% opacity). Label transitions cleanly into micro-label style (`label-sm`).

### Checkboxes & Radio Controls
- **Radio Buttons:** Outer circle `20px`, border `1.5px solid` `outline-variant`. Selected state features an outer stroke of `primary` with an inner solid circle of `primary` (8px).
- **Checkboxes:** `20px` square with `rounded-md` (6px radius). Checked state transitions to a solid `primary` fill with an optically centered `on-primary` checkmark.

### Bottom Sticky Bar
- Anchored to bottom screen edges, `surface-container-lowest`, top border `1px solid` `outline-variant`, elevation Level 3. Splits into two primary zones: left side displays price breakdown (`body-sm` label + `headline-sm` value), right side displays a full-width Primary CTA button.

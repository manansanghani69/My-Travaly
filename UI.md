# MyTravaly Flutter App - Stitch UI Generation Prompts

## 🎨 Overview
These prompts are designed for Stitch (or similar UI generation tools) to create pixel-perfect, production-ready Flutter UI screens for the MyTravaly hotel booking app.

---

## 🔐 SCREEN 1: Sign-In Page

### Prompt for Stitch:

```
Create a modern, elegant Flutter Sign-In page for a hotel booking app called "MyTravaly".

DESIGN SPECIFICATIONS:

LAYOUT:
- Full screen with gradient background (light blue to white, top to bottom)
- Center-aligned content
- Safe area padding for all devices

COMPONENTS (Top to Bottom):

1. APP LOGO SECTION (Top Third):
   - App logo/icon: 120x120dp circular container
   - Background: White with subtle shadow (elevation 4)
   - Icon: Travel/Hotel themed (plane, hotel, or compass)
   - Position: Centered horizontally, 20% from top

2. BRANDING SECTION:
   - App name "MyTravaly" in bold, size 32sp
   - Font: Poppins Bold or similar modern font
   - Color: #1976D2 (Material Blue 700)
   - Tagline below: "Find Your Perfect Stay"
   - Tagline font size: 16sp, color: #757575 (Grey 600)
   - Spacing between name and tagline: 8dp

3. WELCOME TEXT (Middle Section):
   - Text: "Welcome Back!"
   - Font size: 24sp, weight: 600
   - Color: #212121 (Grey 900)
   - Margin top: 48dp from tagline

4. GOOGLE SIGN-IN BUTTON:
   - Width: 280dp, Height: 56dp
   - Background: White
   - Border: 1dp solid #E0E0E0
   - Border radius: 28dp (fully rounded)
   - Elevation: 2dp
   - Content:
     * Google "G" logo on left (24x24dp)
     * Text: "Continue with Google"
     * Text color: #212121
     * Font size: 16sp, weight: 500
   - Margin top: 32dp from welcome text
   - Center aligned

5. DIVIDER SECTION:
   - Horizontal line with "OR" in center
   - Line color: #E0E0E0
   - "OR" text: size 14sp, color: #9E9E9E
   - Margin: 24dp top and bottom

6. ALTERNATIVE SIGN-IN OPTIONS:
   - Two outlined buttons stacked vertically:
     a) Email sign-in button:
        - Width: 280dp, Height: 48dp
        - Border: 1.5dp solid #1976D2
        - Border radius: 24dp
        - Text: "Sign in with Email"
        - Text color: #1976D2
        - Icon: Email icon on left
     b) Phone sign-in button (below email, 16dp spacing):
        - Same style as email button
        - Text: "Sign in with Phone"
        - Icon: Phone icon on left

7. FOOTER SECTION (Bottom):
   - Terms and Privacy links
   - Text: "By continuing, you agree to our Terms & Privacy Policy"
   - Font size: 12sp, color: #9E9E9E
   - Underlined clickable links for "Terms" and "Privacy Policy"
   - Position: 24dp from bottom
   - Center aligned

INTERACTIONS:
- Google button: Show ripple effect on tap, slight scale animation (0.98)
- Email/Phone buttons: Border color changes to darker blue on tap
- All buttons: Disabled state with 0.5 opacity

STATES:
1. Default state (as described above)
2. Loading state:
   - Google button shows CircularProgressIndicator (18dp) instead of logo
   - Button text changes to "Signing in..."
   - Other buttons become disabled (opacity 0.5)

RESPONSIVE DESIGN:
- On tablets: Max width 400dp for all components, centered
- On small phones: Reduce logo to 100x100dp, font sizes by 2sp
- Maintain aspect ratios and spacing proportions

ANIMATIONS:
- Fade-in animation for all components on page load (300ms, stagger 50ms)
- Logo: Subtle bounce animation on load
- Buttons: Smooth hover/press animations

ACCESSIBILITY:
- All buttons have semantic labels
- Sufficient contrast ratios (WCAG AA compliant)
- Touch targets minimum 48x48dp

COLOR PALETTE:
- Primary: #1976D2 (Blue 700)
- Primary Variant: #1565C0 (Blue 800)
- Background: Linear gradient #E3F2FD to #FFFFFF
- Surface: #FFFFFF
- On Surface: #212121
- On Background: #757575

Generate complete Flutter code with proper widget tree, styling, and responsiveness.
```

---

## 🏠 SCREEN 2: Home Page

### Prompt for Stitch:

```
Create a modern, scrollable Flutter Home page for a hotel booking app with search functionality and hotel listings.

DESIGN SPECIFICATIONS:

APP BAR:
- Height: 56dp + status bar height
- Background: White with subtle shadow (elevation 2)
- Content:
  * Left: App name "MyTravaly" in Poppins Bold, 20sp, color #1976D2
  * Right: User profile CircleAvatar (36dp) with image or initial
  * Padding: 16dp horizontal

SEARCH SECTION (Fixed at top, below app bar):
- Background: White
- Padding: 16dp all sides
- Search Container:
  * Width: Match parent
  * Height: 56dp
  * Background: #F5F5F5 (Grey 100)
  * Border radius: 28dp
  * Content:
    - Left: Search icon (24dp), color #757575, padding 16dp
    - Center: Hint text "Search hotels, cities, destinations..."
    - Font size: 16sp, color #9E9E9E
    - Right: Filter icon (24dp), color #757575, padding 16dp
  * On tap: Navigate to search page
  * Elevation: 0dp (flat design)

GREETING SECTION:
- Padding: 16dp horizontal, 8dp top
- Text: "Find Your Perfect Stay"
- Font size: 24sp, weight: 700
- Color: #212121
- Below: "Explore top destinations" in 14sp, color #757575

CATEGORY CHIPS (Horizontal scroll):
- Padding: 16dp horizontal, 12dp vertical
- Chips list: "All", "Hotels", "Resorts", "Homestays", "Apartments"
- Chip design:
  * Height: 40dp
  * Padding: 16dp horizontal
  * Border radius: 20dp
  * Selected: Background #1976D2, Text white
  * Unselected: Background #E3F2FD, Text #1976D2
  * Spacing between chips: 8dp
- Scrollable horizontally without scroll bar

SECTION HEADER:
- Padding: 20dp horizontal, 16dp top, 12dp bottom
- Text: "Popular Stays"
- Font size: 20sp, weight: 600
- Color: #212121
- Right aligned: "See All" text button, color #1976D2, 14sp

HOTEL CARDS (Vertical scrollable list):
- Padding: 16dp horizontal, 8dp vertical between cards
- Card design:
  * Width: Match parent
  * Border radius: 16dp
  * Background: White
  * Elevation: 2dp
  * Content layout (vertical):
  
  1. HOTEL IMAGE:
     - Height: 200dp
     - Width: Match parent
     - Border radius: 16dp (top only)
     - Placeholder: Grey shimmer if loading
     - Overlay gradient at bottom (transparent to black 0.3 opacity)
     - Top right badge: "Featured" or "⭐ 4.5" in white chip
  
  2. CONTENT SECTION (Padding 16dp):
     a) Hotel Name:
        - Font size: 18sp, weight: 600
        - Color: #212121
        - Max lines: 2, ellipsis
     
     b) Star Rating Row (8dp below name):
        - Star icons (5 stars, 16dp each)
        - Filled stars: #FFC107 (Amber)
        - Empty stars: #E0E0E0
        - Spacing: 2dp
     
     c) Location Row (8dp below stars):
        - Location pin icon (16dp), color #757575
        - Text: "City, State" format
        - Font size: 14sp, color #757575
        - Max lines: 1, ellipsis
     
     d) Price Section (16dp below location):
        - Left aligned:
          * Strikethrough price: "₹2,500" in 14sp, color #9E9E9E
          * Current price: "₹1,999" in 20sp, weight 700, color #1976D2
          * "/night" text in 12sp, color #757575
        - Right aligned:
          * "View Details" text button
          * Color: #1976D2, size 14sp, weight 500
     
     e) Amenities Row (12dp below price):
        - Icons with labels (max 4):
          * Free WiFi icon (18dp)
          * Parking icon (18dp)
          * Pool icon (18dp)
          * Restaurant icon (18dp)
        - Icon color: #1976D2
        - Spacing: 16dp between icons
        - Show "+3 more" if more amenities available

LOADING STATE (Shimmer):
- Show 3 shimmer hotel cards with:
  * Animated shimmer effect (grey to light grey)
  * Same card structure but all content as grey boxes
  * Animation duration: 1500ms, repeat

EMPTY STATE:
- Centered vertically
- Illustration: Hotel/search icon (120dp) in light grey
- Text: "No hotels found"
- Subtext: "Try adjusting your search"
- Font sizes: 18sp and 14sp
- Colors: #212121 and #757575

PULL TO REFRESH:
- Material refresh indicator
- Color: #1976D2
- Position: Top of hotel list

FLOATING ACTION BUTTON (Optional):
- Position: Bottom right, 16dp from edges
- Size: 56dp
- Background: #1976D2
- Icon: Map icon, color white
- Elevation: 6dp
- On tap: Show hotels on map view

INTERACTION STATES:
- Search bar: Ripple effect on tap
- Hotel cards: Slight elevation increase on press (2dp to 4dp)
- Category chips: Smooth color transition on selection
- Buttons: Scale animation (0.95) on press

RESPONSIVE DESIGN:
- Tablets: Show 2 columns of hotel cards
- Small phones: Reduce image height to 160dp
- Large phones: Keep single column

SCROLLING BEHAVIOR:
- App bar: Remains fixed
- Search section: Remains fixed
- Rest of content: Scrolls smoothly
- Smooth scroll physics with bounce effect on iOS

COLOR PALETTE:
- Primary: #1976D2
- Surface: #FFFFFF
- Background: #FAFAFA
- On Surface: #212121
- Subtitle: #757575
- Divider: #E0E0E0

TYPOGRAPHY:
- Font family: Poppins or Roboto
- Headers: Weight 600-700
- Body: Weight 400-500
- Captions: Weight 400

Generate complete Flutter code with proper ListView, Card widgets, shimmer loading, and responsive design.
```

---

## 🔍 SCREEN 3: Search Results Page

### Prompt for Stitch:

```
Create a comprehensive Flutter Search Results page with filtering options and paginated hotel listings.

DESIGN SPECIFICATIONS:

APP BAR:
- Height: 112dp (56dp + 56dp for search)
- Background: White with bottom shadow
- Content:
  
  TOP SECTION (56dp):
  - Left: Back arrow button (24dp icon)
  - Center: "Search Results" text, 18sp, weight 500
  - Right: Favorite/Save icon (24dp, optional)
  - Padding: 16dp horizontal
  
  SEARCH SECTION (56dp, below top):
  - Compact search bar:
    * Height: 40dp
    * Background: #F5F5F5
    * Border radius: 20dp
    * Padding: 8dp horizontal
    * Content: Search query text, 14sp
    * Right: Clear/close icon (20dp)
    * Margin: 8dp all sides

FILTER BAR (Below app bar):
- Height: 56dp
- Background: White
- Horizontal scrollable chips:
  * Filter chips: "Price", "Rating", "Amenities", "Property Type", "Distance"
  * Chip height: 36dp
  * Unselected: Border 1dp #E0E0E0, Background white, Text #212121
  * Selected: Border 1dp #1976D2, Background #E3F2FD, Text #1976D2
  * Icon: Down arrow (16dp) on right if expandable
  * Padding: 12dp horizontal
  * Spacing: 8dp between chips
  * First chip: 16dp from left
- Right side: Sort icon button (24dp)

RESULTS HEADER (Below filters):
- Height: 48dp
- Background: #FAFAFA
- Padding: 16dp horizontal
- Content:
  * Left: "Found 127 hotels" in 14sp, color #212121, weight 500
  * Right: Grid/List view toggle icons (24dp each)
- Bottom border: 1dp #E0E0E0

HOTEL CARDS (Scrollable list with pagination):
- Padding: 12dp horizontal, 8dp vertical
- Card design (Compact horizontal layout):
  * Width: Match parent
  * Height: 140dp
  * Border radius: 12dp
  * Background: White
  * Elevation: 1dp
  * Margin bottom: 12dp
  
  CARD CONTENT (Horizontal layout):
  
  1. LEFT SECTION - IMAGE (35% width):
     - Width: 120dp
     - Height: Match parent
     - Border radius: 12dp (left side only)
     - ClipRRect for rounded corners
     - Favorite icon overlay: Top right, 8dp padding
       * Icon: Heart outline/filled (20dp)
       * Background: White circle (32dp)
       * Shadow: Subtle drop shadow
  
  2. RIGHT SECTION - CONTENT (65% width):
     Padding: 12dp all sides
     
     a) Header Row:
        - Hotel name: 16sp, weight 600, color #212121
        - Max lines: 1, ellipsis
        - Star rating badge next to name:
          * "⭐ 4.5" in 12sp
          * Background: #FFF3E0 (Amber 50)
          * Padding: 4dp 8dp
          * Border radius: 4dp
     
     b) Location Row (4dp below name):
        - Location pin icon (14dp), color #757575
        - City name: 13sp, color #757575
        - Distance: "2.5 km from center" in 11sp, color #9E9E9E
        - Max lines: 1, ellipsis
     
     c) Amenities Row (6dp below location):
        - Small icons (16dp): WiFi, Parking, Pool (max 3)
        - Color: #757575
        - Spacing: 8dp
        - "+5 more" text if additional amenities
     
     d) Bottom Row (Spacer pushes to bottom):
        - Left aligned - Price section:
          * Strikethrough: "₹2,500" in 12sp, #9E9E9E
          * Current: "₹1,999" in 18sp, weight 700, #1976D2
          * "/night" in 11sp, #757575
        
        - Right aligned - View button:
          * "View" text button
          * Text: 14sp, weight 500, #1976D2
          * Or arrow icon (20dp)

PAGINATION INDICATOR (At bottom of list):
- Shows when loading more results
- Design:
  * Centered horizontally
  * Padding: 16dp vertical
  * CircularProgressIndicator (24dp)
  * Color: #1976D2
  * Text below: "Loading more..." in 12sp, #757575

NO MORE RESULTS INDICATOR:
- Text: "No more results"
- Font size: 14sp, color #9E9E9E
- Center aligned
- Padding: 24dp vertical

EMPTY STATE (No results found):
- Centered vertically and horizontally
- Icon: Search with X (80dp), color #E0E0E0
- Title: "No hotels found"
  * Font size: 20sp, weight 600, color #212121
- Subtitle: "Try adjusting your filters"
  * Font size: 14sp, color #757575
- Action button: "Clear Filters"
  * Height: 48dp, padding 24dp horizontal
  * Background: #1976D2, text white
  * Border radius: 24dp
  * Margin top: 24dp

LOADING STATE (Initial):
- Show 5 shimmer cards with:
  * Same layout as hotel card
  * All content as animated grey rectangles
  * Shimmer animation: Grey (#E0E0E0) to Light Grey (#F5F5F5)
  * Duration: 1500ms, repeat
  * Border radius matches actual cards

FILTER BOTTOM SHEET (Optional):
- Appears from bottom when filter chip tapped
- Height: 70% of screen
- Border radius: 24dp (top corners)
- Content:
  * Handle bar (centered top)
  * Filter title: "Filter By Price"
  * Range slider with min/max labels
  * Apply/Reset buttons at bottom
- Background: White
- Drag handle: 4dp height, 40dp width, color #E0E0E0

FLOATING ELEMENTS:
1. Scroll to Top Button (appears after scrolling 200dp):
   - Position: Bottom right, 16dp from edge
   - Size: 48dp
   - Background: White
   - Icon: Up arrow, color #1976D2
   - Elevation: 4dp
   - Border: 1dp #E0E0E0

2. Active Filters Chip (if filters applied):
   - Position: Top of results list
   - Background: #E3F2FD
   - Text: "3 filters applied" with close icon
   - Border: 1dp #1976D2
   - Padding: 8dp 12dp
   - Height: 32dp

INTERACTION STATES:
- Hotel card tap: Navigate to hotel details with hero animation
- Favorite icon: Toggle with scale animation
- Filter chips: Bottom sheet slides up
- Sort icon: Show dropdown menu overlay
- Pagination: Trigger at 80% scroll position

SCROLLING BEHAVIOR:
- Smooth scroll with momentum
- Pull to refresh at top (refresh results)
- Infinite scroll at bottom (load more)
- Scroll position maintained on back navigation

RESPONSIVE DESIGN:
- Tablets: Show grid view (2 columns) option
- Small phones: Reduce image width to 100dp
- Landscape: Compact cards with smaller padding

ANIMATIONS:
- Card entry: Fade in with slide up (150ms stagger)
- Filter sheet: Slide up with fade (300ms)
- Pagination loader: Fade in (200ms)
- Favorite toggle: Scale bounce effect

ACCESSIBILITY:
- All interactive elements: 48dp minimum touch target
- Semantic labels for screen readers
- Sufficient color contrast (WCAG AA)
- Focus indicators for keyboard navigation

COLOR PALETTE:
- Primary: #1976D2
- Surface: #FFFFFF
- Background: #FAFAFA
- On Surface: #212121
- Secondary Text: #757575
- Divider: #E0E0E0
- Error: #D32F2F
- Success: #388E3C

TYPOGRAPHY:
- Font: Poppins or Roboto
- Hotel Names: 16sp, weight 600
- Prices: 18sp, weight 700
- Body text: 13-14sp, weight 400
- Captions: 11-12sp, weight 400

PERFORMANCE OPTIMIZATIONS:
- Use ListView.builder for efficiency
- Implement image caching
- Lazy load images with fade-in
- Debounce scroll events (100ms)
- Cancel previous API calls on new search

Generate complete Flutter code with proper pagination logic, shimmer loading, filter functionality, and smooth animations.
```

---

## 🎨 BONUS: Common Widgets

### Prompt for Stitch:

```
Create reusable Flutter widgets for the MyTravaly hotel booking app.

1. HOTEL CARD WIDGET:
Create a reusable HotelCard widget that accepts:
- Hotel data model (name, image, rating, price, location)
- Card style: "compact" (horizontal) or "featured" (vertical)
- onTap callback
- onFavorite callback

Compact style: 140dp height, horizontal layout
Featured style: 280dp height, vertical layout with large image

2. SHIMMER LOADING WIDGET:
Create ShimmerCard widget with:
- Animated gradient shimmer effect
- Same dimensions as HotelCard
- Configurable: compact or featured style
- Animation: 1500ms duration, repeat infinitely
- Colors: #E0E0E0 to #F5F5F5

3. EMPTY STATE WIDGET:
Create EmptyStateWidget that accepts:
- Icon (default: search icon)
- Title text
- Subtitle text
- Action button text and callback (optional)
- Centered layout with proper spacing

4. PRICE TAG WIDGET:
Create PriceTag widget showing:
- Original price (strikethrough)
- Discounted price (large, bold)
- Currency symbol (₹, $, €)
- "/night" suffix
- Percentage discount badge (optional)

5. RATING WIDGET:
Create StarRating widget with:
- Rating value (0-5)
- Star size (configurable)
- Filled stars: #FFC107
- Empty stars: #E0E0E0
- Half star support
- Display rating number next to stars (optional)

6. AMENITY ICON ROW:
Create AmenityIcons widget showing:
- Array of amenity types (wifi, parking, pool, etc.)
- Icon size: 18dp
- Icon color: #1976D2
- Spacing: 12dp
- Show "+X more" if more than display limit
- Horizontal scrollable if many amenities

7. FILTER CHIP WIDGET:
Create FilterChip widget with:
- Label text
- Selected state (boolean)
- Icon (optional)
- onTap callback
- Selected: Blue border and light blue background
- Unselected: Grey border and white background

8. SEARCH BAR WIDGET:
Create CustomSearchBar with:
- Hint text (configurable)
- Search icon (left)
- Clear icon (right, shows when text entered)
- Filter icon (right, optional)
- onSearch callback
- onFilterTap callback
- Background: Light grey (#F5F5F5)
- Border radius: 28dp

Generate complete, reusable Flutter widget code with proper documentation and parameter descriptions.
```

---

## 📱 RESPONSIVE DESIGN PROMPT

### Prompt for Stitch:

```
Create responsive layout utilities for MyTravaly Flutter app that adapts to different screen sizes.

BREAKPOINTS:
- Small phone: width < 360dp
- Normal phone: 360dp <= width < 600dp
- Tablet: 600dp <= width < 900dp
- Desktop: width >= 900dp

CREATE:
1. ResponsiveBuilder widget that provides:
   - Current breakpoint
   - Responsive padding values
   - Responsive font sizes
   - Column count for grids

2. Responsive spacing constants:
   - Small: 8dp
   - Medium: 16dp
   - Large: 24dp
   - XLarge: 32dp

3. Adaptive layouts:
   - Hotel list: 1 column (phone), 2 columns (tablet), 3 columns (desktop)
   - Search bar: Full width (phone), Max 600dp (tablet/desktop)
   - Padding: 16dp (phone), 24dp (tablet), 32dp (desktop)

4. Font size scaling:
   - Headlines: Base size * scale factor
   - Body: Base size * scale factor
   - Captions: Base size * scale factor
   - Scale factors based on screen size

Generate Flutter code with MediaQuery usage, LayoutBuilder, and responsive utilities.
```

---

## 🎯 USAGE INSTRUCTIONS FOR STITCH

1. **Copy the specific screen prompt** you want to generate
2. **Paste into Stitch** or your UI generation tool
3. **Review the generated code** and adjust colors/spacing if needed
4. **Integrate with BLoC** logic from Codex agent tasks
5. **Test on multiple devices** using the responsive specifications
6. **Iterate if necessary** by refining the prompt

---

## ✅ VALIDATION CHECKLIST

After generating UI with Stitch, verify:

- [ ] All colors match the defined palette
- [ ] Typography uses specified font sizes and weights
- [ ] Spacing follows 8dp grid system
- [ ] Touch targets are minimum 48x48dp
- [ ] Animations are smooth (60fps)
- [ ] Loading states display correctly
- [ ] Empty states are user-friendly
- [ ] Images have proper placeholders
- [ ] Cards have correct elevation and shadows
- [ ] Responsive design works on different screen sizes
- [ ] All icons are properly sized and colored
- [ ] Text truncation works correctly (ellipsis)
- [ ] Buttons have proper ripple/press effects
- [ ] Accessibility labels are present

---

## 🎨 DESIGN SYSTEM REFERENCE

**Color Palette:**
```
Primary: #1976D2 (Material Blue 700)
Primary Light: #42A5F5 (Blue 400)
Primary Dark: #1565C0 (Blue 800)
Accent: #FF9800 (Orange 500)
Background: #FAFAFA
Surface: #FFFFFF
Error: #D32F2F (Red 700)
Success: #388E3C (Green 700)
Text Primary: #212121 (Grey 900)
Text Secondary: #757575 (Grey 600)
Divider: #E0E0E0 (Grey 300)
```

**Typography Scale:**
```
H1: 32sp, Bold (Page titles)
H2: 24sp, SemiBold (Section headers)
H3: 20sp, SemiBold (Card titles)
H4: 18sp, SemiBold (Small headers)
Body1: 16sp, Regular (Primary text)
Body2: 14sp, Regular (Secondary text)
Caption: 12sp, Regular (Labels, hints)
Button: 14sp, Medium (Button text)
```

**Spacing System (8dp grid):**
```
XXS: 4dp
XS: 8dp
S: 12dp
M: 16dp
L: 24dp
XL: 32dp
XXL: 48dp
```

**Border Radius:**
```
Small: 4dp (badges, chips)
Medium: 8dp (small buttons)
Large: 12dp (cards)
XLarge: 16dp (large cards)
Full: 24-28dp (search bars, pills)
```

**Elevation:**
```
Level 0: 0dp (flat)
Level 1: 1dp (subtle)
Level 2: 2dp (cards)
Level 4: 4dp (raised elements)
Level 6: 6dp (FAB)
Level 8: 8dp (dialogs)
```

---

## 💡 TIPS FOR BEST RESULTS

1. **Be Specific**: Include exact measurements, colors, and spacing
2. **Provide Context**: Explain what each element does
3. **Include States**: Mention loading, error, empty, and success states
4. **Specify Interactions**: Describe tap, scroll, and animation behaviors
5. **Consider Accessibility**: Mention touch targets and contrast
6. **Think Responsive**: Define behavior for different screen sizes
7. **Reusability**: Design components that can be reused
8. **Performance**: Mention lazy loading and optimization needs

---

## 🚀 INTEGRATION WITH CODEX TASKS

These UI components integrate with Codex agent tasks:

- **Sign-In Page** → Task 1 (Auth BLoC)
- **Home Page** → Task 2 (Hotel BLoC)
- **Search Results** → Task 3 (Search BLoC)
- **Common Widgets** → Used across all tasks

The UI is designed to work seamlessly with the Clean Architecture and BLoC pattern implemented by the Codex agent.
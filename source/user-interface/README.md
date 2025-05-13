# Folder `user-interface`

This directory contains the implementation of the user interface.

The main UI is built on top of a `CustomMenu`, a customizable variant of `Menu2`, leveraging the native UI controls of the watch. Sitemap widgets are implemented as `CustomMenuItem` instances. These display a state and may offer direct control (e.g., toggle switches) or open full-screen views for more complex interactions with sitemap elements.

The *Settings* menu is also implemented using a `CustomMenu`.

**Further Reading:**

* [Connect IQ Core Topics – Native UI Controls](https://developer.garmin.com/connect-iq/core-topics/native-controls/)
* [Connect IQ API Docs – `Toybox.WatchUi.CustomMenu`](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/CustomMenu.html)

---

## Folder `commons`

Contains base classes for menu implementations:

* `BaseMenu`: Extends `CustomMenu` and applies consistent styling across all menus in the app.
* `BaseMenuItem`: Extends `CustomMenuItem` to provide consistent behavior and styling support across the app. At present, its main function is to enable the focus indicator used on Garmin Edge devices.
  Note that apart from that, the *Settings* menu and sitemap menus currently use differently styled menu items. Common styling for sitemap-related menu items is implemented in `sitemap-menu/base/BaseSitemapMenuItem`.

This directory also includes:

* `ViewHandler`: A centralized utility that **must** be used for switching between views instead of calling `WatchUi` functions directly.

---

## Folder `error-handling`

Handles and displays exceptions within the app.

* `ErrorView`: A full-screen view that displays exceptions. Includes static methods to show or hide the view.
* `ExceptionHandler`: Provides reusable methods for managing exceptions throughout the app. Its primary role is to determine whether an error should be shown as a toast notification (for non-fatal errors) or via a full-screen error view (for fatal errors). It also implements logic to escalate non-fatal errors to fatal ones if they persist beyond a defined duration.
* `ToastHandler`: Determines if non-fatal errors should be shown as toast notifications and offers a method for displaying them.

---

## Folder `user-interface/glance-view`

Implements the *Glance* view.

**Further Reading:**

* [Connect IQ Core Topics – Glances](https://developer.garmin.com/connect-iq/core-topics/glances/)
* [Connect IQ API Docs – `Toybox.WatchUi.GlanceView`](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/GlanceView.html)

---

## Folder `loading-view`

Displays a full-screen "Loading..." message. This view appears when the widget starts and no sitemap is available in storage, and remains visible until a sitemap is received from the server.

---

## Folder `settings-menu`

Implements the *Settings* menu.

### Platform-Specific Behavior

* **Button-based devices:**
  The *Settings* menu is accessed as a parallel menu to the homepage. It is triggered by scrolling over the title or footer of the *Homepage* menu, mimicking how the system settings menu is accessed on devices like the Fenix 7 Pro or Epix 2 Pro.

* **Touch-based devices:**
  Due to less effective gesture support, the *Settings* menu appears as a regular menu item within the *Homepage*.

Device-specific behavior is defined in the `monkey.jungle` build file ([link](https://github.com/TheNinth7/ohg?tab=readme-ov-file#root-folder-)). Exclusion annotations (also found in the input delegates) ensure the correct implementation per device.

### Subfolders

#### `settings-menu/menu`

Contains the `SettingsMenu` implementation based on `BaseMenu` (see [Commons](#folder-commons)), along with the corresponding input delegates for handling user interaction.

#### `settings-menu/menu-items`

Includes individual menu items used within the *Settings* menu.

---

## Folder `sitemap-menu`

Implements the main UI for displaying sitemap content.

### Subfolder `sitemap-menu/menu`

* `BasePageMenu`: Extends `BaseMenu` and provides the logic to display a list of sitemap elements at a specific hierarchy level.
* `HomepageMenu`: Represents the root level (*Homepage*) of the sitemap.
* `PageMenu`: Represents sitemap frames (folders).

Each of these has an associated input delegate. Exclusion annotations in `HomepageMenu` and `HomepageMenuDelegate` enable the platform-specific *Settings* menu behavior described [above](#folder-settings-menu).

### Subfolder `sitemap-menu/menu-items`

Contains the actual implementations of sitemap menu items (analogous to openHAB widgets).

#### Structure

* `MenuItem` classes (e.g., `OnOffMenuItem`) implement the interactive list entries.
* `Drawable` classes render visual components (e.g., `OnOffStatusDrawable` for toggle switches).
* `View` classes define full-screen views opened when selecting a menu item.

The base class `base/BaseSitemapMenuItem` provides a standard structure for all menu items, supporting:

* A left-side `Drawable` icon
* A central text label
* A right-side status indicator, also implemented via `Drawable`

#### Widget Subfolders

* `page`: Menu items representing sitemap `Frame` elements.
* `settings`: The *Settings* entry shown on touch-based devices.
* `switch`: Items representing `Switch` sitemap elements.
* `text`: Items representing `Text` sitemap elements.

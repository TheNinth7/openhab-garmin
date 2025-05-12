# Folder `/source`

The app is written in **Monkey C**, Garmin's programming language, using the Connect IQ SDK API for UI, settings, persistent storage, and HTTP requests to openHAB.

**Annotations:**

- `(:glance)` is used to identify code that needs to be available in the *Glance*.
- Use of exclude annotations helps the build system tailor the code to each device (see the `monkey.jungle` file in the [root folder](../README.md#root-folder-) for details).

**Inline Documentation:**

Each .mc code file contains inline documentation explaining the purpose and innerworkings of the class.

**Further reading:**

- [Connect IQ Core Topics](https://developer.garmin.com/connect-iq/core-topics/)  
- [Connect IQ API Reference](https://developer.garmin.com/connect-iq/api-docs/)

<br>

## Root Folder `/`

In the root folder resides `OHApp`, the base class for the app. Responsible for initializing the initial view for both glance and widget modes, as well
as handling logic that runs during app startup and shutdown.

This class also includes logic executed when the app is updated
 or when settings are changed.

<br>

## Folder `exceptions`

Contains all custom exception classes used by the app, with `GeneralException` as their base class.

<br>

## Folder `logging`

Contains the class `Logger`, which provides methods to print debug statements and exception to system out.

<br>

## Folder `settings`

Contains the class `AppSettings`, which reads and verifies all application settings, and provides static accessor methods. See also [Folder `resources`](https://github.com/TheNinth7/ohg#folder-resources).

**Further reading**

[Module: Toybox.Application.Properties](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Properties.html)

[Connect IQ SDK Core Topics - Resources](https://developer.garmin.com/connect-iq/core-topics/resources/)

<br>

## Folder `sitemap`

Contains classes that read the JSON dictionary coming in from web requests (or storage) and make its data available to the classes building the menu structure. `SitemapHomepage` is the root element, representing the homepage of the sitemap. `SitemapElement` is the base class of all sitemap elements, and `SitemapPrimitiveElement` of all widgets.

<br>

## Folder `storage`

Contains classes for persisting data into and reading data from storage. As per the time of writing the following elements are persisted:

- JSON Dictionary: the latest sitemap is cached, for use when the app starts up next time.

- Sitemap Label: the sitemap label is stored for display by the *Glance*. While the *Glance* also requests the sitemap it may not be able to retrieve it due to memory constraints, and in that case it should still be able to display the sitemap label.

- Sitemap Error Count: keep track of non-fatal communication errors across *Glance* and *Widget*. Non-fatal communication errors become fatal after a certain error count is reached, and this count is kept between both application types and also if the app is stopped and started again.

**Further reading**

[Connect IQ Core Topics - Persisting Data](https://developer.garmin.com/connect-iq/core-topics/persisting-data/)

[Connect IQ API Docs - Module: Toybox.Application.Storage](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Storage.html)

<br>

## Folder `user-interface`

Contains the implementation of the user interface.

The main user interface is build upon a `CustomMenu`, a customizable full-screen variant of the `Menu2`, utilizing the native UI controls of the watch. Sitemap widgets are implemented as `CustomMenuItem`, which display a state, in some cases offer direct control for changing the state (like an on/off switch) or open a dedicated full-screen wall for more elaborate controls for the sitemap element.

Also the *Settings* menu is based on a `CustomMenu`.

**Further reading**

[Connect IQ Core Topics - Native UI Controls](https://developer.garmin.com/connect-iq/core-topics/native-controls/)

[Connect IQ API Docs - Module: Toybox.WatchUi.CustomMenu](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/CustomMenu.html)

### Folder `user-interface/commons`

Contains base classes for menu implementations in the app: 

- `BaseMenu` is derived from `CustomMenu` and applies styling for a unified look across the app.
- `BaseMenuItem` is derived from `CustomMenuItem` and again provides unified styling. Implementations of this class can provide a `Drawable` icon and status, and a text-based label. 

- Also in this directory is the `ViewHandler`, which MUST be just throughout the app for switching between views (instead of the corresponding `WatchUi` functions).

<br>

### Folder `user-interface/error-handling`


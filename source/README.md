# Folder `/source`

The app is written in **Monkey C**, Garmin's programming language, using the Connect IQ SDK API for UI, settings, persistent storage, and HTTP requests to openHAB.

**Annotations:**

- `(:glance)` is used to identify code that needs to be available in the *Glance*.
- Use of exclude annotations helps the build system tailor the code to each device (see the `monkey.jungle` file in the [root folder](../README.md#root-folder-) for details).

**Inline Documentation:**

Each .mc code file contains inline documentation explaining the purpose and innerworkings of the class.

## Folder `exceptions`

Contains all custom exception classes used by the app, with `GeneralException` as their base class.

## Folder `logging`

Contains the class `Logger`, which provides methods to print debug statements and exception to system out.

## Folder `settings`

Contains the class `AppSettings`, which reads and verifies all application settings, and provides static accessor methods. See also [Folder `resources`](https://github.com/TheNinth7/ohg#folder-resources).

**Further reading**

[Module: Toybox.Application.Properties](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Properties.html)

[Connect IQ SDK Core Topics - Resources](https://developer.garmin.com/connect-iq/core-topics/resources/)

## Folder `sitemap`

Contains classes that read the JSON dictionary coming in from web requests (or storage) and make its data available to the classes building the menu structure. `SitemapHomepage` is the root element, representing the homepage of the sitemap. `SitemapElement` is the base class of all sitemap elements, and `SitemapPrimitiveElement` of all widgets.

## Folder `storage`

Contains classes for persisting data into 


**Further reading:**

- [Connect IQ Core Topics](https://developer.garmin.com/connect-iq/core-topics/)  
- [Connect IQ API Reference](https://developer.garmin.com/connect-iq/api-docs/)

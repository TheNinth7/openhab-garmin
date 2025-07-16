# openHAB for Garmin

An app that connects your Garmin wearable to your [openHAB](https://www.openhab.org) smart home system, giving you convenient access to essential devices and real-time information.

<a href="https://apps.garmin.com/apps/93fd8044-1cf4-450c-b8aa-1c80a6730d1a" target="_blank" class="external" style="margin-top: auto; margin-bottom: auto; margin-right: 20px;">
  <img alt="Get it on Connect IQ Store" src="docs/images/connect_iq_badge.svg" width="240px">
</a>

<br>
<br>

The user manual is published via GitHub Pages at <https://next.openhab.org/docs/apps/garmin/>.

<br>

# Table of Contents

This README covers the following topics:

- [Introduction](#introduction)
- [Project Structure](#project-structure)
  - [Root Folder `/`](#root-folder-)
  - [Folder `/docs`](#folder-docs)
  - [Folder `/releases`](#folder-releases)
  - [Folder `/resources`](#folder-resources)
  - [Folder `/source`](#folder-source)
  - [Folder `/source-constants`](#folder-source-constants)
- [Build Instructions](#build-instructions)
  - [To Run the App in the Garmin Simulator](#to-run-the-app-in-the-garmin-simulator)
  - [To Compile for a Single Device](#to-compile-for-a-single-device)
  - [Generating the `.iq` File for Garmin Connect IQ Store Upload](#generating-the-iq-file-for-garmin-connect-iq-store-upload)
  - [To Add a New Device](#to-add-a-new-device)
- [Helpful Tips and Notes](#helpful-tips-and-notes)
- [Copyright Notice](#copyright-notice)
- [Attributions](#attributions)

<br>

## Introduction

This app is built using the Garmin Connect IQ SDK and is based on [openHAB sitemaps](https://www.openhab.org/docs/ui/sitemaps.html).

It includes two application types:

- _**Glance**_: A lightweight, quick-access entry point.
- _**Widget**_: The main, full-screen interface for interacting with the sitemap.

### _Widget_ Overview

The _Widget_:

- Displays a hierarchical structure representing a single sitemap, using the SDK's `CustomMenu` and `CustomMenuItem`.
- Requests sitemap updates at a configurable interval.
- Updates the menu whenever a new response is received.
- Caches the latest sitemap response in persistent storage.
- Renders sitemap *Widget*s using specific `CustomMenuItem` implementations, which may also send commands to items.

### _Glance_ Overview

The _Glance_:

- Displays the sitemap label.
- If sufficient memory is available, it also requests the sitemap at the same interval as the _Widget_ and caches it in storage, allowing the _Widget_ to start with a fresh state.

**Further reading:**

- [openHAB for Garmin User Manual](https://next.openhab.org/docs/apps/garmin/)
- [Connect IQ for Developers](https://developer.garmin.com/connect-iq)
- [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)

# Project Structure

The project is organised into the following directories:

## Root Folder `/`

The root directory contains essential project files.

**Key files:**

- `README.md`: This file
- `manifest.xml`: Defines the app's structure, supported devices, and required permissions (e.g., storage, background tasks)
- `monkey.jungle`: The build script that determines available features per device. It includes extensive documentation in the file itself.

**Further reading:**

- [Connect IQ SDK Core Topics - Manifest and Permissions](https://developer.garmin.com/connect-iq/core-topics/manifest-and-permissions/)  
- [Connect IQ SDK Core Topics - Build Configuration](https://developer.garmin.com/connect-iq/core-topics/build-configuration/)

<br>

## Folder `/.vscode`

Contains VS Code customizations.

## Folder `/docs`

Contains the user manual, published at <https://next.openhab.org/docs/apps/garmin/>.

<br>

## Folder `/releases`

This folder contains compiled binary releases of the app, intended for upload to the Garmin Connect IQ Store.

<br>

## Folder `/resources`

In the Connect IQ SDK, resources define:

- **Properties**: Parameters stored outside the app and not visible to the user. These are currently _not_ used by the app; instead, more flexible **Constants** are used. See [Folder `source-constants`](#folder-source-constants) for details.

- **Settings**: User-facing configurations
- **Drawables**: Image assets used by the app
- **Strings**: Text values like app name and version

**Folder breakdown:**

- `/resources/base`: Contains resources shared across all device types.
  - `/resources/base/drawables.xml`: Defines image assets used in the app (referenced as `Drawable` elements).
  - `/resources/base/settings.xml`: Specifies the app’s configuration settings, including default values, types, and user-facing descriptions.
  - `/resources/base/string.xml`: Contains static string values such as the app name and version number.
- `/resources/edge`: Contains resources specific to Garmin Edge devices. Some `Drawable` elements are overridden here to account for different sizing requirements.
- `/resources/launcher-icons`: Contains one subdirectory per launcher icon size. Each subdirectory includes a resource definition for that specific size. The correct icon is selected via the resource path in the `monkey.jungle` build file, depending on the target device.
- `/resources/svg`: Contains the original SVG files used to generate `Drawable` resources.

**Further reading:**

- [Connect IQ SDK Core Topics - Resources](https://developer.garmin.com/connect-iq/core-topics/resources/)

<br>

## Folder `/source`

The app is written in **Monkey C**, Garmin's programming language, using the Connect IQ SDK API for UI, settings, persistent storage, and HTTP requests to openHAB.

For more details, continue reading the folder’s [README](https://github.com/TheNinth7/ohg/tree/main/source#folder-source).

<br>

## Folder `/source-constants`

This folder defines device-specific configuration using code-based _Constants_, which replace Garmin SDK _Properties_ due to their limitations. Unlike _Properties_, _Constants_ are embedded in the code, update automatically with new app versions, and benefit from compiler validation.

For more details, continue reading the folder’s [README](https://github.com/TheNinth7/ohg/tree/main/source-constants#folder-source-constants).

<br>

# Build Instructions

Follow the steps below to build, run, and test the app using the Connect IQ SDK and Garmin simulator.
<br>

## To Run the App in the Garmin Simulator

1. Install:
   - Visual Studio Code
   - Git
   - [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) (see [Connect IQ SDK Installation](docs/SDK_INSTALLATION.md) for troubleshooting)
   - Monkey C extension for VS Code

1. Open VS Code and clone the `openhab-garmin` repository
1. Open any file in the `/source` folder
1. Press **F5** to start the simulator and select a target device
1. Go to `File` → `Edit Persistent Storage` → `Edit Application.Properties` and configure as needed  
   - To allow HTTP URLs, uncheck `Settings > Use Device HTTPS Requirements`

<br>

## To Compile for a Single Device

1. Press `CTRL+SHIFT+P` → `Monkey C: Build Current Project`

<br>

## Generating the `.iq` File for Garmin Connect IQ Store Upload

Follow these steps to prepare and export your app for upload to the Garmin Connect IQ Store:

1. **Remove Debug Statements**

   Ensure all debug logging or print statements are commented out or removed.
   See [Removing Debug Statements](#removing-debug-statements) for guidance.

1. **Update the Version Number**

   Edit the file `resources/base/strings.xml` and set the correct version number for this release.

1. **Set the Correct App ID**

   Open `manifest.xml` and set the appropriate app ID:

   - Use the _stable_ app ID for production releases.
   - Use the _beta_ app ID for test releases.

   > 🛠 You’ll need to switch to XML mode in your editor to change this value manually.

1. **Export the Project**

   Use the command palette:
   `CTRL + SHIFT + P` → `Monkey C: Export Project`
   This will generate the `.iq` file used for uploading.

<br>

## To Add a New Device

To support a new device:

1. If the device isn't available in your current SDK, launch the **SDK Manager** and download/activate the latest version.
1. In `manifest.xml`, check the new device in the supported device list.
1. Configure device-specific features in the `monkey.jungle` build file (see [Root Folder `/`](#root-folder-)).
1. Test in the simulator (see [above](#to-run-the-app-in-the-garmin-simulator))
1. Export the project (`CTRL+SHIFT+P` → `Monkey C: Export Project`) and upload the `.iq` file to the Connect IQ Store

**Further reading:**

- [Connect IQ SDK - Compatible Devices](https://developer.garmin.com/connect-iq/compatible-devices/)
- [Connect IQ SDK - Device Reference](https://developer.garmin.com/connect-iq/device-reference/)

<br>

# Helpful Tips and Notes

A collection of useful information for working on this project.

## Removing Debug Statements

While debug statements are only printed in debug builds, they still occupy code space in release builds. Therefore, when building a release, all debug statements should be commented out.

To find all active debug statements in VS Code, press `CTRL+SHIFT+H` to open the global search and replace panel. Enable regular expressions by clicking the `.*` icon next to the search field, and use the following pattern to locate all active debug statements:

```regexp
(?<!\/\/ )Logger\.debug\(
```

To deactivate the debug statements, replace them with:

```text
// Logger.debug(
```

This will comment them out without affecting any lines that are already commented.

# Copyright Notice

```text
Copyright (c) 2025 Contributors to the openHAB project

The contents of this repository are made available under the
terms of the Eclipse Public License 2.0 which is available at
http://www.eclipse.org/legal/epl-2.0

SPDX-License-Identifier: EPL-2.0
```

# Attributions

The [interface icons](resources/icons-interface), except for the openHAB logo, are licensed under CC BY 3.0 by [Adrien Coquet](https://adrien-coquet.com/) from [Noun Project](https://thenounproject.com/browse/icons/).

# Folder `/source-constants`

This folder defines device-specific configuration via code-based constants, replacing Garmin SDK *Properties*, which have significant limitations.

## Why Constants?

The Garmin SDK’s *Properties* are stored externally from the app and persist across installations. This means that when a new version of the app is installed, any existing properties from the previous version remain, unless the user performs a full uninstall and reinstall. To avoid this issue and allow reliable updates, the app uses *Constants* instead:

* Constants are part of the code base and automatically update with new app versions.
* The compiler validates constant usage, reducing runtime errors.
* Constants can be cleanly overridden for specific devices.

### Structure and Usage

All devices inherit default values from `DefaultConstants` and `GlanceDefaultConstants`, which define all configuration values used in the *Widget* and *Glance*, respectively.

In the source code, these are accessed via the `Constants` and `GlanceConstants` classes. Each supported device may override the defaults by providing its own implementation of these classes.

### Key Files and Directories

* `/source/base`:
  Contains `DefaultConstants` and `GlanceDefaultConstants`, which define the baseline values for all devices.

* `/source/default-device`:
  Contains default `Constants` and `GlanceConstants` implementations. These inherit all values from the base without overrides.

* `/source/edge`:
  Contains Edge-specific implementations of `Constants` and `GlanceConstants`, overriding select values to adapt the UI for Garmin Edge devices.

* `/source/fenix6pro`:
  Contains Fenix 6 Pro-specific implementations of `Constants` and `GlanceConstants`, adjusting select values to better fit the device's display.

<br>

# Build Instructions

Follow the steps below to build, run, and test the app using the Connect IQ SDK and Garmin simulator.
<br>

## To Run the App in the Garmin Simulator

1. Install:
   - Visual Studio Code
   - Git
   - [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
   - Monkey C extension for VS Code

2. Open VS Code and clone the `ohg` repository
3. Open any file in the `/source` folder
4. Press **F5** to start the simulator and select a target device
5. Go to `File` → `Edit Persistent Storage` → `Edit Application.Properties` and configure as needed  
   - To allow HTTP URLs, uncheck `Settings > Use Device HTTPS Requirements`

<br>

## To Compile for a Single Device

1. Press `CTRL+SHIFT+P` → `Monkey C: Build Current Project`

<br>

## To Compile for All Devices and Export `.iq` File for Upload

The following command generates the `.iq` file, which is used for uploading the app to the Garmin Connect IQ Store.

1. Make sure all debug statements are commented out. See [Removing Debug Statements](#removing-debug-statements) for details.
2. Press `CTRL+SHIFT+P` → `Monkey C: Export Project`

<br>

## To Add a New Device

To support a new device:

1. If the device isn't available in your current SDK, launch the **SDK Manager** and download/activate the latest version.

2. In `manifest.xml`, check the new device in the supported device list.

3. Configure device-specific features in the `monkey.jungle` build file (see [Root Folder `/`](#root-folder-)).

6. Test in the simulator (see [above](#to-run-the-app-in-the-garmin-simulator))

7. Export the project (`CTRL+SHIFT+P` → `Monkey C: Export Project`) and upload the `.iq` file to the Connect IQ Store

**Further reading**

- [Connect IQ SDK - Compatible Devices](https://developer.garmin.com/connect-iq/compatible-devices/)
- [Connect IQ SDK - Device Reference](https://developer.garmin.com/connect-iq/reference-guides/devices-reference)

<br>

# Helpful Tips and Notes

A collection of useful information for working on this project.

## Removing Debug Statements

While debug statements are only printed in debug builds, they still occupy code space in release builds. Therefore, when building a release, all debug statements should be commented out.

To find all active debug statements in VS Code, press `CTRL+SHIFT+H` to open the global search and replace panel. Enable regular expressions by clicking the `.*` icon next to the search field, and use the following pattern to locate all active debug statements:

```
(?<!\/\/ )Logger\.debug\(
```

To deactivate the debug statements, replace them with:

```
// Logger.debug(
```

This will comment them out without affecting any lines that are already commented.
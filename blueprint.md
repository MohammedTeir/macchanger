# Blueprint: RootMAC

## 1. Project Overview

RootMAC is a Flutter-based Android application designed for users with rooted devices to manage and change their MAC address. The application provides a user-friendly interface to view the current MAC address, generate new ones, and save them as profiles. It also includes an advanced feature to automatically randomize the MAC address when the device's network connection changes.

---

## 2. Project Outline (Final State)

This section documents the final implemented style, design, and features of the application.

### Style & Design

*   **Theme:**
    *   **Colors:** Based on `Colors.blueGrey` seed, with distinct schemes for Light and Dark modes.
    *   **Dark Mode:** Features a black background (`#121212`) with `cyanAccent` for highlights.
    *   **Light Mode:** Standard Material 3 light theme.
    *   **Theme Toggle:** A theme-switching icon is present in the AppBar.
*   **Typography (Google Fonts):**
    *   **Headlines/Titles:** `Orbitron`
    *   **Monospaced/Data:** `Inconsolata`
    *   **Hero/Display:** `Ocra Iscry`
*   **Layout:**
    *   The main screen uses a `ListView` containing `Card` elements for logical grouping of information (Compatibility, Status, Advanced).
    *   UI is responsive and scrolls vertically.
    *   Consistent padding and spacing are used for a clean look.
*   **Components:**
    *   `ElevatedButton` for primary actions.
    *   `OutlinedButton` for secondary actions (Restore).
    *   `SwitchListTile` for toggling advanced features.
    *   `AlertDialog` for user input (manual MAC change, profile creation).
    *   `SnackBar` for providing user feedback.
    *   `RefreshIndicator` for pull-to-refresh functionality.

### Features Implemented

*   **Phase 1: Core Functionality**
    *   **Root & Compatibility Check:**
        *   Detects if the device is rooted.
        *   Checks for `BusyBox` and `iproute2` binaries.
        *   Displays the status of these checks in the "COMPATIBILITY" card.
    *   **MAC Address Engine (`mac_changer.dart`):**
        *   Retrieves the current MAC address for the `wlan0` interface.
        *   Changes the MAC address using a fallback chain of root commands:
            1.  `ip link`
            2.  `ifconfig`
            3.  Direct write to `/sys/class/net/wlan0/address`
    *   **Core UI Actions:**
        *   **Change MAC:** Opens a dialog to manually input and apply a new MAC address.
        *   **Random MAC:** Generates and applies a valid, locally administered, unicast MAC address.
        *   **Restore Original:** Re-applies the MAC address that was captured when the app first started.
*   **Phase 2: Profiles & Automation**
    *   **Local Database (`database_helper.dart`):**
        *   Uses `sqflite` to create and manage a local `profiles.db` SQLite database.
        *   Stores profiles with a name and MAC address.
    *   **Profiles Screen (`profiles_screen.dart`):**
        *   Navigated to via the "Profiles" button.
        *   Displays a list of all saved profiles.
        *   Allows users to **Create, Edit, and Delete** profiles through dialogs.
        *   Allows users to apply a MAC address by tapping an item in the list.
*   **Phase 3: Advanced Features**
    *   **Network Change Detection (`network_watcher.dart`):**
        *   Uses `connectivity_plus` to subscribe to network state changes.
    *   **Automatic Randomization:**
        *   An "Auto Randomize MAC" switch is available in the "ADVANCED" card.
        *   When enabled, the app listens for network changes and automatically applies a new random MAC address upon connection.
        *   The feature is disabled and the listener is disposed of when the switch is turned off or the app is closed.

---

## 3. Current Plan

**Status: Completed**

All planned phases have been fully implemented. The application is now feature-complete according to this blueprint.

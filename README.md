# RootMAC: Android MAC Address Changer

## Overview

RootMAC is a Flutter-based Android application that allows users with rooted devices to change their device's MAC address. It provides both manual and automatic methods for changing the MAC address, along with a profile management system to save and quickly apply favorite MAC addresses.

## Features

### Core Functionality

*   **Root Detection:** The app checks for root access, along with the presence of `BusyBox` and `iproute2` to ensure compatibility.
*   **MAC Address Display:** It displays the current MAC address of the device's wireless interface (`wlan0`).
*   **Manual MAC Change:** Users can manually enter a new MAC address and apply it.
*   **Random MAC Generation:** The app can generate and apply a random, valid MAC address.
*   **Restore Original MAC:** The original MAC address is saved on startup and can be restored at any time.

### Profiles

*   **Save Profiles:** Users can save their favorite MAC addresses with a custom name for easy access.
*   **Apply from Profile:** A saved MAC address can be applied with a single tap from the profiles screen.
*   **Manage Profiles:** Users can add, edit, and delete their saved profiles.

### Automation

*   **Automatic MAC Randomization:** The app can be configured to automatically change the MAC address to a new random one whenever the device connects to a new network.

### Theming

*   **Dark & Light Mode:** The app includes both a dark and a light theme, with the ability to toggle between them.

## Technical Details

*   **Framework:** Flutter
*   **Platform:** Android (requires root)
*   **Key Packages:**
    *   `provider`: For state management (theme).
    *   `google_fonts`: For custom fonts.
    *   `network_info_plus`: To get network information (IP, etc.).
    *   `sqflite`: For local database (profiles).
    *   `path_provider`: To locate the database file.
    *   `connectivity_plus`: To listen for network changes.

## MAC Change Methods

The app uses a series of fallback methods to change the MAC address to ensure the highest chance of success on different devices and Android versions:

1.  **`ip link`:** Uses the `ip link set dev <interface> address <mac>` command.
2.  **`ifconfig`:** Falls back to the `ifconfig <interface> hw ether <mac>` command.
3.  **Direct File Write:** As a last resort, it attempts to directly write the new MAC address to `/sys/class/net/<interface>/address`.

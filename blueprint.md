# Blueprint: RootMAC

## 1. Project Overview

RootMAC is a Flutter-based Android application designed for users with rooted devices to manage and change their MAC address. The application provides a user-friendly interface to view the current MAC address, generate new ones, and save them as profiles. It also includes an advanced feature to automatically randomize the MAC address when the device's network connection changes.

---

## 2. Project Outline

This section documents the implemented style, design, features, and structure of the application.

### Style & Design

*   **Theme:**
    *   **Colors:** Based on `Colors.blueGrey` seed, with distinct schemes for Light and Dark modes.
    *   **Dark Mode:** Features a black background (`#121212`) with `cyanAccent` for highlights.
    *   **Light Mode:** Standard Material 3 light theme.
    *   **Theme Toggle:** A theme-switching icon is present in the AppBar.
*   **Typography (Google Fonts):**
    *   **Headlines/Titles:** `Orbitron`
    *   **Monospaced/Data:** `Inconsolata`
*   **Layout:**
    *   The main screen uses a `ListView` containing `Card` elements for logical grouping of information.
    *   Consistent padding and spacing are used for a clean look.

### Code Structure & Refactoring

*   **UI Modularity:** The main UI (`HomePage`) has been refactored into smaller, reusable widgets, each with its own file in the `lib/widgets/` directory:
    *   `compatibility_card.dart`
    *   `status_card.dart`
    *   `advanced_card.dart`
    *   `actions_card.dart`
*   **Separation of Concerns:** This refactoring improves code readability, maintainability, and follows Flutter best practices by separating distinct UI components into their own files.

### Features Implemented

*   **Core Functionality:**
    *   **Root & Compatibility Check:** Detects root access, `BusyBox`, and `iproute2`.
    *   **MAC Address Engine (`mac_changer.dart`):** Retrieves and changes the MAC address using root commands.
    *   **Core UI Actions:** Manual MAC change, random MAC generation, and restoring the original MAC.
*   **Profiles & Automation:**
    *   **Local Database (`database_helper.dart`):** Uses `sqflite` to store and manage MAC address profiles.
    *   **Profiles Screen (`profiles_screen.dart`):** Allows for creating, editing, deleting, and applying saved profiles.
*   **Advanced Features:**
    *   **Network Change Detection (`network_watcher.dart`):** Uses `connectivity_plus` to monitor network state.
    *   **Automatic Randomization:** An advanced option to automatically randomize the MAC address upon a new network connection.

### Continuous Integration & Deployment (CI/CD)

*   **GitHub Actions Workflow (`.github/workflows/build.yml`):**
    *   A CI/CD pipeline is configured to automatically trigger on every push to the `main` branch.
    *   **Jobs:**
        1.  **Checkout:** Checks out the repository code.
        2.  **Set up Flutter:** Initializes the Flutter environment.
        3.  **Install Dependencies:** Runs `flutter pub get`.
        4.  **Analyze:** Runs `flutter analyze` to check for code quality issues.
        5.  **Authenticate to Google Cloud:** Securely logs into Google Cloud using a `FIREBASE_SERVICE_ACCOUNT` secret.
        6.  **Build:** Compiles the Flutter application for the web (`flutter build web`).
        7.  **Deploy:** Deploys the built web application to Firebase Hosting.
    *   **Secrets Management:** The workflow relies on GitHub repository secrets (`FIREBASE_SERVICE_ACCOUNT`, `FIREBASE_PROJECT_ID`) for secure authentication.

---

## 3. Current Plan

**Task: Finalize and Document Recent Changes**

**Status: Completed**

1.  **UI Refactoring:** Decomposed the main UI into smaller, more manageable widgets to improve code organization. (Done)
2.  **CI/CD Implementation:** Created a GitHub Actions workflow to automate the build and deployment process to Firebase Hosting. (Done)
3.  **Documentation:** Updated this `blueprint.md` to reflect the latest structural changes and the new CI/CD pipeline. (Done)

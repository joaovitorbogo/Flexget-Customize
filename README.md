<!-- 
NOTE FOR THE DEVELOPER: 
To replace the placeholder images below, take screenshots of your application, 
upload them to a service like Imgur or directly to your GitHub repository, 
and replace the placeholder URLs (https://via.placeholder.com/...) with the direct links to your images.
-->

# Flexget Config Editor

A user-friendly graphical interface (GUI) for Windows to create, edit, and run Flexget `config.yml` files. This tool is designed to simplify the management of Flexget configurations by providing a visual editor, removing the need to manually edit complex YAML files.

![Main Application Window](https://i.imgur.com/gpI2RML.png)

## What is Flexget?

Flexget is a powerful, multi-purpose automation tool for content. Its primary use is to monitor content sources like RSS feeds, parse their entries, and send them to other programs for processing (like a download client).

**How it simplifies RSS downloads:**

Instead of manually checking an RSS feed for new content and then copying download links to your client, Flexget automates the entire process. You simply tell it:

1.  **"Watch this RSS feed."** (e.g., a feed for new TV show episodes)
2.  **"Only accept entries that match these rules."** (e.g., a specific show name, in 1080p resolution, but not larger than 2GB).
3.  **"If an entry is accepted, send its magnet or .torrent link to this download client."** (e.g., sending it to qBittorrent to start the download).

Flexget remembers what it has downloaded, so it never grabs the same content twice. This editor helps you build and manage these powerful rule sets without needing to be a YAML expert.

## Features

*   **Visual Editor:** Create and modify tasks, templates, and schedules through a simple tree view and form-based interface.
*   **Global Settings:** Easily apply common settings (like qBittorrent details) across all your tasks.
*   **One-Click Execution:** Run `flexget execute` directly from the application and see the output in real-time.
*   **Categorized Output:** The output from the execution is automatically sorted into "Accepted," "Rejected," and "Others" panels for easy analysis.
*   **Process Management:** A "Kill Process" button is available to forcibly terminate a stuck or long-running `flexget.exe` process.
*   **Auto-Load:** Optionally, the application can automatically load the last used configuration file on startup.
*   **Debug View:** Inspect the raw YAML that will be saved and an internal representation of the parsed data.

## Installation & Setup

This application is portable, but it depends on a correct Python, qBittorrent, and Flexget setup on your Windows machine. Follow these steps carefully.

### Step 1: Install Python for Windows

Flexget runs on Python. If you don't have it installed, you need to install it first.

1.  Go to the official Python download page: **[https://www.python.org/downloads/](https://www.python.org/downloads/)**
2.  Download the latest stable installer for Windows.
3.  Run the installer. On the first screen, make sure to check the box that says **"Add python.exe to PATH"**. This step is **CRITICAL** for this editor to be able to find Flexget.
    ![Python Installer PATH option](https://docs.python.org/3/_images/win_installer.png)
4.  Proceed with the "Install Now" option and complete the installation.

### Step 2: Install and Configure qBittorrent

This application is designed to integrate Flexget with the qBittorrent download client.

1.  **Download and Install qBittorrent:** If you don't have it, download it from the official site: **[https://www.qbittorrent.org/download.php](https://www.qbittorrent.org/download.php)**
2.  **Enable the Web UI:** Flexget communicates with qBittorrent through its Web User Interface. You must enable it.
    *   Open qBittorrent.
    *   Go to the menu `Tools -> Options...` (or press `Alt+O`).
    *   Click on the `Web UI` tab on the left.
    *   Check the box **"Enable Web User Interface"**.
    *   In the "Authentication" section, enter a **Username** and **Password**. You will need to enter these exact same credentials into the Flexget Config Editor later.
    *   Click `Apply` and `OK`.



### Step 3: Install Flexget

Once Python is installed, you can install Flexget using Python's package manager, `pip`.

1.  Open a Windows Command Prompt (CMD) or PowerShell. You can do this by searching for "cmd" in the Start Menu.
2.  Type the following command and press Enter to install Flexget and its qBittorrent plugin:
    ```
    pip install "flexget[qbittorrent]"
    ```

### Step 4: Verify the Installation

To ensure everything is working correctly, you need to verify that Windows can find the `flexget` command.

1.  In the same Command Prompt window, type the following command and press Enter:
    ```
    flexget --version
    ```
2.  **If it works,** you will see the installed Flexget version number (e.g., `3.1.123`). This means your setup is correct!
3.  **If you get an error** like `'flexget' is not recognized as an internal or external command...`, it means Python was not added to your system's PATH. You will need to reinstall Python, making sure to check the "Add python.exe to PATH" box this time.

### Step 5: Run the Flexget Config Editor

Now that the backend is set up, you can use the editor.

1.  Download the `FlexgetEditor.exe` file.
2.  Place it in any folder of your choice on your computer.
3.  Double-click `FlexgetEditor.exe` to run it.

A configuration file named `FlexgetEditor.ini` will be automatically created in the same folder to store your settings.

## How to Use

The application interface is divided into a main area with three tabs.

### Main Toolbar (Top)

*   **New Config:** Creates a new, blank configuration file with a default structure. It will ask for confirmation before discarding any unsaved changes.
*   **Load Config:** Opens a file dialog to let you select and load an existing `config.yml` or `.yaml` file.
*   **Save Config:** Saves all changes to the currently loaded file. If you are working on a new config, it will open a "Save As" dialog to let you choose a name and location for the new file.
*   **Auto-load last file (Checkbox):** When checked, the application will save the path of the currently open file. The next time you start the program, it will automatically load this file for you.

### Main Window Tabs

#### 1. Task Editor Tab

This is the primary screen for managing your configuration.

*   **Left Panel (Tree View):** Shows the hierarchical structure of your configuration file, with main sections for `Global Settings`, `Templates`, `Tasks`, and `Schedules`. Click on any item in this tree to view and edit its details in the right panel. You can also rename tasks by clicking on a selected task name.
*   **Right Panel (Details):** This area is context-sensitive and displays the properties of the item you selected in the tree view. In the `Global Settings` section, you will enter the qBittorrent Web UI username and password you configured earlier.
*   **Bottom Toolbar:**
    *   **Add Task:** Opens a dialog to create a new task with its name, RSS URL, and download path.
    *   **Remove Task:** Deletes the currently selected task from the configuration (after a confirmation prompt). This button is only enabled when a task is selected.

#### 2. Run Process Tab

This screen is dedicated to executing Flexget and viewing the results.



*   **Run (Button):** Executes the `flexget execute` command.
    *   It operates in the same directory as your saved `config.yml` file.    
    *   **Important:** The application interface will freeze while the command is running. The mouse cursor will change to an hourglass to indicate it is busy.
    *   The output will appear in the panels below in real-time.
*   **Kill Process (Button):** This is an emergency button. It will find and forcibly terminate any running `flexget.exe` process on your system. Use this if the `Run` command gets stuck or takes too long.
*   **Output Panels:**
    *   **Accepted:** Displays all output lines containing the word "ACCEPTED".
    *   **Rejected:** Displays all output lines containing the word "REJECTED".
    *   **Others:** Displays all other output lines, including summaries, errors, and general information.
    Each output line is followed by a blank line for better readability.

#### 3. Debug Tab

This tab is for advanced users or for troubleshooting.

*   **(Left Memo):** Shows the raw YAML text content as it will be saved to the file. This is useful to see the final structure.
*   **(Right Memo):** Shows an internal, structured representation of the data that the application has loaded and parsed from the file.

### Typical Workflow on Windows

1.  Double-click `FlexgetEditor.exe` to start the application.
2.  Click **Load Config** to open your existing `config.yml` file, or click **New Config** to start from scratch.
3.  Use the **Task Editor** tab to make your changes. Select items in the tree on the left and edit their properties on the right.
4.  Once you are satisfied with your changes, click **Save Config**.
5.  Switch to the **Run Process** tab.
6.  Click the **Run** button to execute Flexget with your newly saved configuration.
7.  Observe the output in the "Accepted," "Rejected," and "Others" panels to see what Flexget is doing.
8.  If you want the application to always open this file, check the **Auto-load last file** box.
9.  Close the application when you are finished.

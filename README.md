# Desktop Widget: age-countdown
A KDE Plasma 6 widget Shows time lived since a chosen date/time, updating every second.

<img width="1002" height="671" alt="image" src="https://github.com/user-attachments/assets/481f87dd-1398-469e-94a2-5306f37ab4c7" />
-----

## Features

  * **Real-time Counter**: Displays years, months, days, hours, minutes, and seconds.
  * **Customizable Date/Time**: Set any past date and time as the starting point.
  * **Seamless Integration**: Designed to fit with the KDE Plasma 6 desktop environment.

-----

## Installation Instructions

You can install this widget by building it from the source.

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/devaprog/plasma.age-countdown
    cd <repository-folder-name>
    ```

2.  **Navigate to the source directory:**

    ```bash
    cd source
    ```

3.  **Create the `.plasmoid` package:**
    This command zips the contents of the `source` directory into a package file in the parent directory.

    ```bash
    zip -r ../agefrombirth.plasmoid .
    ```

4.  **Install the widget using the KDE package tool:**
    Move back to the parent directory and run the installation command.

    ```bash
    cd ..
    kpackagetool6 --type Plasma/Applet -i agefrombirth.plasmoid
    ```

-----

## Managing the Widget

You can use `kpackagetool6` to easily install, update, or remove the widget.

  * **To Install:**

    ```bash
    kpackagetool6 --type Plasma/Applet -i agefrombirth.plasmoid
    ```

  * **To Update:**
    After pulling the latest changes and re-packaging the `.plasmoid` file, run:

    ```bash
    kpackagetool6 --type Plasma/Applet -u agefrombirth.plasmoid
    ```

  * **To Remove:**

    ```bash
    kpackagetool6 --type Plasma/Applet -r agefrombirth.plasmoid
    ```

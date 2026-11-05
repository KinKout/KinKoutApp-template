# KinKoutApp-template
___

## What is it

A CMake starting point for JUCE desktop applications in the CLion IDE.

Born from [KinKoutDSP-template][link_kk_dsp_template], this project keeps the same build workflow, folder conventions, and cross-platform launchers while replacing the audio plug-in target with a JUCE desktop application target.

The template currently creates:

- `GUI` - a generic JUCE graphical desktop application.
- `AUDIO` - a JUCE desktop audio application where `AppComponent` connects the audio device to an `AudioAppProcessor` based on `juce::AudioProcessor`.

Both types share the same entry point and window, with a type-specific `AppComponent` implementation. The AUDIO profile includes parameter management and a separate DSP engine. Its example chain uses a 440 Hz oscillator followed by an output gain. A generic parameter editor provides the current user interface. MIDI device handling, parameter persistence and the custom user interface are not implemented yet. `CONSOLE` is planned as a future extension.

- Edit one main configuration file for each new project:
	- [appConfig.cmake][link_appConfig] with the application type, name, version and main options.
- Set up two local configuration files when you first download the template:
	- [companyInfo.cmake][link_companyInfo] with your company data;
	- [definePath.json][link_definePath] with your personal paths.
- Modify [juceModules.cmake][link_juceModules] to add or remove optional JUCE modules when needed.
- Run the launcher for your platform to open the project in CLion on macOS, Windows, or Linux.

> Both `GUI` and `AUDIO` templates have been built on macOS. Windows and Linux launchers and presets are included, but this application template has not yet been tested on those platforms.

___
## What it does

- **One place to configure the application**
	Application metadata, profile and main feature options live in the [_cmake-config][link_cmake-config] folder.
<br>

- **Prepares different application types**
	The application type determines the source templates and the JUCE modules selected automatically.
	`GUI` and `AUDIO` are implemented as starting templates. The type is chosen when the project is created, not switched dynamically afterward.
<br>

- **Validates before it builds**
	Project metadata, profile options and local paths are checked during CMake configuration.
	Errors say what is wrong and how to fix it.
	<br>

- **Generates the source files**
	There are two types of source code templates: ‘essential’ and ‘optional’.
	During the first CMake configuration, `Main.cpp`, `MainWindow.h/.cpp` and `AppComponent.h/.cpp` are created in `source/` from the .txt files in the [template][link_template] folder using the application settings. The AUDIO profile also adds `AudioAppProcessor`, the engine classes, the parameter definitions and the example DSP modules.
	The generator selects the `GUIAppComponent_*` or `AUDIOAppComponent_*` templates and removes the application-type prefix from the generated filenames. Both profiles therefore use the same `AppComponent` name, without a factory or a C++ conditional for selecting the application type.

	The ‘essential’ source files are automatically recreated if missing.
	Once created, existing files are left untouched, so you can edit them like any other source code.
	Changes to the templates do not update source files that already exist.

	The ‘optional’ source files are created only during the first CMake configuration.
	After that, you can use or delete them, and they will not be regenerated unless you set
	`_OPTIONAL_SOURCE_LOADED` back to `FALSE` in `_cmake-config/_scripts/createSourceTemplate.cmake`.
	The AUDIO optional source files are `Gain` and `Oscillator`, two simple DSP examples.
	If you remove one of them, also remove its include, rack instance, controller calls and parameters.
  <br>

- **Cross-platform without duplicating the project**
	The launcher detects the OS, swaps in the matching CMake preset settings and opens CLion.
	The same project folder can live on a synced drive and be used on machines with different operating systems.
	> This workflow is currently tested on macOS only. Windows and Linux support is provided by the inherited launchers and presets and still needs to be verified for this template.
<br>

- **Build summary**
	Each CMake configuration ends with a report:
	application information, selected profile, paths, source files, assets and module status.

___
## Minimum Requirements

- CMake 3.24+
- A C++17 compiler and Ninja configured in CLion
- [JUCE 8][link_juce_download] installed locally *(not bundled)*
- CLion 2025
- Python 3.10+
- macOS 11+
- Windows 10+ / Linux *(not yet tested with this template)*

___
## Setup

1. Go to the `_cmake-config/` folder.
2. Duplicate `definePathExample.json` and rename it `definePath.json`.
   Here you can set your local JUCE, custom modules, and CLion paths for each platform.
3. Duplicate `companyInfoExample.cmake` and rename it `companyInfo.cmake`.
   Here you can set your company data.
4. Edit `appConfig.cmake` with the main settings before the first CMake configuration.
   Choose `GUI` or `AUDIO` and configure the project name, product name, version, description, and main options. For an AUDIO application, also configure the default input and output channels and the related microphone permission. MIDI device handling is not implemented yet, so its options must remain disabled.
5. In the project root folder, run the launcher for your platform:

   - Double-click `OpenProject_Mac.command` on macOS.
   - Double-click `OpenProject_Win.bat` on Windows.
   - Run `./OpenProject_Linux.sh` from a terminal on Linux.

6. Configure and build in CLion. CMake generates the source files required by the application type.
   On the first startup and when switching platforms, check the CMake profiles in CLion.
   Disable the generic `Debug` profile *(default CLion profile)* and enable the profiles for your platform:

   - `macos-debug`, `macos-release` on macOS;
   - `windows-debug`, `windows-release` on Windows;
   - `linux-debug`, `linux-release` on Linux.

> Both `definePath.json` and `companyInfo.cmake` are gitignored: they
> hold machine paths and company details and stay out of version control.
>
> These commands run the same `OpenInCLion.py` script. It reads the paths for your platform,
> updates `CMakePresets.json` when needed, and opens CLion.
>
> At present, these instructions have been verified on macOS only. Windows and Linux still require testing.

___
## Folder Layout

- **[_cmake-config][link_cmake-config] - main configuration folder:**
	- [*_scripts*][link_scripts]: path handling, validation and source-generation scripts;
	- [*modules-settings*][link_modules-settings]: JUCE, KinKout and custom module lists;
	- [*notarisation*][link_notarisation]: macOS hardened-runtime and entitlement settings;
	- [*platform-presets*][link_platform-presets]: platform-specific CMake presets used by CLion;
	- [*template*][link_template]: source templates generated according to the selected application profile.
- **[assets][link_assets] - application resources:**
	- *audio, data, fonts and images*.
- **[source][link_source] - generated application code and user source files:**
	- [assets-helper][link_assets-helper]: helpers for embedded or external resources;
	- [core][link_core]: shared constants, state and general utilities;
	- [dsp][link_dsp]: reusable audio-processing modules and category headers;
	- [engine][link_engine]: parameter, module ownership and DSP-chain management;
	- [ui][link_ui]: reusable graphical components, shared parts and visual style.

Both types generate `Main.cpp`, `MainWindow.h/.cpp` and `AppComponent.h/.cpp` directly in `source/`.
`Main` manages the application lifecycle; `MainWindow` owns `AppComponent`.
Both `AppComponent` implementations inherit from `juce::Component`. The GUI implementation provides the graphical application root. The AUDIO implementation owns `AudioAppProcessor`, `AudioProcessorPlayer` and `AudioDeviceManager`, connecting the processor to the system audio device.
`AudioAppProcessor` defines its input and output buses from `appConfig.cmake`. It owns the APVTS, the module rack and the engine. The example processing chain runs an oscillator followed by an output gain. Both controls are available through the generic editor.
A reusable graphical `MainComponent` is not included yet. MIDI device handling and parameter persistence also remain future work.

___
## Notes

This template keeps the original goal of using one project folder on different operating systems without maintaining separate copies or editing CMake presets by hand.

The launcher checks the operating system, selects the matching preset configuration, reads the local paths, and opens CLion. The source generator provides a consistent starting structure while leaving generated files untouched after they have been created. The application template is currently developed and tested on macOS; Windows and Linux compatibility remains to be tested.

The project is built with the JUCE CMake API, platform testing, trial and error, and AI-assisted development reviewed and adapted by the author.

`OpenInCLion.py` started as an AI-generated draft that I reviewed and reworked.

___
## Licence

This template’s own code — the CMake build system, the Python launcher, the structure — is MIT-licensed.
  See [LICENCE][link_mit_licence].

The main entry point templates in `_cmake-config/template/` derive from the JUCE examples [boilerplate][link_juce_boilerplate],
Copyright (c) Raw Material Software Limited, licensed under the [ISC Licence][link_isc_licence].

JUCE itself is not included here. Applications built with this template link against JUCE, which is dual-licensed under the [AGPLv3][link_agplv3_licence] and the commercial [JUCE licence][link_juce_licence].

Choosing a licence for an application created with this template remains the responsibility of that application's author.




[link_kk_dsp_template]: https://github.com/KinKout/KinKoutDSP-template
[link_juce_download]: https://juce.com/download
[link_juce_boilerplate]: https://github.com/juce-framework/JUCE/tree/master/examples/CMake/GuiApp
[link_mit_licence]: https://github.com/KinKout/KinKoutApp-template/tree/main/LICENSE
[link_isc_licence]: https://www.isc.org/licenses
[link_agplv3_licence]: https://www.gnu.org/licenses/agpl-3.0
[link_juce_licence]: https://juce.com/legal/


[link_companyInfo]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/companyInfoExample.cmake
[link_definePath]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/definePathExample.json
[link_appConfig]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/appConfig.cmake
[link_juceModules]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/modules-settings/juceModules.cmake


[link_cmake-config]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config
[link_scripts]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/_scripts
[link_modules-settings]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/modules-settings
[link_notarisation]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/notarisation
[link_platform-presets]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/platform-presets
[link_template]: https://github.com/KinKout/KinKoutApp-template/tree/main/_cmake-config/template
[link_assets]: https://github.com/KinKout/KinKoutApp-template/tree/main/assets
[link_source]: https://github.com/KinKout/KinKoutApp-template/tree/main/source
[link_assets-helper]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/assets-helper
[link_core]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/core
[link_engine]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/engine
[link_dsp]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/dsp
[link_ui]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/ui

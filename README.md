# KinKoutDSP-template
___

## What is it

A CMake starting point for JUCE audio plugins in the CLion IDE.

Born out of a simple need:
stop rebuilding the same build system from scratch for every plugin and keep the same project folder on a synced drive
  to build on machines with different operating systems.

- Edit one main configuration file for each new project:
    - [pluginConfig.cmake][link_pluginConfig] with your plugin data *(name, code, formats, categories, etc.)*
- Set up two configuration files when you first download the template:
    - [companyInfo.cmake][link_companyInfo] with your company data
    - [definePath.json][link_definePath] with your personal paths
- Modify [juceModules.cmake][link_juceModules] to add or remove modules if needed
- Run the launcher for your platform to open the project in CLion on macOS, Windows or Linux.

___
## What it does

- **One place to configure everything**
Company data, plugin name, code, formats, categories and module lists all live in the [_cmake-config][link_cmake-config] folder.
<br>

- **Validates before it builds**
Manufacturer/plugin codes are checked against the 4-character rule,
  formats and categories against the accepted lists, and the JUCE path against its local installation.
  Errors say what is wrong and how to fix it.
<br>

- **Generates the source files**
  There are two types of source code templates: ‘essential’ and ‘optional’.
  During the first CMake configuration, all source files are created from the .txt files
  in the [template][link_template] folder, using your plugin settings.

  The ‘essential’ source files are automatically recreated if missing.
  Once created, existing files are left untouched, so you can edit them like any other source code.
  Changes to the templates do not update source files that already exist.
  These include: `PluginProcessor`, `PluginEditor`, `Engine`, `InstRack`, `DspController`,
  `Parameters`, `_Dsp`, and `_Amplitude`.

  The ‘optional’ source files are created only during the first CMake configuration.
  After that, you can use or delete them, and they will not be regenerated unless you set
  `_OPTIONAL_SOURCE_LOADED` back to `FALSE` in `_cmake-config/_scripts/createSourceTemplate.cmake`.
  These optional source files include: `Gain`, a simple smoothed gain example.
  If you remove it, also remove its include, rack instance, controller calls and parameters.

- **Cross-platform without duplicating the project**
The launcher detects the OS, swaps in the matching CMake preset settings and opens CLion.
The same project folder can live on a synced drive and be used on machines with different operating systems.
<br>

- **Build summary**
Each CMake configuration ends with a report:
company info, plugin settings, paths, source files, assets, module status, etc.

___
## Minimum Requirements

- CMake 3.24+
- A C++17 compiler and Ninja configured in CLion
- [JUCE 8][link_juce_download] installed locally (not bundled)
- CLion 2025
- Python 3.10+
- macOS 11+ / Windows 10+ (tested on 11) / Linux (tested on Mint 22.1 Cinnamon)

___
## Setup

1. Go to the `_cmake-config/` folder.
2. Duplicate `definePathExample.json` and rename it `definePath.json`.
   Here you can set your local JUCE, custom modules, and CLion paths for each platform.
3. Duplicate `companyInfoExample.cmake` and rename it `companyInfo.cmake`.
   Here you can set your company data.
4. Edit `pluginConfig.cmake` with your plugin name, version, description, formats, categories, and other main settings before the first CMake configuration.
5. In the project root folder, run the launcher for your platform:

   - Double-click `OpenProject_Mac.command` on macOS.
   - Double-click `OpenProject_Win.bat` on Windows.
   - Run `./OpenProject_Linux.sh` from a terminal on Linux.

6. Configure and build in CLion. CMake generates the source files during configuration.
   On the first startup and when switching platforms, check the CMake profiles in CLion.
   Disable the generic `Debug` profile *(default CLion profile)* and enable the profiles for your platform:

   - `macos-debug`, `macos-release` on macOS.
   - `windows-debug`, `windows-release` on Windows.
   - `linux-debug`, `linux-release` on Linux.

> Both `definePath.json` and `companyInfo.cmake` are gitignored: they
> hold machine paths and company details and stay out of version control.
>
> These commands run the same `OpenInCLion.py` script. It reads the paths for your platform,
> updates `CMakePresets.json` when needed, and opens CLion.

___
## Folder Layout

- **[_cmake-config][link_cmake-config] - the main configuration folder, with files grouped by purpose:**
    - [*_scripts*][link_scripts]: contains the path and validation scripts, plus `createSourceTemplate.cmake` for source generation.
    - [*modules-settings*][link_modules-settings]: JUCE, KinKout and custom module lists that you can edit to match your plugin requirements.
      This folder also contains `_formatAndCategoryLists.cmake`, which lists the formats and categories accepted by the validation scripts.
    - [*notarisation*][link_notarisation]: macOS hardened runtime and entitlement settings for preparing a release.
    - [*platform-presets*][link_platform-presets]: the .json CMake presets for each platform, used by CLion to configure and build the project.
    - [*template*][link_template]: source .txt templates used during CMake configuration to generate the missing plugin source files.
- **[assets][link_assets] - for asset files divided into 4 categories:**
    - *audio, data, fonts and images*
- **[source][link_source] - for the generated plugin code and your own source files, divided into 5 subfolders:**
    - [assets-helper][link_assets-helper]: space for helper code that loads or provides access to audio, data, fonts and images from the assets folder.
    - [core][link_core]: space for shared constants, math functions and utilities, including code for communication between the audio and UI threads.
    - [dsp][link_dsp]: for audio processing modules, organised into 9 category folders:
        - *amplitude, analysis, distortion, dynamics, filters, generators, modulation, time and utility*
    - [engine][link_engine]: for managing the audio processing chain. CMake generates the following code here:
        - `InstRack` owns the DSP module instances,
        - `DspController` runs them,
        - `Engine` connects the chain to the processor,
        - `Parameters` defines the APVTS parameters and resolves their value pointers.
    - [ui][link_ui]: for the user interface code, divided into 3 subfolders:
        - *components, shared-parts and style.*
          <br>
            *(The components folder has further subfolders; see [source/ui/README.md][link_ui_readme] for more details.)*
        
___
## Notes

I moved to CLion, so I could build on both macOS and Windows.
  At first, I found more problems than solutions.
  The same project needs different CMake presets on each OS (paths, generator, build folder).
  I also keep my projects on a synced drive, so the same folder is open on both machines.
  Editing `CMakePresets.json` by hand every time was slow and easy to get wrong.
  Making two copies of the project meant I had to keep them in sync.

At the same time, I was tired of building the same setup again for every new plugin.
  So I put the two things together: a personal template with a launcher.
  The launcher checks the OS, writes the right preset, reads the paths for that platform, and opens CLion.
  One project folder, two machines, no manual preset switching.

Built with the JUCE CMake API docs, a lot of trial and error, and AI help.

`OpenInCLion.py` started as an AI-generated draft that I reviewed and reworked.

___
## License

This template’s own code — the CMake build system, the Python launcher, the structure — is MIT-licensed.
  See [LICENSE][link_mit_license].

The `PluginProcessor` / `PluginEditor` templates in `_cmake-config/template/` derive from the JUCE examples [boilerplate][link_juce_boilerplate],
Copyright (c) Raw Material Software Limited, licensed under the [ISC License][link_isc_license].

JUCE itself is not included here. Plugins built with this template link against JUCE, which is dual-licensed under
  the [AGPLv3][link_agplv3_license] and the commercial [JUCE license][link_juce_license].

Choosing a license for *your* plugin is up to you, and neither MIT nor ISC affects that choice.




[link_juce_download]: https://juce.com/download
[link_juce_boilerplate]: https://github.com/juce-framework/JUCE/tree/master/examples/CMake/AudioPlugin
[link_mit_license]: https://github.com/KinKout/KinKoutDSP-template/tree/main/LICENSE
[link_isc_license]: https://www.isc.org/licenses
[link_agplv3_license]: https://www.gnu.org/licenses/agpl-3.0
[link_juce_license]: https://juce.com/legal/


[link_pluginConfig]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/pluginConfig.cmake
[link_companyInfo]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/companyInfoExample.cmake
[link_definePath]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/definePathExample.json
[link_juceModules]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/modules-settings/juceModules.cmake


[link_cmake-config]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config
[link_scripts]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/_scripts
[link_modules-settings]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/modules-settings
[link_notarisation]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/notarisation
[link_platform-presets]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/platform-presets
[link_template]: https://github.com/KinKout/KinKoutDSP-template/tree/main/_cmake-config/template
[link_assets]: https://github.com/KinKout/KinKoutDSP-template/tree/main/assets
[link_source]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source
[link_assets-helper]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/assets-helper
[link_core]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/core
[link_engine]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/engine
[link_dsp]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/dsp
[link_ui]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui


[link_ui_readme]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui/README.md
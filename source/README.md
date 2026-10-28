# source folder
___
#### [This folder][link_source] contains all the source code of the plugin
___

CMake generates the source files here from the templates in `_cmake-config/template/`.
Existing files are left unchanged, so you can edit them to develop your plugin.
`PluginProcessor.h/cpp` and `PluginEditor.h/cpp` are generated directly in this folder.

It is divided into 5 subfolders:

- **assets-helper** - for helper code that loads or provides access to assets *(audio, data, fonts, images, etc.)*
- **core** - for shared constants, math functions and utilities, including code for communication between the audio and UI threads.
- **dsp** - for audio processing code divided into 9 subfolders
    - amplitude, analysis, distortion, dynamics, filters, generators, modulation, time, utility. *(See [dsp/README.md][link_dsp_readme].)*
    - `_Dsp.h` and the category umbrella headers collect the module includes. `Gain` is the optional example in the amplitude category.
- **engine** - for managing the audio processing chain. CMake generates these files here:
    - `InstRack.h/cpp` creates and owns the DSP module instances.
    - `DspController.h/cpp` connects parameters to the modules and runs the chain.
    - `Engine.h/cpp` connects the chain to the processor.
    - `Parameters.h/cpp` defines the APVTS parameter layout and resolves pointers to parameter values. `Parameters` is a namespace.
    <br>
    > Note: `PluginProcessor` owns the APVTS, `InstRack` and `Engine`.
- **ui** - for user interface code divided into 3 subfolders
    - components, shared-parts, style. *(See [ui/README.md][link_ui_readme].)*
    - These folders are reserved for the planned UI structure, which is not implemented yet.


> Note: `assets-helper`, `core` and `ui` currently contain only the folder structure, with no implementation code. The `State` class is not included in this version.




[link_source]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source
[link_dsp_readme]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/dsp/README.md
[link_ui_readme]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/ui/README.md
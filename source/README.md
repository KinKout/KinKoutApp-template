# source folder
___
#### [This folder][link_source] contains all the application source code
___

CMake generates the source files here from the templates in `_cmake-config/template/`.
Existing files are left unchanged, so you can edit them to develop your application.
`Main.cpp`, `MainWindow.h/cpp` and `AppComponent.h/cpp` are generated directly in this folder.
`Main` and `MainWindow` are shared by both application profiles. The `AppComponent` implementation
is selected before the first configuration: it inherits from `juce::Component` for `GUI`
or `juce::AudioAppComponent` for `AUDIO`.

It is divided into 5 subfolders:

- **assets-helper** - for helper code that loads or provides access to assets *(audio, data, fonts, images, etc.)*
- **core** - for shared constants, math functions and utilities, including code for communication between the audio and UI threads.
- **dsp** - for reusable audio processing code used by the `AUDIO` profile, divided into 9 subfolders
	- amplitude, analysis, distortion, dynamics, filters, generators, modulation, time, utility. *(See [dsp/README.md][link_dsp_readme].)*
- **engine** - reserved for audio-engine and processing-chain code used by the `AUDIO` profile.
  Integration with the processing structure of KinKoutDSP-template is planned; no engine source files are generated yet.
- **ui** - for reusable user interface code divided into 3 subfolders
	- components, shared-parts, style. *(See [ui/README.md][link_ui_readme].)*
	- These folders are reserved for the planned UI structure. `MainComponent` will compose the graphical interface and will be hosted by `AppComponent`.


> Note: generated source files are intentionally absent from a fresh copy of the template and are created during the first CMake configuration.
> The subfolders provide the starting organisation for application code; the reusable UI and DSP integration are not implemented yet.




[link_source]: https://github.com/KinKout/KinKoutApp-template/tree/main/source
[link_dsp_readme]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/dsp/README.md
[link_ui_readme]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/ui/README.md

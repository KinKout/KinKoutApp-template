# source folder
___
#### [This folder][link_source] contains all the application source code
___

CMake generates all source files for the selected profile here from the templates in
`_cmake-config/template/` during the first configuration. Existing files are left unchanged,
so you can edit them to develop your application.
`Main.cpp`, `MainWindow.h/cpp` and `AppComponent.h/cpp` are generated directly in this folder.
`Main` and `MainWindow` are shared by both application profiles. The `AppComponent` implementation
is selected before the first configuration. Both implementations inherit from `juce::Component`:
the GUI version provides the graphical application root, while the AUDIO version owns the generated
`AudioAppProcessor` and connects it to the system audio device through `AudioProcessorPlayer`.
The AUDIO profile also generates the parameter, engine and DSP files used by its example chain.
The audio buses use the default input and output channel values configured in `appConfig.cmake`.

It is divided into 5 subfolders:

- **assets-helper** - for helper code that loads or provides access to assets *(audio, data, fonts, images, etc.)*
- **core** - for shared constants, math functions and utilities, including code for communication between the audio and UI threads.
- **dsp** - for reusable audio-processing code used by the `AUDIO` profile, divided into 9 subfolders
	- amplitude, analysis, distortion, dynamics, filters, generators, modulation, time, utility. *(See [dsp/README.md][link_dsp_readme].)*
	- `_Dsp.h` and the category umbrella headers collect the module includes. `Gain` and `Oscillator` are the optional examples.
- **engine** - for audio-engine and processing-chain code used by the `AUDIO` profile.
	- `Parameters` defines the APVTS layout and resolves its value pointers.
	- `InstRack` owns the generated DSP modules.
	- `DspController` defines their processing order.
	- `Engine` connects the chain to `AudioAppProcessor`.
- **ui** - for reusable user interface code divided into 3 subfolders
	- components, shared-parts, style. *(See [ui/README.md][link_ui_readme].)*
	- These folders are reserved for the custom UI structure. `MainComponent` will compose the graphical interface and will be hosted by `AppComponent`.


> Note: generated source files are intentionally absent from a fresh copy of the template. CMake creates all files required by the selected profile during the first configuration.
> The optional `Gain` and `Oscillator` files are not recreated after the first configuration. Set `_OPTIONAL_SOURCE_LOADED` back to `FALSE` in `_cmake-config/_scripts/createSourceTemplate.cmake` if you need to generate them again.
> The custom UI is not implemented yet. The AUDIO profile uses the generic editor until `MainComponent` and its controls are available.




[link_source]: https://github.com/KinKout/KinKoutApp-template/tree/main/source
[link_dsp_readme]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/dsp/README.md
[link_ui_readme]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/ui/README.md

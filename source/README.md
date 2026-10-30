# source folder
___
#### [This folder][link_source] contains all the application source code
___

CMake generates the source files here from the templates in `_cmake-config/template/`.
Existing files are left unchanged, so you can edit them to develop your application.
The exact files depend on the application profile selected before the first configuration.

It is divided into 5 subfolders:

- **assets-helper** - for helper code that loads or provides access to assets *(audio, data, fonts, images, etc.)*
- **core** - for shared constants, math functions and utilities, including code for communication between the audio and UI threads.
- **dsp** - for reusable audio processing code used by the `AUDIO` profile, divided into 9 subfolders
	- amplitude, analysis, distortion, dynamics, filters, generators, modulation, time, utility. *(See [dsp/README.md][link_dsp_readme].)*
- **engine** - reserved for audio-engine and processing-chain code used by the `AUDIO` profile.
  Its source templates will be introduced with the audio-profile milestone.
- **ui** - for `MainWindow`, `MainComponent` and other interface code divided into 3 subfolders
	- components, shared-parts, style. *(See [ui/README.md][link_ui_readme].)*
	- The root window and component are generated for graphical application profiles.


> Note: generated source files are intentionally absent from a fresh copy of the template and are created during the first CMake configuration.




[link_source]: https://github.com/KinKout/KinKoutApp-template/tree/main/source
[link_dsp_readme]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/dsp/README.md
[link_ui_readme]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/ui/README.md

# ui folder
___
#### This folder is for the user interface code.
___

[This folder][link_ui] is reserved for the custom user interface. `MainComponent.h/cpp` will be its
root component. `AppComponent` will host it in both GUI and AUDIO applications. This follows the
same graphical organisation used by KinKoutDSP-template, where `PluginEditor` hosts `MainComponent`.

Only the folder structure is present in this version. No custom UI files are included yet.
The AUDIO profile currently uses `GenericAudioProcessorEditor`, owned directly by `AppComponent`.
This editor exposes the APVTS parameters until `MainComponent` and its controls are implemented.
`MainWindow` and the profile-specific `AppComponent` are placed directly in `source/`.
The components below show the planned organisation.
___

It is divided into 3 subfolders:

- **components** - *for UI elements made from several parts, such as knobs, buttons and meters.*
	*For example, the [source/ui/components/knob][link_knob] folder is intended for `KnobComponent.h/cpp`.
	  `MainComponent` would access the knob through `KnobComponent`, while its internal parts would go in
	  `source/ui/components/knob/internal` (e.g. `KnobBody.h`, `KnobLookAndFeel.h`, `KnobShadow.h`).*

- **shared-parts** - *for shared components like labels, shadows, ticks, etc.*
- **style** - *for the global look and feel and other visual settings of the application UI*



[link_ui]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/ui
[link_knob]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/ui/components/knob

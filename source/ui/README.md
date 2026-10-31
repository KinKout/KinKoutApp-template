# ui folder
___
#### This folder is for the user interface code.
___

*[This folder][link_ui] is planned to contain `MainComponent.h/cpp` as the root component for the reusable UI.
  `AppComponent` will host it in both GUI and AUDIO applications, following the same graphical
  organisation planned for KinKoutDSP-template, where it will be hosted by `PluginEditor`.*

Only the folder structure is present in this version. No UI implementation files are generated here yet.
`MainWindow` and the profile-specific `AppComponent` are generated directly in `source/`.
The components described below are examples of the planned organisation.
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

# dsp folder
___
#### This folder is for reusable audio processing modules.
___

*CMake generates `_Dsp.h` in [this folder][link_dsp]. It is included by `InstRack.cpp` and `DspController.cpp`
  to make the DSP module definitions available through the category headers.*

*Each DSP category uses an umbrella header named `_CategoryName.h` in its own folder.
  This header includes the module headers for that category. `_Amplitude.h` is the generated example;
  create the other category headers when you need them.*

To add a module, include its header in the category umbrella header and enable that category include in `_Dsp.h`.
Then create an instance in `InstRack` and connect it in `DspController`. An include alone does not add audio processing.
___

It is divided into 9 category folders for the following types of modules. These are examples of what belongs
in each category; only the optional `Gain` example is provided by the templates.

- **amplitude** - *amplitudes and their ratios:*
    - gain
    - pan
    - balance
    - stereo width
    - mono
    - polarity
    - dry/wet
    - crossfade
- **analysis** - *measurements without changing the audio signal:*
    - FFT
    - RMS/peak
    - pitch detection
- **distortion** - *non-linear effects:*
    - waveshaper
    - saturation
    - clipping
    - bitcrusher
- **dynamics** - *gain control and detection:*
    - compressor
    - limiter
    - gate
    - expander
    - envelope follower
- **filters** - *frequency shaping:*
    - biquad
    - SVF
    - EQ
    - crossover
- **generators** - *signal generation:*
    - oscillators
    - noise
- **modulation** - *control signals:*
    - LFO
    - modulation envelope
    - modulation matrices
- **time** - *time-domain effects:*
    - delay
    - reverb
    - chorus
    - flanger
    - phaser
    - pitch-shifter
- **utility** - *general DSP utilities:*
    - envelope follower
    - smoothers
    - interpolators
    - oversampling
    - dithering




[link_dsp]: https://github.com/KinKout/KinKoutDSP-template/tree/main/source/dsp
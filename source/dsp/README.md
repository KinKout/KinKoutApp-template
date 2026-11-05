# dsp folder
___
#### This folder is for reusable audio processing modules.
___

The `AUDIO` profile generates its reusable DSP source files in [this folder][link_dsp] during the
first CMake configuration. `Gain` and `Oscillator` are optional example modules. After the first
configuration, you can use or delete them and they will not be generated again. Set
`_OPTIONAL_SOURCE_LOADED` back to `FALSE` in `_cmake-config/_scripts/createSourceTemplate.cmake`
if you need to generate them again.

The category folders contain the generated example modules and provide space for user DSP modules.
If you remove an example module, also remove its include, rack instance, controller calls and parameters.
___

It is divided into 9 category folders for the following types of modules. The current template
provides Gain in the amplitude category and Oscillator in the generators category. The other entries
are examples of modules that can be added later.

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




[link_dsp]: https://github.com/KinKout/KinKoutApp-template/tree/main/source/dsp

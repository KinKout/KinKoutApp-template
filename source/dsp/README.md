# dsp folder
___
#### This folder is for reusable audio processing modules.
___

*The `AUDIO` profile is still under development. Its test oscillator is currently implemented directly in `AudioAppProcessor`; CMake does not generate reusable DSP source files in [this folder][link_dsp].*

*The category folders are reserved for the future audio application structure and for user DSP modules.*
___

It is divided into 9 category folders for the following types of modules. These are examples of what belongs
in each category; no reusable DSP module is currently provided by the templates.

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

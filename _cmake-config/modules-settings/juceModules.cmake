# ================================================================================
# JUCE Modules Configuration
# ================================================================================
#
# File:				juceModules.cmake
# Author:			KinKout
# Date:				28-Oct-2026
#
# Purpose:		manage Juce modules.
#
# ================================================================================
#
# This file contains the complete list of JUCE modules available to the application.
# Set a module to AUTO, TRUE, or FALSE to control whether it is linked.
#
# AUTO  -> select the module according to the application type.
# TRUE  -> always select the module.
# FALSE -> never select the module directly.
#
# A disabled module may still be linked as a dependency of another JUCE module.
#
# ================================================================================
#
# Do not include CUSTOM or third-party modules here.
# Do not include KinKout modules here.
#
# See customModules.cmake for custom module configuration.
# See kkModulesLib.cmake for KinKout module configuration.
#
# ================================================================================


# -------------------------------------------------------------------------------- Core audio modules
set(JUCE_CORE_AUDIO_MODULES_LIST
	"juce_audio_basics:AUTO"		# AudioBuffer, sample management, basic MIDI helpers
	"juce_audio_devices:AUTO"		# Audio I/O: input/output devices, driver management
	"juce_audio_formats:AUTO"		# Audio file support: WAV, AIFF, FLAC, MP3
	"juce_audio_plugin_client:FALSE"		# Plugin client support: VST3, AU, AAX, host integration
	"juce_audio_processors:AUTO"		# Core plugin processing: parameters, buses, automations, processBlock
	"juce_audio_utils:AUTO"		# Audio playback, MIDI helpers, file player utilities
)


# -------------------------------------------------------------------------------- Core system modules
set(JUCE_CORE_SYSTEM_MODULES_LIST
	"juce_core:AUTO"		# Core utilities: strings, containers, threads, timers, file system
	"juce_data_structures:AUTO"		# PropertyTree, JSON/XML parsing, advanced data structures
	"juce_events:AUTO"		# Event handling, callbacks, listeners
)


# -------------------------------------------------------------------------------- DSP modules
set(JUCE_DSP_MODULES_LIST
	"juce_dsp:FALSE"		# DSP classes: filters, LFOs, FFT, delay lines, modulation
)


# -------------------------------------------------------------------------------- GUI modules
set(JUCE_GUI_MODULES_LIST
	"juce_graphics:AUTO"		# 2D graphics: paths, gradients, images, bitmap rendering
	"juce_gui_basics:AUTO"		# Basic GUI components: windows, buttons, sliders, labels, panels
	"juce_gui_extra:AUTO"		# Advanced GUI components: treeview, listbox, tabbedComponent, drag/drop
)


# -------------------------------------------------------------------------------- Optional JUCE modules
set(JUCE_OPTIONAL_MODULES_LIST
	"juce_analytics:FALSE"		# Telemetry and usage analytics
	"juce_animation:FALSE"		# GUI animation utilities, tweening, interpolations
	"juce_box2d:FALSE"		# Physics engine wrapper for 2D simulations (Box2D)
	"juce_cryptography:FALSE"		# Cryptography: hashing, encryption, digital signatures
	"juce_javascript:FALSE"		# Embedded JavaScript interpreter
	"juce_opengl:FALSE"		# OpenGL rendering in GUI components
	"juce_osc:FALSE"		# Open Sound Control (OSC) support for networking and device control
	"juce_product_unlocking:FALSE"		# License management and product unlocking
	"juce_video:FALSE"		# Video playback and capture support
	"juce_midi_ci:FALSE"		# MIDI Capability Inquiry support
)


# -------------------------------------------------------------------------------- Resolve module selection
include(_cmake-config/_scripts/juceModulesManager.cmake)
# ================================================================================
# Application Configuration
# ================================================================================
#
# File:				appConfig.cmake
# Author:			KinKout
# Date:				28-Oct-2026
#
# Purpose:		manage application data
#
# ================================================================================
#
# This file contains the application-specific metadata and main feature options
# used by the build system. Configure it before the first CMake generation.
#
# The application type is a project-creation choice. Do not change it after the
# source files have been generated.
#
# ================================================================================


# -------------------------------------------------------------------------------- Application type
# use one of the application types below to setup _APP_TYPE variable:
# Implemented: GUI
# Implemented: AUDIO
# Future: CONSOLE
set(_APP_TYPE "AUDIO")
string(TOUPPER "${_APP_TYPE}" _APP_TYPE)

# -------------------------------------------------------------------------------- Info
set(_PROJECT_NAME "MyNewApp") # !!! NO whitespace !!! - max 30 characters
set(_PRODUCT_NAME "My New App") # Name displayed by the operating system - max 30 characters
set(_DESCRIPTION "Something magna with elit something, officia something lorem ipsum with dolor and laboris commodo.") # max 255 characters
set(_VERSION 1.0.0)

# -------------------------------------------------------------------------------- Bundle ID
# created from company name and application name
# you can rename it as your need, eg. "com.mycompany.myapp" lowercase
set(_BUNDLE_ID "com.${_COMPANY_NAME}.${_PRODUCT_NAME}")
string(REPLACE " " "" _BUNDLE_ID "${_BUNDLE_ID}")
string(TOLOWER "${_BUNDLE_ID}" _BUNDLE_ID)

# -------------------------------------------------------------------------------- Application behaviour
set(_ALLOW_MULTIPLE_INSTANCES TRUE)

# -------------------------------------------------------------------------------- Optional capabilities
set(_NEEDS_WEB_BROWSER FALSE)		# Disable web browser module
set(_NEEDS_CURL FALSE)		# Disable CURL support

# -------------------------------------------------------------------------------- Audio settings
set(_DEFAULT_AUDIO_INPUT_CHANNELS 0)
set(_DEFAULT_AUDIO_OUTPUT_CHANNELS 2)
# Enable microphone permission when the application uses audio input channels.
set(_MICROPHONE_PERMISSION_ENABLED FALSE)
set(_MICROPHONE_PERMISSION_TEXT "This application requires access to the microphone.")

# -------------------------------------------------------------------------------- MIDI settings
# MIDI device handling is not implemented yet. Keep both options set to FALSE.
set(_WANTS_MIDI_INPUT FALSE)
set(_PRODUCES_MIDI_OUTPUT FALSE)

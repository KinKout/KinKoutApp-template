# ================================================================================
# User configuration control
# ================================================================================
#
# File:				userConfigControl.cmake
# Author:			KinKout
# Date:				29-Oct-2026
#
# Purpose:		Normalise and validate user-defined configuration values,
#					including application metadata, boolean options,
#					and default audio channel counts.
#					visit https://regex101.com/ for testing regular expressions
#
# ================================================================================

set(_PROJECT_REGEX "^[A-Za-z0-9_.+-]+$")
set(_PRODUCT_REGEX "^[^/\\\"*:|<>?]+$")
set(_VERSION_REGEX "^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$")
set(_BUNDLE_ID_REGEX "^[a-z0-9.-]+$")
set(_NAME_LENGTH 30)
set(_DESCRIPTION_LENGTH 255)

# -------------------------------------------------------------------------------- Check RegEx
function(check_name_regex _VAR_NAME _STRING _REGEX)

	string(REGEX MATCH ${_REGEX} _MATCHED ${_STRING})

	if(NOT _MATCHED)
		build_failure_msg()
		message(FATAL_ERROR
			"- Invalid character in \"${_VAR_NAME}\" -> \"${_STRING}\"\n"
			"- RegEx character allowed -> ${_REGEX}\n"
			"- You can test the name at https://regex101.com/\n"
			"- Check the variable in \"_cmake-config/appConfig.cmake\" file\n")
	endif()
endfunction()

# -------------------------------------------------------------------------------- Check Length
function(check_name_length _VAR_NAME _STRING _MAX_LENGTH )

	string(LENGTH ${_STRING} _N_CHAR)

	if(_N_CHAR GREATER _MAX_LENGTH)
		build_failure_msg()
		message(FATAL_ERROR
				"- \"${_N_CHAR}\" characters in \"${_VAR_NAME}\" -> \"${_STRING}\"\n"
				"- max length -> ${_MAX_LENGTH}\n"
				"- Check the variable in \"_cmake-config/appConfig.cmake\" file\n")
	endif()
endfunction()

# -------------------------------------------------------------------------------- Check number of audio channels
function(check_num_channels _VAR_NAME _VALUE _CONFIG_FILE)

	if(NOT "${_VALUE}" MATCHES "^[0-9]+$")
		build_failure_msg()
		message(FATAL_ERROR
				"- Invalid channel value in \"${_VAR_NAME}\" -> \"${_VALUE}\"\n"
				"- Allowed values -> non negative integers\n"
				"- Check the variable in \"${_CONFIG_FILE}\" file\n")
	endif()
endfunction()

# -------------------------------------------------------------------------------- Check Boolean
function(check_boolean _VAR_NAME _VALUE _CONFIG_FILE)

	string(TOUPPER "${_VALUE}" _BOOL_VALUE)

	if(NOT _BOOL_VALUE STREQUAL "TRUE" AND NOT _BOOL_VALUE STREQUAL "FALSE")
		build_failure_msg()
		message(FATAL_ERROR
			"- Invalid boolean value in \"${_VAR_NAME}\" -> \"${_VALUE}\"\n"
			"- Allowed values -> TRUE or FALSE\n"
			"- Check the variable in \"${_CONFIG_FILE}\" file\n")
	endif()
endfunction()

# -------------------------------------------------------------------------------- Strip and check empty string
function(strip_name _OUTPUT_STRING _STRING)

	foreach(i RANGE 1)

		if(_STRING STREQUAL "")
			build_failure_msg()
			message(FATAL_ERROR
				"- No characters in \"${_OUTPUT_STRING}\"\n"
				"- Check the variable in \"_cmake-config/appConfig.cmake\" file\n")
		endif()

		if(i EQUAL 0)
			string(STRIP ${_STRING} _STRING)
		endif()

	endforeach()
	set(${_OUTPUT_STRING} ${_STRING} PARENT_SCOPE)
endfunction()

# -------------------------------------------------------------------------------- Check _PROJECT_NAME:
# -------------------------------------------------------------------------------- max 30 characters
strip_name(_PROJECT_NAME ${_PROJECT_NAME})

check_name_length(_PROJECT_NAME ${_PROJECT_NAME} ${_NAME_LENGTH})

check_name_regex(_PROJECT_NAME ${_PROJECT_NAME} ${_PROJECT_REGEX})

# -------------------------------------------------------------------------------- Check _PRODUCT_NAME:
# -------------------------------------------------------------------------------- max 30 characters
strip_name(_PRODUCT_NAME ${_PRODUCT_NAME})

check_name_length(_PRODUCT_NAME ${_PRODUCT_NAME} ${_NAME_LENGTH})

check_name_regex(_PRODUCT_NAME ${_PRODUCT_NAME} ${_PRODUCT_REGEX})

# -------------------------------------------------------------------------------- Check _DESCRIPTION:
# -------------------------------------------------------------------------------- max 255 characters
string(STRIP ${_DESCRIPTION} _DESCRIPTION)

check_name_length(_DESCRIPTION ${_DESCRIPTION} ${_DESCRIPTION_LENGTH})

# -------------------------------------------------------------------------------- Check _VERSION:
check_name_regex(_VERSION ${_VERSION} ${_VERSION_REGEX})

# -------------------------------------------------------------------------------- Check _BUNDLE_ID:
check_name_regex(_BUNDLE_ID ${_BUNDLE_ID} ${_BUNDLE_ID_REGEX})

# -------------------------------------------------------------------------------- Check Boolean options:
check_boolean(_ALLOW_MULTIPLE_INSTANCES "${_ALLOW_MULTIPLE_INSTANCES}" "_cmake-config/appConfig.cmake")
check_boolean(_NEEDS_WEB_BROWSER "${_NEEDS_WEB_BROWSER}" "_cmake-config/appConfig.cmake")
check_boolean(_NEEDS_CURL "${_NEEDS_CURL}" "_cmake-config/appConfig.cmake")
check_boolean(_MICROPHONE_PERMISSION_ENABLED "${_MICROPHONE_PERMISSION_ENABLED}" "_cmake-config/appConfig.cmake")
check_boolean(_WANTS_MIDI_INPUT "${_WANTS_MIDI_INPUT}" "_cmake-config/appConfig.cmake")
check_boolean(_PRODUCES_MIDI_OUTPUT "${_PRODUCES_MIDI_OUTPUT}" "_cmake-config/appConfig.cmake")
check_boolean(_HARDENED_RUNTIME_ENABLED "${_HARDENED_RUNTIME_ENABLED}" "_cmake-config/notarisation/notarisation.cmake")

# -------------------------------------------------------------------------------- Check number of audio channels:

check_num_channels(_DEFAULT_AUDIO_INPUT_CHANNELS "${_DEFAULT_AUDIO_INPUT_CHANNELS}" "_cmake-config/appConfig.cmake")
check_num_channels(_DEFAULT_AUDIO_OUTPUT_CHANNELS "${_DEFAULT_AUDIO_OUTPUT_CHANNELS}" "_cmake-config/appConfig.cmake")

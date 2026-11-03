# ================================================================================
# JUCE Modules Manager
# ================================================================================
#
# File:				juceModulesManager.cmake
# Author:			KinKout
# Date:				28-Oct-2026
#
# Purpose:		resolve the JUCE module selection for the chosen application type.
#
# ================================================================================
#
# This file converts the module/state pairs declared in juceModules.cmake into the
# JUCE target lists consumed by the main CMakeLists.txt file.
#
# ================================================================================


string(TOUPPER "${_APP_TYPE}" _TYPE)
if(NOT _TYPE STREQUAL "GUI" AND NOT _TYPE STREQUAL "AUDIO")
	message(FATAL_ERROR "Invalid _APP_TYPE '${_APP_TYPE}'. Expected GUI or AUDIO")
endif()

set(_VALID_STATES AUTO TRUE FALSE)

# -------------------------------------------------------------------------------- Auto modules
set(_AUTO_GROUPS CORE_SYSTEM GUI)				# default modules group for GUI and AUDIO applications
if(_TYPE STREQUAL "AUDIO")
	list(APPEND _AUTO_GROUPS CORE_AUDIO DSP)	# specific modules group for AUDIO applications
endif()

foreach(_GROUP IN ITEMS CORE_AUDIO CORE_SYSTEM DSP GUI OPTIONAL)
	set(_INPUT "JUCE_${_GROUP}_MODULES_LIST")
	set(_OUTPUT "JUCE_${_GROUP}_MODULES")

	if(NOT DEFINED ${_INPUT})
		message(FATAL_ERROR "Missing module list: ${_INPUT}")
	endif()

	set(${_OUTPUT})

	foreach(_ENTRY IN LISTS ${_INPUT})
		string(REPLACE ":" ";" _FIELDS "${_ENTRY}")
		list(LENGTH _FIELDS _COUNT)
		if(NOT _COUNT EQUAL 2)
			message(FATAL_ERROR "Invalid entry '${_ENTRY}' in ${_INPUT}. Expected module:state")
		endif()

		list(GET _FIELDS 0 _MODULE)
		list(GET _FIELDS 1 _STATE)
		string(TOUPPER "${_STATE}" _STATE)

		if(NOT _STATE IN_LIST _VALID_STATES)
			message(FATAL_ERROR "Invalid state '${_STATE}' for '${_MODULE}'")
		endif()

		if(_STATE STREQUAL "TRUE" OR (_STATE STREQUAL "AUTO" AND _GROUP IN_LIST _AUTO_GROUPS))
			list(APPEND ${_OUTPUT} "juce::${_MODULE}")
		endif()
	endforeach()
endforeach()

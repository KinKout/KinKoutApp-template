# =============================================================================
# CMakeLists project builder
# =============================================================================
#
# File:				CMakeLists.txt
# Author:			KinKout
# Date:				28-Oct-2026
#
# Purpose:		build JUCE desktop applications for the CLion IDE.
#
# =============================================================================


cmake_minimum_required(VERSION 3.24)
set(_THIS_DIR ${CMAKE_CURRENT_SOURCE_DIR})

message("\n"
		"| =========================================================================== |\n"
		"|                                START BUILDING                               |\n"
		"| =========================================================================== |\n\n")

# -------------------------------------------------------------------------------- Includes
include(_cmake-config/companyInfo.cmake)
include(_cmake-config/appConfig.cmake)
include(_cmake-config/modules-settings/juceModules.cmake)
include(_cmake-config/_scripts/juceModulesManager.cmake)
include(_cmake-config/modules-settings/kkModulesLib.cmake)
include(_cmake-config/modules-settings/customModules.cmake)
include(_cmake-config/_scripts/pathConfig.cmake)
include(_cmake-config/notarisation/notarisation.cmake)

message(STATUS "Include files loaded\n")


# ================================================================================
# BUILD FAILURE MESSAGE
# ================================================================================

function(build_failure_msg)
	message("\n\n\n"
			"| =========================================================================== |\n"
			"|                                 BUILD FAILURE                               |\n"
			"| =========================================================================== |\n\n")
endfunction()


# ================================================================================
# PLATFORM DETECTION AND SETUP
# ================================================================================

if(APPLE)
	set(_SYSTEM_NAME "APPLE")
	set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "")
	set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "")
	set(_BUILD_PATH "${_THIS_DIR}/builds/macos")
elseif(WIN32)
	set(_SYSTEM_NAME "WIN32")
	set(_BUILD_PATH "${_THIS_DIR}/builds/windows")
elseif(UNIX AND NOT APPLE)
	set(_SYSTEM_NAME "LINUX")
	set(_BUILD_PATH "${_THIS_DIR}/builds/linux")
else()
	build_failure_msg()
	message(FATAL_ERROR "Unsupported platform!")
endif()

message(STATUS "Platform detected: ${_SYSTEM_NAME}\n")


# ================================================================================
# APPLICATION CONFIGURATION VALIDATION
# ================================================================================

include(_cmake-config/_scripts/userConfigControl.cmake)

message(STATUS
		"Building:\n"
		"\t-> Project name: ${_PROJECT_NAME}\n"
		"\t-> Product name: ${_PRODUCT_NAME}\n"
		"\t-> Application type: ${_APP_TYPE}\n"
		"\t-> Version: ${_VERSION}\n")


# ================================================================================
# PROJECT CONFIGURATION
# ================================================================================

project(
		${_PROJECT_NAME}
		VERSION ${_VERSION}
		DESCRIPTION ${_DESCRIPTION}
		LANGUAGES C CXX
)

# -------------------------------------------------------------------------------- Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# -------------------------------------------------------------------------------- Disable automatic Xcode scheme generation
# -------------------------------------------------------------------------------- not needed in CLion
set(CMAKE_XCODE_GENERATE_SCHEME FALSE)

# -------------------------------------------------------------------------------- Allow CLion and IDEs to organize targets in folders
set_property(GLOBAL PROPERTY USE_FOLDERS TRUE)

# -------------------------------------------------------------------------------- Platform build directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${_BUILD_PATH}/debug")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG   "${_BUILD_PATH}/debug")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG   "${_BUILD_PATH}/debug")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${_BUILD_PATH}/release")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${_BUILD_PATH}/release")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${_BUILD_PATH}/release")


# ================================================================================
# INCLUDE JUCE, MODULES, BINARY DATA AND SOURCE FILES
# ================================================================================

message(STATUS "Check and adding modules...\n")

# INCLUDE JUCE
# -------------------------------------------------------------------------------- Check & add JUCE
if(NOT DEFINED _JUCE_PATH OR _JUCE_PATH STREQUAL "")
	build_failure_msg()
	message(FATAL_ERROR "JUCE folder not defined!")
elseif(NOT EXISTS "${_JUCE_PATH}")
	build_failure_msg()
	message(FATAL_ERROR "JUCE not found at ${_JUCE_PATH}!")
elseif(NOT EXISTS "${_JUCE_PATH}/CMakeLists.txt")
	build_failure_msg()
	message(FATAL_ERROR "CMakeLists.txt not found in JUCE folder! Install JUCE...")
else()
	add_subdirectory(${_JUCE_PATH} juce EXCLUDE_FROM_ALL)
	message("")
	message(STATUS "✓ JUCE added to ${_PRODUCT_NAME}!\n")
endif()

# INCLUDE KINKOUT Modules (KKModulesLib)
# -------------------------------------------------------------------------------- Check & add KKModulesLib
if(NOT DEFINED _KKML_PATH OR _KKML_PATH STREQUAL "")
	message(WARNING "No KKModulesLib path defined, skipping.")
elseif(NOT EXISTS "${_KKML_PATH}")
	build_failure_msg()
	message(FATAL_ERROR "KKModulesLib not found at ${_KKML_PATH}!")
else()
	if(NOT DEFINED _KKML OR _KKML STREQUAL "")
		message(WARNING "No KKModulesLib modules defined, skipping.")
	else()
		foreach(_KK ${_KKML})
			string(REPLACE "${_KK_NAMESPACE}" "" _KK_MODULE_NAME ${_KK})
			set(_KK_MODULE_PATH "${_KKML_PATH}/${_KK_MODULE_NAME}")
			if(NOT EXISTS "${_KK_MODULE_PATH}")
				build_failure_msg()
				message(FATAL_ERROR "KKModulesLib module '${_KK_MODULE_NAME}' not found at ${_KK_MODULE_PATH}!")
			else()
				add_subdirectory(${_KK_MODULE_PATH})
				message(STATUS "    >>> ${_KK_MODULE_NAME} added to ${_PRODUCT_NAME}!\n")
			endif()
		endforeach()
	endif()
endif()

# INCLUDE CUSTOM Modules
# -------------------------------------------------------------------------------- Check & add Custom modules
if(NOT DEFINED _CSTM_PATH OR _CSTM_PATH STREQUAL "")
	message(WARNING "No Custom Modules path defined, skipping.")
elseif(NOT EXISTS "${_CSTM_PATH}")
	build_failure_msg()
	message(FATAL_ERROR "Custom Modules not found at ${_CSTM_PATH}!")
else()
	if(NOT DEFINED _CSTM OR _CSTM STREQUAL "")
		message(WARNING "No Custom Modules modules defined, skipping.")
	else()
		foreach(_CM_NAME ${_CSTM})
			set(_CUSTOM_MODULE_PATH "${_CSTM_PATH}/${_CM_NAME}")
			if(NOT EXISTS "${_CUSTOM_MODULE_PATH}")
				build_failure_msg()
				message(FATAL_ERROR "Custom Modules module '${_CM_NAME}' not found at ${_CUSTOM_MODULE_PATH}!")
			else()
				add_subdirectory(${_CUSTOM_MODULE_PATH})
				message(STATUS "    >>> ${_CM_NAME} added to ${_PRODUCT_NAME}!\n")
			endif()
		endforeach()
	endif()
endif()


# INCLUDE BINARY DATA (assets folder)
# ---------------------------------------------------------- Check & add binary files
message(STATUS "Check and adding binary files...")

set(_A "assets")
set(_ASSETS_PATH "${_THIS_DIR}/${_A}")

# Add here the new asset formats supported by the project
# Remember to add only the BINARY formats in .gitattributes to avoid corruption
file(GLOB_RECURSE _BINARY_FILES CONFIGURE_DEPENDS
		# ------------------ BINARY files
		# Image files
		"${_A}/*.png"
		"${_A}/*.jpg"

		# Font files
		"${_A}/*.ttf"
		"${_A}/*.otf"

		# Audio files
		"${_A}/*.wav"
		"${_A}/*.aiff"

		# ------------------ TEXT files
		"${_A}/*.svg"
		"${_A}/*.json"
		"${_A}/*.xml"
)

list(LENGTH _BINARY_FILES _BINARY_COUNT)
if(_BINARY_COUNT GREATER 0)
	set(_BINARY_LIST ${_PROJECT_NAME}_BinaryData)
	juce_add_binary_data(${_BINARY_LIST} SOURCES ${_BINARY_FILES})
	message("\t\t    >>> BinaryData: ${_BINARY_COUNT} assets loaded\n")
else()
	message(WARNING "No BinaryData found, skipping.")
endif()


# INCLUDE SOURCE FILES
# -------------------------------------------------------------------------------- Check & add source files
message(STATUS "Check template source files...")

include(_cmake-config/_scripts/createSourceTemplate.cmake)

message(STATUS "Scan \"source\" folder to find user source files...")

set(_S "source")
file(GLOB_RECURSE _SOURCE_FILES
		"${_S}/*.cpp"
		"${_S}/*.h"
)

list(SORT _SOURCE_FILES)
foreach(_SF ${_SOURCE_FILES})
	file(RELATIVE_PATH _REL_PATH ${_THIS_DIR} ${_SF})
	message("\t-> ${_REL_PATH}")
endforeach()

list(LENGTH _SOURCE_FILES _SOURCE_COUNT)
math(EXPR _N_USER_SOURCE "${_SOURCE_COUNT} - ${_N_TEMPLATE_LOADED}")

message("\n\t>>> source files: ${_N_TEMPLATE_LOADED} template files loaded")
message("\t                  ${_N_USER_SOURCE} user files loaded\n")
message("\t>>> tot. source files: ${_SOURCE_COUNT} files loaded\n")


# ================================================================================
# APPLICATION CONFIGURATION
# ================================================================================

juce_add_gui_app(
		${_PROJECT_NAME}

		PRODUCT_NAME ${_PRODUCT_NAME}
		BUNDLE_ID ${_BUNDLE_ID}

		COMPANY_NAME ${_COMPANY_NAME}
		COMPANY_WEBSITE ${_COMPANY_WEBSITE}
		COMPANY_EMAIL ${_COMPANY_EMAIL}

		NEEDS_WEB_BROWSER ${_NEEDS_WEB_BROWSER}
		NEEDS_CURL ${_NEEDS_CURL}

		MICROPHONE_PERMISSION_ENABLED ${_MICROPHONE_PERMISSION_ENABLED}
		MICROPHONE_PERMISSION_TEXT ${_MICROPHONE_PERMISSION_TEXT}

		HARDENED_RUNTIME_ENABLED ${_HARDENED_RUNTIME_ENABLED}
		HARDENED_RUNTIME_OPTIONS ${_HARDENED_RUNTIME_OPTIONS}
)

juce_generate_juce_header(${_PROJECT_NAME})


# ================================================================================
# ORGANIZE FILES IN IDE AND TARGET SOURCES
# ================================================================================

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${_SOURCE_FILES})

target_sources(${_PROJECT_NAME}
		PRIVATE
		${_SOURCE_FILES}
)


# ================================================================================
# COMPILER DEFINITIONS
# ================================================================================

target_compile_definitions(
	${_PROJECT_NAME}
	PUBLIC
	JUCE_WEB_BROWSER=$<BOOL:${_NEEDS_WEB_BROWSER}>
	JUCE_USE_CURL=$<BOOL:${_NEEDS_CURL}>
	KINKOUT_APP_ALLOW_MULTIPLE_INSTANCES=$<BOOL:${_ALLOW_MULTIPLE_INSTANCES}>
	JUCE_APPLICATION_NAME_STRING="$<TARGET_PROPERTY:${_PROJECT_NAME},JUCE_PRODUCT_NAME>"
	JUCE_APPLICATION_VERSION_STRING="$<TARGET_PROPERTY:${_PROJECT_NAME},JUCE_VERSION>"
)
if(_APP_TYPE STREQUAL "AUDIO")
	target_compile_definitions(
		${_PROJECT_NAME}
		PUBLIC
		KINKOUT_APP_DEFAULT_AUDIO_INPUT_CHANNELS=${_DEFAULT_AUDIO_INPUT_CHANNELS}
		KINKOUT_APP_DEFAULT_AUDIO_OUTPUT_CHANNELS=${_DEFAULT_AUDIO_OUTPUT_CHANNELS}
		KINKOUT_APP_WANTS_MIDI_INPUT=$<BOOL:${_WANTS_MIDI_INPUT}>
		KINKOUT_APP_PRODUCES_MIDI_OUTPUT=$<BOOL:${_PRODUCES_MIDI_OUTPUT}>
	)
endif()

# ================================================================================
# TARGET LINK LIBRARIES
# ================================================================================

# JUCE MODULES
# --------------------------------------------------------------------------------
target_link_libraries(${_PROJECT_NAME}
		PRIVATE
		${JUCE_CORE_AUDIO_MODULES}
		${JUCE_CORE_SYSTEM_MODULES}
		${JUCE_DSP_MODULES}
		${JUCE_GUI_MODULES}
		${JUCE_OPTIONAL_MODULES}
# -------------------------------------------------------------------------------- Recommended flags
		juce::juce_recommended_config_flags
		juce::juce_recommended_warning_flags
		juce::juce_recommended_lto_flags
)


# KINKOUT MODULES LIBRARY
# --------------------------------------------------------------------------------
if(DEFINED _KKML)
	target_link_libraries(
		${_PROJECT_NAME}
		PRIVATE
		${_KKML}
	)
endif()


# CUSTOM MODULES
# --------------------------------------------------------------------------------
if(DEFINED _CSTM)
	target_link_libraries(
		${_PROJECT_NAME}
		PRIVATE
		${_CSTM}
	)
endif()


# ================================================================================
# Post-build info
# ================================================================================

message(
		"| =========================================================================== |\n"
		"|                         BUILD SUMMARY CONFIGURATION                         |\n"
		"| =========================================================================== |\n")

# -------------------------------------------------------------------------------- Print company Info
message(STATUS "COMPANY INFORMATION")
message("\t\t-> COMPANY_NAME                    : ${_COMPANY_NAME}")
message("\t\t-> COMPANY_EMAIL                   : ${_COMPANY_EMAIL}")
message("\t\t-> COMPANY_WEBSITE                 : ${_COMPANY_WEBSITE}")
message("")


# -------------------------------------------------------------------------------- Print project Info
message(STATUS "APPLICATION INFORMATION")
message("\t\t-> PROJECT_NAME                    : ${_PROJECT_NAME}")
message("\t\t-> PRODUCT_NAME                    : ${_PRODUCT_NAME}")
message("\t\t-> APP_TYPE                        : ${_APP_TYPE}")
message("\t\t-> VERSION                         : ${_VERSION}")
message("\t\t-> BUNDLE_ID                       : ${_BUNDLE_ID}")
message("\t\t-> DESCRIPTION                     : ${_DESCRIPTION}")
message("")


# -------------------------------------------------------------------------------- Print application setting
message(STATUS "APPLICATION OPTIONS")
message("\t\t-> ALLOW_MULTIPLE_INSTANCES        : ${_ALLOW_MULTIPLE_INSTANCES}")
message("\t\t-> NEEDS_WEB_BROWSER               : ${_NEEDS_WEB_BROWSER}")
message("\t\t-> NEEDS_CURL                      : ${_NEEDS_CURL}")
message("\t\t-> MICROPHONE_PERMISSION           : ${_MICROPHONE_PERMISSION_ENABLED}")
message("")

# -------------------------------------------------------------------------------- Print paths
message(STATUS "PATHS")
message("\t\t-> Project Root                    : ${_THIS_DIR}")
message("\t\t-> Build                           : ${_BUILD_PATH}")
message("\t\t-> CMake                           : ${CMAKE_BINARY_DIR}")
message("\t\t-> Source                          : ${_THIS_DIR}/${_S}")
message("\t\t-> Assets                          : ${_ASSETS_PATH}")
message("\t\t-> JUCE Path                       : ${_JUCE_PATH}")
message("\t\t-> KinKout Modules                 : ${_KKML_PATH}")
message("\t\t-> Custom Modules                  : ${_CSTM_PATH}")
message("")

# -------------------------------------------------------------------------------- Print source files
message(STATUS "SOURCE FILES")
message("\t- Total files found: ${_SOURCE_COUNT}")
if(_SOURCE_COUNT GREATER 0)

	foreach(_SF ${_SOURCE_FILES})
		get_filename_component(FILENAME ${_SF} NAME)
		list(APPEND _NAME_LIST ${FILENAME})
	endforeach()

	list(SORT _NAME_LIST)

	foreach(_NL ${_NAME_LIST})
		get_filename_component(FILENAME ${_NL} NAME)
		message("\t\t• ${FILENAME}")
	endforeach()
else()
	message(WARNING "No source files found in source/ directory!")
endif()
message("\n")


# -------------------------------------------------------------------------------- Print JUCE modules
function(print_juce_modules _MODULE_TYPE _MODULE_TYPE_NAME)
	message("\t- ${_MODULE_TYPE_NAME}:")

	set(_COUNT 0)
	foreach(_ML ${${_MODULE_TYPE}})
		message("\t\t• ${_ML}")
		math(EXPR _COUNT "${_COUNT} + 1")
	endforeach()

	message("\t\t\tselected: ${_COUNT}\n")
endfunction()

message(STATUS "JUCE MODULES STATUS\n")
print_juce_modules(JUCE_CORE_AUDIO_MODULES  "Core Audio Modules")
print_juce_modules(JUCE_CORE_SYSTEM_MODULES "Core System Modules")
print_juce_modules(JUCE_DSP_MODULES "DSP Modules")
print_juce_modules(JUCE_GUI_MODULES "GUI Modules")
print_juce_modules(JUCE_OPTIONAL_MODULES "Optional Modules")


# -------------------------------------------------------------------------------- Print KKModulesLib status
if(NOT DEFINED _KKML_PATH OR _KKML_PATH STREQUAL "")
	message(STATUS "No KKModulesLib path defined\n")
else()
	file(GLOB _KKML_CHILDREN RELATIVE "${_KKML_PATH}" "${_KKML_PATH}/*")

	set(_KKML_FOUND_DIRS "")
	foreach(_CHILD ${_KKML_CHILDREN})
		if(IS_DIRECTORY "${_KKML_PATH}/${_CHILD}")
			list(APPEND _KKML_FOUND_DIRS "${_CHILD}")
		endif()
	endforeach()

	list(LENGTH _KKML_FOUND_DIRS _KKML_TOTAL)
	list(LENGTH _KKML _KKML_LINKED)

	message(STATUS "KinKoutDSP MODULES STATUS")
	message("\t\t-> Path                        :${_KKML_PATH}")
	message("\t\t-> Modules physically present  :${_KKML_TOTAL}")
	message("\t\t-> Modules linked in project   :${_KKML_LINKED}")
	message("")

	foreach(_DIR ${_KKML_FOUND_DIRS})
		if(TARGET ${_DIR})
			message("\t\t    >>> ${_DIR}")
		else()
			message("\t\t    XXX ${_DIR}")
		endif()
	endforeach()

	message("")
endif()


# -------------------------------------------------------------------------------- Print Custom Modules status
if(NOT DEFINED _CSTM_PATH OR _CSTM_PATH STREQUAL "")
	message(STATUS "No Custom Modules path defined\n")
else()
	file(GLOB _CSTM_CHILDREN RELATIVE "${_CSTM_PATH}" "${_CSTM_PATH}/*")

	set(_CSTM_FOUND_DIRS "")
	foreach(_CHILD ${_CSTM_CHILDREN})
		if(IS_DIRECTORY "${_CSTM_PATH}/${_CHILD}")
			list(APPEND _CSTM_FOUND_DIRS "${_CHILD}")
		endif()
	endforeach()

	list(LENGTH _CSTM_FOUND_DIRS _CSTM_TOTAL)
	list(LENGTH _CSTM _CSTM_LINKED)

	message(STATUS "CUSTOM MODULES STATUS")
	message("\t\t-> Path                        :${_CSTM_PATH}")
	message("\t\t-> Modules physically present  :${_CSTM_TOTAL}")
	message("\t\t-> Modules linked in project   :${_CSTM_LINKED}")
	message("")

	foreach(_DIR ${_CSTM_FOUND_DIRS})
		if(TARGET ${_DIR})
			message("\t\t    >>> ${_DIR}")
		else()
			message("\t\t    XXX ${_DIR}")
		endif()
	endforeach()

	message("")
endif()


message("\n\n\n"
		"| =========================================================================== |\n"
		"|                                BUILD SUCCEEDED                              |\n"
		"| =========================================================================== |\n\n\n")

# ================================================================================
# Create main source files
# ================================================================================
#
# File:				createSourceTemplate.cmake
# Author:			KinKout
# Date:				28-Oct-2026
#
# Purpose:		Create source files from templates in /_cmake-config/template/.
#						Uses configure_file() to replace variables with @ONLY.
#
# ================================================================================


set(PRODUCT_NAME_T "${_PRODUCT_NAME}")
set(VERSION_T "${_VERSION}")
string(TIMESTAMP BUILD_DATE_T "%d-%b-%Y")
set(DESCRIPTION_T "${_DESCRIPTION}")
set(PROJECT_NAME_T "${_PROJECT_NAME}")
set(APP_TYPE_T "${_APP_TYPE}")

set(COMPANY_NAME_T "${_COMPANY_NAME}")
set(COMPANY_WEBSITE_T "${_COMPANY_WEBSITE}")
set(COMPANY_EMAIL_T "${_COMPANY_EMAIL}")

set(TEMPLATE_DIR "${_THIS_DIR}/_cmake-config/template")
set(_OPTIONAL_SOURCE_LOADED FALSE) # set to FALSE if you need to load the optional source

set(_N_TEMPLATE_LOADED 0)
set(N_TEMPLATE_NOT_LOADED 0)

set(_COMMON_TEMPLATE_FILES
		"essential:source/ui:MainWindow_cpp"
		"essential:source/ui:MainWindow_h"
		"essential:source/ui:MainComponent_cpp"
		"essential:source/ui:MainComponent_h"
)

set(_GUI_TEMPLATE_FILES
		"essential:source:MainGuiApp_cpp"
)

set(TEMPLATE_FILES ${_COMMON_TEMPLATE_FILES})

if(_APP_TYPE STREQUAL "GUI")
	list(APPEND TEMPLATE_FILES ${_GUI_TEMPLATE_FILES})
endif()

list(SORT TEMPLATE_FILES)
foreach(LIST ${TEMPLATE_FILES})
	string(REPLACE ":" ";" LIST ${LIST})
	list(GET LIST 0 TYPE)
	list(GET LIST 1 SUBDIR)
	list(GET LIST 2 TEMPLATE)

	string(REPLACE "_h" ".h" OUT_NAME "${TEMPLATE}")
	string(REPLACE "_cpp" ".cpp" OUT_NAME "${OUT_NAME}")

	set(SOURCE_FILE "${_THIS_DIR}/${SUBDIR}/${OUT_NAME}")

	if(NOT EXISTS "${SOURCE_FILE}")
		if(TYPE STREQUAL "optional" AND _OPTIONAL_SOURCE_LOADED STREQUAL TRUE)
			message("\t-> Excluded:\t[${TYPE}]\t${SUBDIR}/${OUT_NAME}")
			math(EXPR N_TEMPLATE_NOT_LOADED "${N_TEMPLATE_NOT_LOADED} + 1")
			continue()
		endif()
		configure_file(
			"${TEMPLATE_DIR}/${TEMPLATE}.txt"
			"${SOURCE_FILE}"
			@ONLY
		)
		message("\t-> Generated:\t[${TYPE}]\t${SUBDIR}/${OUT_NAME}")
	else()
		message("\t-> Detected:\t[${TYPE}]\t${SUBDIR}/${OUT_NAME}")
	endif()
	math(EXPR _N_TEMPLATE_LOADED "${_N_TEMPLATE_LOADED} + 1")
endforeach()

message("\n\t>>> template source files: ${_N_TEMPLATE_LOADED} files confirmed")
if(N_TEMPLATE_NOT_LOADED)
	message("\t                           ${N_TEMPLATE_NOT_LOADED} optional files ignored, deleted by user\n")
	message(WARNING "If you need to reload the optional source files,\n"
			"set \"_OPTIONAL_SOURCE_LOADED\" variable to \"FALSE\"\n"
			"at line 27 in /_cmake-config/_scripts/createSourceTemplate.cmake\" files.\n"
			"The optional source files will be created in their original path.")
endif ()
message("\n")

if(NOT _OPTIONAL_SOURCE_LOADED)
	file(READ "_cmake-config/_scripts/createSourceTemplate.cmake" THIS_FILE)
	set(F FALSE)
	string(REPLACE
			"set(_OPTIONAL_SOURCE_LOADED ${F})"
			"set(_OPTIONAL_SOURCE_LOADED TRUE)"
			THIS_FILE_UPDATED
			"${THIS_FILE}")
	file(WRITE "_cmake-config/_scripts/createSourceTemplate.cmake" "${THIS_FILE_UPDATED}")
endif()

##############################################################################
# 
# The Unifier - revision: 1
# 
# This is meant to be used by any project really.
# All you need to do is have a use.cmake in the root
# of your library that calls definelib(mylib) and 
# declares all it's other Unifier compatible libraries
# with uselib(myotherlib)
# Then in your executable you can uselib(mylib) and include ${headers} and 
# link with ${libs} and all should just work (meaning myotherlib should be pulled correctly)
# 
# The only issue is that all your libraries should be unifier compatible to
# be used this way
# 
# oh and don't forget to include this file in the beginning of your project file
# 
##############################################################################

if(unifier_included)
	return()
endif()
set(unifier_included true)

## definelib
macro(definelib libname)
	if(NOT DEFINED vendor)
		message(FATAL "vendor variable must be set to the vendor location (the one with all the libraries)")
	endif()

	if(use_${libname}_included)
		return()
	endif()

	set(use_${libname}_included true)
	message(STATUS "definelib: ${libname}")

	if (NOT TARGET ${libname})
		add_subdirectory(${vendor}/${libname} ${CMAKE_BINARY_DIR}/${libname})
	endif()

	list(APPEND headers "${vendor}/${libname}/include")
	list(APPEND libs "${libname}")
endmacro()

## uselib
macro(uselib libname)
	if(NOT DEFINED vendor)
		message(FATAL "vendor variable must be set to the vendor location (the one with all the libraries)")
	endif()

	include("${vendor}/${libname}/use.cmake")
endmacro()

# fix output directories - get rid of Release/Debug
if(MSVC)
	foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
		string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
		set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin)
		set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
		set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib)
	endforeach(OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES)
endif()

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

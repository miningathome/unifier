##############################################################################
# 
# The Unifier - revision: 2
# 
# This is meant to be used by any project really.
# A library must adhere to the unifier standards in order to work correctly with
# libraries that depend on it (and use unifier).
# * include files for the public must be in <libroot>/include/<libname>
# * the library cmake must include(unifier/unifier.cmake) in the beginning
# * must have a use.cmake file on <libroot> that:
# * * definelib(<libname>)
# * * uselib(<other_unifier_compatible_libname_dependency>)
# * * uselib_noheaders(<link_only_unifier_compatible_libname_dependency>)
# 
# Then in your cmakelists you can uselib(depending_on_lib) and include ${headers} and 
# link with ${libs} and all should just work (meaning all libs to link should be pulled correctly
# as well as all public required headers)
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

#	message(STATUS "definelib: ${CMAKE_CURRENT_SOURCE_DIR} ${libname}")

	if (NOT TARGET ${libname})
		add_subdirectory(${CMAKE_CURRENT_LIST_DIR} ${CMAKE_BINARY_DIR}/${libname})
	endif()

	if(NOT ${libname}_headers_included)
		list(APPEND headers "${CMAKE_CURRENT_LIST_DIR}/include")
		set(${libname}_headers_included true)
	endif()
	
	if(NOT ${libname}_libs_included)
		list(APPEND libs "${libname}")
		set(${libname}_libs_included true)
	endif()
endmacro()

## uselib
macro(uselib libname)
	if(NOT DEFINED vendor)
		message(FATAL "vendor variable must be set to the vendor location (the one with all the libraries)")
	endif()

#	message(STATUS "uselib: ${libname} (${CMAKE_CURRENT_SOURCE_DIR})")

	include("${vendor}/${libname}/use.cmake")
endmacro()

## no headers
macro(uselib_noheaders libname)
	if(NOT DEFINED vendor)
		message(FATAL "vendor variable must be set to the vendor location (the one with all the libraries)")
	endif()

#	message(STATUS "uselib_noheaders: ${libname} (${CMAKE_CURRENT_SOURCE_DIR})")

	if(${libname}_headers_included)
		include("${vendor}/${libname}/use.cmake")
	else()
		set(${libname}_headers_included true)
		include("${vendor}/${libname}/use.cmake")
		unset(${libname}_headers_included)
	endif()
endmacro()

# compiler flags we use in most projects
if(CMAKE_COMPILER_IS_GNUCXX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++11")
endif()

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

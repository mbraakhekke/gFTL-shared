include (fortran_try)

CHECK_Fortran_SOURCE_RUN (
  ${CMAKE_CURRENT_LIST_DIR}/trial_sources/LOGICAL_DEFAULT_KIND.F90
  _LOGICAL_DEFAULT_KIND
  "Default logical kind"
  )

CHECK_Fortran_SOURCE_RUN (
  ${CMAKE_CURRENT_LIST_DIR}/trial_sources/INT_DEFAULT_KIND.F90
  _INT_DEFAULT_KIND
  "Default integer kind"
  )
foreach (kind 8 16 32 64)

  set(CMAKE_REQUIRED_FLAGS = -fpp)
  set(CMAKE_REQUIRED_DEFINITIONS -D_KIND=INT${kind})

  CHECK_Fortran_SOURCE_RUN (
    ${CMAKE_CURRENT_LIST_DIR}/trial_sources/INT_KIND.F90
    _ISO_INT${kind}
    "Integer(${kind}) kind"
    )

endforeach()

CHECK_Fortran_SOURCE_RUN (
  ${CMAKE_CURRENT_LIST_DIR}/trial_sources/REAL_DEFAULT_KIND.F90
  _REAL_DEFAULT_KIND
  "Default real kind"
  )

CHECK_Fortran_SOURCE_RUN (
  ${CMAKE_CURRENT_LIST_DIR}/trial_sources/DOUBLE_DEFAULT_KIND.F90
  _DOUBLE_DEFAULT_KIND
  "Default double kind"
  )

foreach (kind 32 64 128)

  if (DEFINED CACHE{GFTL_SHARED_ISO_REAL${kind}})
  
	set(_ISO_REAL${kind} ${GFTL_SHARED_ISO_REAL${kind}})
    add_definitions(-D_ISO_REAL${kind}=${_ISO_REAL${kind}})
	  
  else ()
  
    set(CMAKE_REQUIRED_FLAGS = -fpp)
    set(CMAKE_REQUIRED_DEFINITIONS -D_KIND=REAL${kind})
    if ( NOT ("${CMAKE_REQUIRED_FLAGS}" STREQUAL ""))
      string(REPLACE "=" "" compile_flags ${CMAKE_REQUIRED_FLAGS})
    endif ()
    execute_process(
      COMMAND ${CMAKE_Fortran_COMPILER} ${CMAKE_REQUIRED_DEFINITIONS} ${compile_flags} ${CMAKE_CURRENT_LIST_DIR}/trial_sources/REAL_KIND.F90 "-o" "REAL_KIND_${kind}.exe"
      RESULT_VARIABLE error
      WORKING_DIRECTORY ${GFTL_SHARED_BINARY_DIR}
      OUTPUT_QUIET
      ERROR_QUIET
      )

    if ( NOT error)
      CHECK_Fortran_SOURCE_RUN (
        ${CMAKE_CURRENT_LIST_DIR}/trial_sources/REAL_KIND.F90
        _ISO_REAL${kind}
        "Real(${kind}) kind"
        )
        
    endif ()
    
  endif ()
  
endforeach()




FUNCTION (BORINGSSL_ADJUST)
    cmake_minimum_required(VERSION 3.14)

    IF (OPENSSL_FOUND AND EXISTS "${OPENSSL_INCLUDE_DIR}/openssl/base.h")
        MESSAGE(STATUS "  BoringSSL found; assuming OpenSSL 1.1.1 compatibility")
        SET(OPENSSL_VERSION "1.1.1" PARENT_SCOPE)

        message("OpenSSL libs: ${OPENSSL_LIBRARIES}")

        if ("BoringSSL::ssl" IN_LIST OPENSSL_LIBRARIES)
            LIST(APPEND OPENSSL_CRYPTO_LIBRARIES "BoringSSL::decrepit")
            SET (OPENSSL_CRYPTO_LIBRARIES "${OPENSSL_CRYPTO_LIBRARIES}" PARENT_SCOPE)
            LIST(APPEND OPENSSL_LIBRARIES "BoringSSL::decrepit")
            set (OPENSSL_LIBRARIES ${OPENSSL_LIBRARIES} PARENT_SCOPE)

            message("Appending decrepit: ${OPENSSL_LIBRARIES}")

        else ()
            LIST(GET OPENSSL_CRYPTO_LIBRARIES 0 OPENSSL_ONE_LIB_PATH)
            GET_FILENAME_COMPONENT(OPENSSL_LIBDIR "${OPENSSL_ONE_LIB_PATH}" DIRECTORY)
            SET(LIBDECREPIT_PATH "${OPENSSL_LIBDIR}/libdecrepit.a")
            IF (NOT EXISTS "${LIBDECREPIT_PATH}")
                MESSAGE(FATAL_ERROR "libdecrepit.a was not found under ${OPENSSL_LIBDIR}; maybe you need to manually copy the file there")
            ENDIF ()
            LIST(APPEND OPENSSL_CRYPTO_LIBRARIES "${LIBDECREPIT_PATH}")
            SET(OPENSSL_CRYPTO_LIBRARIES "${OPENSSL_CRYPTO_LIBRARIES}" PARENT_SCOPE)
            LIST(APPEND OPENSSL_LIBRARIES "${LIBDECREPIT_PATH}")
            SET(OPENSSL_LIBRARIES "${OPENSSL_LIBRARIES}" PARENT_SCOPE)
        endif ()

    ENDIF ()
ENDFUNCTION ()

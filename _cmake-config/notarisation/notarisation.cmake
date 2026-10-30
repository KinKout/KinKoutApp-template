# ================================================================================
# Notarisation settings
# ================================================================================
#
# File:				notarisation.cmake
# Author:			KinKout
# Date:				28-Oct-2026
#
# Purpose:		enable or disable _HARDENED_RUNTIME_ENABLED.
#						Required for final notarisation.
#
# ================================================================================


# --------------------------------------------------------------------------------
# Enables macOS' hardened runtime for this target. Required for notarisation.
set(_HARDENED_RUNTIME_ENABLED FALSE)

# --------------------------------------------------------------------------------
# A set of space-separated entitlement keys
# that will be added to this target's entitlements plist
set(_HARDENED_RUNTIME_OPTIONS "")

# TODO: fetch appConfig.cmake options to build automatic '_HARDENED_RUNTIME_OPTIONS' setting

# AI source
#1. Core Code Signing Entitlements (com.apple.security.cs...)
#These are the most critical for applications loading external libraries or using specific memory features.
#
#com.apple.security.cs.disable-library-validation: Required only if the application loads third-party dynamic libraries that are not signed with the same Team ID.
#com.apple.security.cs.allow-unsigned-executable-memory: Required if the application uses JIT (Just-In-Time) compilation.
#com.apple.security.cs.disable-executable-page-protection: Rarely needed; allows executing code on pages marked writable. Only use if you have a specific legacy requirement that fails without it.
#com.apple.security.cs.allow-dyld-environment-variables: Allows the dynamic linker to use environment variables. Usually not needed.
#
#2. File & Network Access Entitlements
#If the application accesses files outside its bundle or connects to the internet.
#
#com.apple.security.assets.music.read-write: Grants access to the user's Music library.
#com.apple.security.files.user-selected.read-write: Required if you use a standard macOS "Open/Save File" dialog to let the user pick a file. The system usually handles this via the dialog, but explicit entitlements ensure robustness in sandboxed environments.
#com.apple.security.network.client: Required if the application makes outgoing network connections.

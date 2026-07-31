; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs

; Test that we emit global variable definitions when no function definitions are present

; CHECK: .export .const .align 4 @cvar = { .32b 0x5 };
@cvar = addrspace(2) constant i32 5

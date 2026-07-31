; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

; CHECK-LABEL: @test_fptrunc16_32
; O0-LABEL: @test_fptrunc16_32
define half @test_fptrunc16_32_ftz(float %a) #0 {
  ; CHECK: ftrunc.hf.f.ftz
  ; O0: ftrunc.hf.f.ftz
  %result = fptrunc float %a to half
  ret half %result
}

attributes #0 = { denormal_fpenv(preservesign) }

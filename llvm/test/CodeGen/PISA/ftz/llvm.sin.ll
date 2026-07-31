; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare float @llvm.sin.f32(float)
declare half @llvm.sin.f16(half)

; CHECK-LABEL: @test_sin_ftz
; O0-LABEL: @test_sin_ftz
define float @test_sin_ftz(float %a) #0 {
  ; CHECK: fsin.ftz.f
  ; O0: fsin.ftz.f
  %result = call float @llvm.sin.f32(float %a)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




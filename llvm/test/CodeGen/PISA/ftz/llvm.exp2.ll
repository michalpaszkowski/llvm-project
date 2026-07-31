; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare float @llvm.exp2.f32(float)
declare half @llvm.exp2.f16(half)

; CHECK-LABEL: @test_exp2_ftz
; O0-LABEL: @test_exp2_ftz
define float @test_exp2_ftz(float %a) #0 {
  ; CHECK: fexp2.ftz.f
  ; O0: fexp2.ftz.f
  %result = call float @llvm.exp2.f32(float %a)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




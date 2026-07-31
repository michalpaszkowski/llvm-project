; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare float @llvm.exp.f32(float)

; CHECK-LABEL: @test_exp_ftz
; O0-LABEL: @test_exp_ftz
define float @test_exp_ftz(float %a) #0 {
  ; CHECK: fmul.ftz.f
  ; O0: fmul.ftz.f
  ; CHECK-NEXT: fexp2.ftz.f
  ; O0-NEXT: fexp2.ftz.f
  %result = call float @llvm.exp.f32(float %a)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




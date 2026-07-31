; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare float @llvm.cos.f32(float)
declare half @llvm.cos.f16(half)

; CHECK-LABEL: @test_cos_ftz
; O0-LABEL: @test_cos_ftz
define float @test_cos_ftz(float %a) #0 {
  ; CHECK: fcos.ftz.f
  ; O0: fcos.ftz.f
  %result = call float @llvm.cos.f32(float %a)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




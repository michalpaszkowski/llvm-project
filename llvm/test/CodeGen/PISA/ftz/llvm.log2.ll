; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare float @llvm.log2.f32(float)
declare half @llvm.log2.f16(half)

; CHECK-LABEL: @test_log2_ftz
; O0-LABEL: @test_log2_ftz
define float @test_log2_ftz(float %a) #0 {
  ; CHECK: flog2.ftz.f
  ; O0: flog2.ftz.f
  %result = call float @llvm.log2.f32(float %a)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




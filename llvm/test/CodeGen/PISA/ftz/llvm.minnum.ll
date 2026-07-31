; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare half @llvm.minnum.f16(half, half)
declare float @llvm.minnum.f32(float, float)
declare double @llvm.minnum.f64(double, double)

; CHECK-LABEL: @test_minnum_ftz
; O0-LABEL: @test_minnum_ftz
define float @test_minnum_ftz(float %a, float %b) #0 {
  ; CHECK: fmin.ftz.f
  ; O0: fmin.ftz.f
  %result = call float @llvm.minnum.f32(float %a, float %b)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




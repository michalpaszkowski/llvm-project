; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare half @llvm.maxnum.f16(half, half)
declare float @llvm.maxnum.f32(float, float)
declare double @llvm.maxnum.f64(double, double)

; CHECK-LABEL: @test_maxnum_ftz
; O0-LABEL: @test_maxnum_ftz
define float @test_maxnum_ftz(float %a, float %b) #0 {
  ; CHECK: fmax.ftz.f
  ; O0: fmax.ftz.f
  %result = call float @llvm.maxnum.f32(float %a, float %b)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




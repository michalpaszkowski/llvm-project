; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare float @llvm.log.f32(float)

; CHECK-LABEL: @test_log_ftz
; O0-LABEL: @test_log_ftz
define float @test_log_ftz(float %a) #0 {
  ; CHECK: flog2.ftz.f
  ; O0: flog2.ftz.f
  ; CHECK-NEXT: fmul.ftz.f
  ; O0-NEXT: fmul.ftz.f
  %result = call float @llvm.log.f32(float %a)
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }




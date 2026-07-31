; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: PISA Verifier: Intrinsic llvm.pisa.fadd.f32 specifies invalid rounding mode value 12

declare float @llvm.pisa.fadd(float, float, i8, i1);
define float @test(float %a, float %b) {
  %rv = call float @llvm.pisa.fadd(float %a, float %b, i8 12, i1 0)
  ret float %rv
}

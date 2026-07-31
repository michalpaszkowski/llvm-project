; RUN: llc < %s -march=pisa -stop-after=pisa-emit-intrinsics -o - | FileCheck %s

declare float @llvm.experimental.constrained.minnum.f32(float, float, metadata) #0
declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata) #0
declare float @llvm.experimental.constrained.fsub.f32(float, float, metadata, metadata) #0
declare float @llvm.experimental.constrained.fmul.f32(float, float, metadata, metadata) #0
declare float @llvm.experimental.constrained.fma.f32(float, float, float, metadata, metadata) #0
declare float @llvm.experimental.constrained.fptrunc.f32.f64(double, metadata, metadata) #0
declare float @llvm.experimental.constrained.sitofp.f32.i32(i32, metadata, metadata) #0
declare i32 @llvm.experimental.constrained.fptosi.i32.f32(float, metadata) #0
declare i32 @llvm.experimental.constrained.fptoui.i32.f32(float, metadata) #0
declare double @llvm.experimental.constrained.fpext.f64.f32(float, metadata) #0
declare i32 @llvm.pisa.fptoui.md.i32.f32(float, metadata)
declare i32 @llvm.pisa.fptosi.md.i32.f32(float, metadata)

; constrained_minnum with nnan: the replacement llvm.minnum call inherits nnan
; via copyFastMathFlags (the isa<FPMathOperator> branch).
define float @test_replace_intrinsic_fmf(float %a, float %b) #0 {
; CHECK-LABEL: define float @test_replace_intrinsic_fmf(
; CHECK:         %1 = call nnan float @llvm.minnum.f32(float %a, float %b)
; CHECK-NEXT:    ret float %1
  %r = call nnan float @llvm.experimental.constrained.minnum.f32(
               float %a, float %b, metadata !"fpexcept.ignore") #0
  ret float %r
}

; constrained_fadd is replaced by llvm.pisa.fadd.f32 with an explicit rounding
; mode operand; the argument list is rebuilt via SmallVector in replaceRoundingModeMD.
define float @test_replace_roundmode_args(float %a, float %b) #0 {
; CHECK-LABEL: define float @test_replace_roundmode_args(
; CHECK:         %1 = call float @llvm.pisa.fadd.f32(float %a, float %b, {{.*}} i8 1, {{.*}} i1 false)
; CHECK-NOT:     @llvm.experimental.constrained.fadd
  %r = call float @llvm.experimental.constrained.fadd.f32(
               float %a, float %b,
               metadata !"round.tonearest",
               metadata !"fpexcept.ignore") #0
  ret float %r
}

; constrained_fsub/fmul/fma map to the corresponding PISA rounding-mode
; intrinsics; each pushes an explicit saturation operand from the switch in
; replaceRoundingModeMD.
define float @test_constrained_fsub(float %a, float %b) #0 {
; CHECK-LABEL: define float @test_constrained_fsub(
; CHECK:         %1 = call float @llvm.pisa.fsub.f32(float %a, float %b, {{.*}} i8 1, {{.*}} i1 false)
  %r = call float @llvm.experimental.constrained.fsub.f32(
               float %a, float %b,
               metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret float %r
}

define float @test_constrained_fmul(float %a, float %b) #0 {
; CHECK-LABEL: define float @test_constrained_fmul(
; CHECK:         %1 = call float @llvm.pisa.fmul.f32(float %a, float %b, {{.*}} i8 1, {{.*}} i1 false)
  %r = call float @llvm.experimental.constrained.fmul.f32(
               float %a, float %b,
               metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret float %r
}

define float @test_constrained_fma(float %a, float %b, float %c) #0 {
; CHECK-LABEL: define float @test_constrained_fma(
; CHECK:         %1 = call float @llvm.pisa.fma.f32(float %a, float %b, float %c, {{.*}} i8 1, {{.*}} i1 false)
  %r = call float @llvm.experimental.constrained.fma.f32(
               float %a, float %b, float %c,
               metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret float %r
}

; constrained_fptrunc / sitofp map to pisa.ftrunc / pisa.sitofp.
define float @test_constrained_fptrunc(double %a) #0 {
; CHECK-LABEL: define float @test_constrained_fptrunc(
; CHECK:         %1 = call float @llvm.pisa.ftrunc.f32.f64(double %a, {{.*}} i8 1, {{.*}} i1 false)
  %r = call float @llvm.experimental.constrained.fptrunc.f32.f64(
               double %a,
               metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret float %r
}

define float @test_constrained_sitofp(i32 %a) #0 {
; CHECK-LABEL: define float @test_constrained_sitofp(
; CHECK:         %1 = call float @llvm.pisa.sitofp.f32.i32(i32 %a, {{.*}} i8 1, {{.*}} i1 false)
  %r = call float @llvm.experimental.constrained.sitofp.f32.i32(
               i32 %a,
               metadata !"round.tonearest", metadata !"fpexcept.ignore") #0
  ret float %r
}

; constrained_fptosi / fptoui / fpext lower to plain cast instructions
; (exceptions are unsupported).
define i32 @test_constrained_fptosi(float %a) #0 {
; CHECK-LABEL: define i32 @test_constrained_fptosi(
; CHECK:         %1 = fptosi float %a to i32
  %r = call i32 @llvm.experimental.constrained.fptosi.i32.f32(
               float %a, metadata !"fpexcept.ignore") #0
  ret i32 %r
}

define i32 @test_constrained_fptoui(float %a) #0 {
; CHECK-LABEL: define i32 @test_constrained_fptoui(
; CHECK:         %1 = fptoui float %a to i32
  %r = call i32 @llvm.experimental.constrained.fptoui.i32.f32(
               float %a, metadata !"fpexcept.ignore") #0
  ret i32 %r
}

define double @test_constrained_fpext(float %a) #0 {
; CHECK-LABEL: define double @test_constrained_fpext(
; CHECK:         %1 = fpext float %a to double
  %r = call double @llvm.experimental.constrained.fpext.f64.f32(
               float %a, metadata !"fpexcept.ignore") #0
  ret double %r
}

; The non-constrained PISA rounding-mode intrinsics take the IsConstrained=false
; path in replaceRoundingModeMD (one trailing metadata operand) and are not
; FPMathOperators, so no fast-math flags are copied.
define i32 @test_md_fptoui(float %a) {
; CHECK-LABEL: define i32 @test_md_fptoui(
; CHECK:         %1 = call i32 @llvm.pisa.fptoui.rnd.i32.f32(float %a, i8 0)
  %r = call i32 @llvm.pisa.fptoui.md.i32.f32(float %a, metadata !"round.towardzero")
  ret i32 %r
}

define i32 @test_md_fptosi(float %a) {
; CHECK-LABEL: define i32 @test_md_fptosi(
; CHECK:         %1 = call i32 @llvm.pisa.fptosi.rnd.i32.f32(float %a, i8 0)
  %r = call i32 @llvm.pisa.fptosi.md.i32.f32(float %a, metadata !"round.towardzero")
  ret i32 %r
}

attributes #0 = { strictfp }

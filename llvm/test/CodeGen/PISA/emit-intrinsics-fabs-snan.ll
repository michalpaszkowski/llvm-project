; RUN: llc < %s -march=pisa -stop-after=pisa-emit-intrinsics -o - | FileCheck %s

; PISAEmitIntrinsics rewrites llvm.fabs to llvm.pisa.fabs whenever its
; SNaNPayloadAnalysis can prove the SNaN-vs-QNaN distinction is unobservable,
; via either the def-side cannotBeSNaN walk or the use-side
; allUsesAreSNaNInsensitive walk. These tests exercise the analysis branches
; that real workloads hit but the existing fabs tests do not: constant vectors,
; select / insertelement operands that are NOT provably non-SNaN, the PISA
; arithmetic intrinsic producers, and an SNaN-sensitive use.

declare float @llvm.fabs.f32(float)
declare <2 x float> @llvm.fabs.v2f32(<2 x float>)
declare float @llvm.sqrt.f32(float)
declare float @llvm.pisa.fadd.f32(float, float, i8, i1)
declare float @llvm.pisa.fmul.f32(float, float, i8, i1)
declare float @llvm.pisa.frcp.f32(float)

; Def-side: a constant vector is not a scalar ConstantFP and not undef/poison,
; so the analysis walks each aggregate element. All elements are non-signaling,
; so cannotBeSNaN is true and the fabs is rewritten.
define <2 x float> @fabs_vec_const() {
; CHECK-LABEL: define <2 x float> @fabs_vec_const(
; CHECK:    call <2 x float> @llvm.pisa.fabs.v2f32(
; CHECK-NOT:  call {{.*}}@llvm.fabs.
  %r = call <2 x float> @llvm.fabs.v2f32(<2 x float> <float 1.0, float 2.0>)
  ret <2 x float> %r
}

; Def-side select: operand 1 is a plain argument (may be SNaN), so the first
; cannotBeSNaN short-circuits false and the fabs is left as IEEE fabs.
define float @fabs_select_unknown(i1 %c, float %x, float %y) {
; CHECK-LABEL: define float @fabs_select_unknown(
; CHECK:    call float @llvm.fabs.f32(
; CHECK-NOT:  call {{.*}}@llvm.pisa.fabs
  %s = select i1 %c, float %x, float %y
  %r = call float @llvm.fabs.f32(float %s)
  ret float %r
}

; Def-side select: operand 1 (fadd) is provably non-SNaN, so the analysis
; evaluates operand 2, which is a plain argument -> false. fabs stays IEEE.
define float @fabs_select_mixed(i1 %c, float %a, float %b, float %y) {
; CHECK-LABEL: define float @fabs_select_mixed(
; CHECK:    call float @llvm.fabs.f32(
; CHECK-NOT:  call {{.*}}@llvm.pisa.fabs
  %sum = fadd float %a, %b
  %s = select i1 %c, float %sum, float %y
  %r = call float @llvm.fabs.f32(float %s)
  ret float %r
}

; Def-side insertelement: the base vector is a plain argument, so the first
; cannotBeSNaN short-circuits false. fabs stays IEEE.
define <2 x float> @fabs_insertelt_unknown(<2 x float> %v, float %x) {
; CHECK-LABEL: define <2 x float> @fabs_insertelt_unknown(
; CHECK:    call <2 x float> @llvm.fabs.v2f32(
; CHECK-NOT:  call {{.*}}@llvm.pisa.fabs
  %ie = insertelement <2 x float> %v, float %x, i32 0
  %r = call <2 x float> @llvm.fabs.v2f32(<2 x float> %ie)
  ret <2 x float> %r
}

; Def-side insertelement: the base vector is a non-signaling constant, so the
; first cannotBeSNaN is true and the analysis evaluates the inserted scalar,
; which is a plain argument -> false. fabs stays IEEE.
define <2 x float> @fabs_insertelt_const(float %x) {
; CHECK-LABEL: define <2 x float> @fabs_insertelt_const(
; CHECK:    call <2 x float> @llvm.fabs.v2f32(
; CHECK-NOT:  call {{.*}}@llvm.pisa.fabs
  %ie = insertelement <2 x float> <float 1.0, float 2.0>, float %x, i32 0
  %r = call <2 x float> @llvm.fabs.v2f32(<2 x float> %ie)
  ret <2 x float> %r
}

; Def-side: PISA fadd/fmul/frcp map to IEEE hardware ops that quiet NaN, so
; cannotBeSNaN is true through them and the fabs is rewritten.
define float @fabs_pisa_fadd(float %a, float %b) {
; CHECK-LABEL: define float @fabs_pisa_fadd(
; CHECK:    call float @llvm.pisa.fabs.f32(
; CHECK-NOT:  call {{.*}}@llvm.fabs.
  %p = call float @llvm.pisa.fadd.f32(float %a, float %b, i8 1, i1 false)
  %r = call float @llvm.fabs.f32(float %p)
  ret float %r
}

define float @fabs_pisa_fmul(float %a, float %b) {
; CHECK-LABEL: define float @fabs_pisa_fmul(
; CHECK:    call float @llvm.pisa.fabs.f32(
; CHECK-NOT:  call {{.*}}@llvm.fabs.
  %p = call float @llvm.pisa.fmul.f32(float %a, float %b, i8 1, i1 false)
  %r = call float @llvm.fabs.f32(float %p)
  ret float %r
}

define float @fabs_pisa_frcp(float %a) {
; CHECK-LABEL: define float @fabs_pisa_frcp(
; CHECK:    call float @llvm.pisa.fabs.f32(
; CHECK-NOT:  call {{.*}}@llvm.fabs.
  %p = call float @llvm.pisa.frcp.f32(float %a)
  %r = call float @llvm.fabs.f32(float %p)
  ret float %r
}

; Use-side default: the fabs result feeds llvm.sqrt, which is not on the
; SNaN-insensitive user list, so allUsesAreSNaNInsensitive is false and the
; fabs is left as IEEE fabs.
define float @fabs_used_by_sqrt(float %a) {
; CHECK-LABEL: define float @fabs_used_by_sqrt(
; CHECK:    call float @llvm.fabs.f32(
; CHECK-NOT:  call {{.*}}@llvm.pisa.fabs
  %f = call float @llvm.fabs.f32(float %a)
  %s = call float @llvm.sqrt.f32(float %f)
  ret float %s
}

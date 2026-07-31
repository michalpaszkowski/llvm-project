; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

declare double @llvm.log.f64(double)
declare double @llvm.log2.f64(double)
declare double @llvm.log10.f64(double)
declare double @llvm.exp.f64(double)
declare double @llvm.sin.f64(double)
declare double @llvm.cos.f64(double)
declare double @llvm.pow.f64(double, double)
declare double @llvm.powi.f64.i32(double, i32)

define double @test_log(double %a) {
  ; CHECK: PISA Verifier: Intrinsic llvm.log.f64 is not supported on the PISA target
  %result = call double @llvm.log.f64(double %a)
  ret double %result
}

define double @test_log2(double %a) {
  ; CHECK: PISA Verifier: Intrinsic llvm.log2.f64 is not supported on the PISA target
  %result = call double @llvm.log2.f64(double %a)
  ret double %result
}

define double @test_log10(double %a) {
  ; CHECK: PISA Verifier: Intrinsic llvm.log10.f64 is not supported on the PISA target
  %result = call double @llvm.log10.f64(double %a)
  ret double %result
}

define double @test_exp(double %a) {
  ; CHECK: PISA Verifier: Intrinsic llvm.exp.f64 is not supported on the PISA target
  %result = call double @llvm.exp.f64(double %a)
  ret double %result
}

define double @test_sin(double %a) {
  ; CHECK: PISA Verifier: Intrinsic llvm.sin.f64 is not supported on the PISA target
  %result = call double @llvm.sin.f64(double %a)
  ret double %result
}

define double @test_cos(double %a) {
  ; CHECK: PISA Verifier: Intrinsic llvm.cos.f64 is not supported on the PISA target
  %result = call double @llvm.cos.f64(double %a)
  ret double %result
}

define double @test_pow(double %a, double %b) {
  ; CHECK: PISA Verifier: Intrinsic llvm.pow.f64 is not supported on the PISA target
  %result = call double @llvm.pow.f64(double %a, double %b)
  ret double %result
}

define double @test_powi(double %a, i32 %b) {
  ; CHECK: PISA Verifier: Intrinsic llvm.powi.f64.i32 is not supported on the PISA target
  %result = call double @llvm.powi.f64.i32(double %a, i32 %b)
  ret double %result
}

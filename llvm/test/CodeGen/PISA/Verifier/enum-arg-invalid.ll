; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

; Test that verifyEnumArg catches an out-of-range enum argument.
; Covers PISAVerifier.cpp verifyEnumArg line 151:
;   if (Val > MaxVal)  <-- TRUE branch (invalid enum value)
;
; SHFLMode values: UP=0, DOWN=1, XOR=2, IDX=3  (Last=4, so MaxVal=3)
; Mode value 99 is out of range and should be rejected.

; CHECK: error: PISA Verifier: Intrinsic llvm.pisa.shfl has invalid shfl mode value 99

declare i32 @llvm.pisa.shfl(i8 immarg, i32, i32, i32, i32, i1 immarg)

define i32 @test_invalid_shfl_mode(i32 %val) {
  %rv = call i32 @llvm.pisa.shfl(i8 99, i32 %val, i32 0, i32 255, i32 poison, i1 false)
  ret i32 %rv
}

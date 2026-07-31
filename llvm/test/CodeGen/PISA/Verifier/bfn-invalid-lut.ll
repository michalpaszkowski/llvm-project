; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 | FileCheck %s

declare i32 @llvm.pisa.bfn.i32(i8 immarg, i32, i32, i32)

define i32 @test_bfn_invalid_lut_zero(i32 %s0, i32 %s1, i32 %s2) {
  ; CHECK: PISA Verifier: BFN operation 0x00 is invalid; valid range is 0x01 to 0xfe
  %val = call i32 @llvm.pisa.bfn.i32(i8 0, i32 %s0, i32 %s1, i32 %s2)
  ret i32 %val
}

define i32 @test_bfn_invalid_lut_ff(i32 %s0, i32 %s1, i32 %s2) {
  ; CHECK: PISA Verifier: BFN operation 0xff is invalid; valid range is 0x01 to 0xfe
  %val = call i32 @llvm.pisa.bfn.i32(i8 -1, i32 %s0, i32 %s1, i32 %s2)
  ret i32 %val
}

; This test validates function declaration and linkage printing
; RUN: llc < %s -march=pisa -verify-machineinstrs -o %t.pisa
; RUN: FileCheck %s < %t.pisa
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs

; CHECK: .import .function .32b @foo(.reg .32b);
declare i32 @foo(i32)

; CHECK: .export .function .32b @bar(.reg .32b %w{{[0-9]+}})
define i32 @bar(i32 %a) {
  ret i32 %a
}

; internal functions should not have linkage directive
; CHECK-NOT: .export
; CHECK-NOT: .import
; CHECK: @internalFunc
define internal i32 @internalFunc(i32 %a) {
  ret i32 %a
}

; CHECK: .function .32b [[NAME:@[_a-z0-9]+]](.reg .32b %w{{[0-9]+}})
define internal i32 @0(i32 %a) {
  ret i32 %a
}

; kernels should not have linkage directive
; CHECK-NOT: .import
; CHECK-NOT: .export
; CHECK: .kernel
define pisa_kernel void @test(i32 %in) {
  %res1 = call i32 @foo(i32 %in)
  %res2 = call i32 @bar(i32 %res1)
  %res3 = call i32 @internalFunc(i32 %res2)

  ; CHECK: call %w{{[0-9]+}}, [[NAME]] (%w{{[0-9]+}});
  %res4 = call i32 @0(i32 %res3)
  ret void
}

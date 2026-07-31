; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs


define pisa_kernel void @test_arg_name(ptr addrspace(1) %output, i32 %val) !kernel_arg_name !0 {
; CHECK-LABEL: @test_arg_name(
; CHECK-SAME: .param[8] .addrspace(global) %output
; CHECK-SAME: .param[4] .align(4) %val
; CHECK: ld.param.64b {{%[-a-zA-Z$._0-9]+}}, [%output];
; CHECK: ld.param.32b {{%[-a-zA-Z$._0-9]+}}, [%val];
; CHECK: return;
entry:
  store i32 %val, ptr addrspace(1) %output
  ret void
}
!0 = !{!"output", !"val"}

define pisa_kernel void @test_empty_arg_names(ptr addrspace(1) %0, i32 %1) !kernel_arg_name !1 {
; CHECK-LABEL: @test_empty_arg_names(
; CHECK-SAME: .param[8] .addrspace(global) %arg0
; CHECK-SAME: .param[4] .align(4) %arg1
; CHECK: return;
entry:
  ret void
}
!1 = !{!"", !""}


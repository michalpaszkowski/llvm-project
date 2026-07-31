; RUN: llc -o - %s -march=pisa -verify-machineinstrs -stop-after=irtranslator | FileCheck %s
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs
; Test checks that we don't create extra control flow for 'and', 'or' condition branches.

  define pisa_kernel void @test_bool(ptr addrspace(1) %out, i32 %c1, i32 %c2) local_unnamed_addr {
  entry:
    %cmp = icmp sgt i32 %c1, 0
    %cmp1 = icmp sgt i32 %c2, 0
    %and.cond = and i1 %cmp, %cmp1
    br i1 %and.cond, label %if.then, label %if.end

  if.then:                                          ; preds = %entry
    store i32 1, ptr addrspace(1) %out, align 4
    br label %if.end

  if.end:                                           ; preds = %if.then, %entry
    ret void
  }
; CHECK-LABEL:  bb.1.entry:
; CHECK:    G_BRCOND
; CHECK-NOT:    G_BRCOND


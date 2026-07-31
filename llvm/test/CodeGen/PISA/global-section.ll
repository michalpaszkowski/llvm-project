; The test checks if section attribute is respected for global variables
; RUN: llc < %s -march=pisa -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=pisa -verify-machineinstrs -O0 | FileCheck --check-prefix=O0 %s

; CHECK: .const .align 1 .section(".data.const.string") @.str1
@.str1 = internal unnamed_addr addrspace(2) constant [6 x i8] c"test1\00", section ".data.const.string", align 1
; CHECK: .const .align 1 .section(".some_section_name") @.str2
@.str2 = internal unnamed_addr addrspace(2) constant [6 x i8] c"test2\00", section ".some_section_name", align 1

define pisa_kernel void @test_section(ptr %output_buffer1, ptr %output_buffer2) {
; O0-LABEL: @test_section(
; O0-SAME: .param[8] [[PARAM_ARG0:%[-a-zA-Z$._0-9]+]]
; O0-SAME: .param[8] [[PARAM_ARG1:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .64b %d<0~18>;
; O0-NEXT: 	.reg .8b %b<0~16>;
; O0: 	ld.param.64b %d0, [[[PARAM_ARG0]]];
; O0-NEXT: 	ld.param.64b %d1, [[[PARAM_ARG1]]];
; O0-NEXT: 	addrof.64b %d2, @.str1;
; O0-NEXT: 	addrof.64b %d3, @.str2;
; O0-NEXT: 	trunc.8b.64b 	%b0, %d2;
; O0-NEXT: 	shr.64b 	%d4, %d2, 8;
; O0-NEXT: 	trunc.8b.64b 	%b1, %d4;
; O0-NEXT: 	shr.64b 	%d5, %d2, 16;
; O0-NEXT: 	trunc.8b.64b 	%b2, %d5;
; O0-NEXT: 	shr.64b 	%d6, %d2, 24;
; O0-NEXT: 	trunc.8b.64b 	%b3, %d6;
; O0-NEXT: 	shr.64b 	%d7, %d2, 32;
; O0-NEXT: 	trunc.8b.64b 	%b4, %d7;
; O0-NEXT: 	shr.64b 	%d8, %d2, 40;
; O0-NEXT: 	trunc.8b.64b 	%b5, %d8;
; O0-NEXT: 	shr.64b 	%d9, %d2, 48;
; O0-NEXT: 	trunc.8b.64b 	%b6, %d9;
; O0-NEXT: 	shr.64b 	%d10, %d2, 56;
; O0-NEXT: 	trunc.8b.64b 	%b7, %d10;
; O0-NEXT: 	st.generic.8b	 [%d0], %b0;
; O0-NEXT: 	st.generic.8b	 [%d0 + 1], %b1;
; O0-NEXT: 	st.generic.8b	 [%d0 + 2], %b2;
; O0-NEXT: 	st.generic.8b	 [%d0 + 3], %b3;
; O0-NEXT: 	st.generic.8b	 [%d0 + 4], %b4;
; O0-NEXT: 	st.generic.8b	 [%d0 + 5], %b5;
; O0-NEXT: 	st.generic.8b	 [%d0 + 6], %b6;
; O0-NEXT: 	st.generic.8b	 [%d0 + 7], %b7;
; O0-NEXT: 	trunc.8b.64b 	%b8, %d3;
; O0-NEXT: 	shr.64b 	%d11, %d3, 8;
; O0-NEXT: 	trunc.8b.64b 	%b9, %d11;
; O0-NEXT: 	shr.64b 	%d12, %d3, 16;
; O0-NEXT: 	trunc.8b.64b 	%b10, %d12;
; O0-NEXT: 	shr.64b 	%d13, %d3, 24;
; O0-NEXT: 	trunc.8b.64b 	%b11, %d13;
; O0-NEXT: 	shr.64b 	%d14, %d3, 32;
; O0-NEXT: 	trunc.8b.64b 	%b12, %d14;
; O0-NEXT: 	shr.64b 	%d15, %d3, 40;
; O0-NEXT: 	trunc.8b.64b 	%b13, %d15;
; O0-NEXT: 	shr.64b 	%d16, %d3, 48;
; O0-NEXT: 	trunc.8b.64b 	%b14, %d16;
; O0-NEXT: 	shr.64b 	%d17, %d3, 56;
; O0-NEXT: 	trunc.8b.64b 	%b15, %d17;
; O0-NEXT: 	st.generic.8b	 [%d1], %b8;
; O0-NEXT: 	st.generic.8b	 [%d1 + 1], %b9;
; O0-NEXT: 	st.generic.8b	 [%d1 + 2], %b10;
; O0-NEXT: 	st.generic.8b	 [%d1 + 3], %b11;
; O0-NEXT: 	st.generic.8b	 [%d1 + 4], %b12;
; O0-NEXT: 	st.generic.8b	 [%d1 + 5], %b13;
; O0-NEXT: 	st.generic.8b	 [%d1 + 6], %b14;
; O0-NEXT: 	st.generic.8b	 [%d1 + 7], %b15;
; O0-NEXT: 	return;
entry:
  %ptr_to_str1 = getelementptr inbounds [6 x i8], ptr addrspace(2) @.str1, i64 0, i64 0
  store ptr addrspace(2) %ptr_to_str1, ptr %output_buffer1, align 1

  %ptr_to_str2 = getelementptr inbounds [6 x i8], ptr addrspace(2) @.str2, i64 0, i64 0
  store ptr addrspace(2) %ptr_to_str2, ptr %output_buffer2, align 1
  ret void
}

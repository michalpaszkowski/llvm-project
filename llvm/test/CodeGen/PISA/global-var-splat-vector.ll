; Test that splat vector globals (ConstantFP/ConstantInt with vector types)
; are correctly lowered to individual scalar elements.
;
; RUN: llc < %s -march=pisa -verify-machineinstrs -use-constant-int-for-fixed-length-splat=true -o %t.pisa
; RUN: FileCheck %s < %t.pisa
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

; CHECK: .global .align 16 @splat_float4 = { .32b 0x3f800000, .32b 0x3f800000, .32b 0x3f800000, .32b 0x3f800000 };
; O0: .global .align 16 @splat_float4 = { .32b 0x3f800000, .32b 0x3f800000, .32b 0x3f800000, .32b 0x3f800000 };
@splat_float4 = internal addrspace(1) constant <4 x float> splat(float 1.0)

; CHECK: .global .align 8 @splat_float2 = { .32b 0x40000000, .32b 0x40000000 };
; O0: .global .align 8 @splat_float2 = { .32b 0x40000000, .32b 0x40000000 };
@splat_float2 = internal addrspace(1) constant <2 x float> splat(float 2.0)

; CHECK: .global .align 16 @splat_double2 = { .64b 0x40091eb851eb851f, .64b 0x40091eb851eb851f };
; O0: .global .align 16 @splat_double2 = { .64b 0x40091eb851eb851f, .64b 0x40091eb851eb851f };
@splat_double2 = internal addrspace(1) constant <2 x double> splat(double 3.14)

; CHECK: .global .align 16 @splat_half8 = { .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00 };
; O0: .global .align 16 @splat_half8 = { .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00, .16b 0x3c00 };
@splat_half8 = internal addrspace(1) constant <8 x half> splat(half 0xH3C00)

; CHECK: .global .align 8 @splat_bfloat4 = { .16b 0x3f80, .16b 0x3f80, .16b 0x3f80, .16b 0x3f80 };
; O0: .global .align 8 @splat_bfloat4 = { .16b 0x3f80, .16b 0x3f80, .16b 0x3f80, .16b 0x3f80 };
@splat_bfloat4 = internal addrspace(1) constant <4 x bfloat> splat(bfloat 0xR3F80)

; CHECK: .global .align 16 @splat_i32_4 = { .32b 0x2a, .32b 0x2a, .32b 0x2a, .32b 0x2a };
; O0: .global .align 16 @splat_i32_4 = { .32b 0x2a, .32b 0x2a, .32b 0x2a, .32b 0x2a };
@splat_i32_4 = internal addrspace(1) constant <4 x i32> splat(i32 42)

; CHECK: .global .align 16 @splat_i16_8 = { .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7 };
; O0: .global .align 16 @splat_i16_8 = { .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7, .16b 0x7 };
@splat_i16_8 = internal addrspace(1) constant <8 x i16> splat(i16 7)

; CHECK-LABEL: .export .function .32b @test
define i32 @test() addrspace(2) {
; O0-LABEL: .32b @test(
; O0: 	.reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]];
; O0: 	addrof.64b [[R64_D0]], @splat_float4;
; O0-NEXT: 	ld.global.32b	 [[R32_W0]], [[[R64_D0]]];
; O0-NEXT: 	return [[R32_W0]];
  %v = load i32, ptr addrspace(1) @splat_float4
  ret i32 %v
}

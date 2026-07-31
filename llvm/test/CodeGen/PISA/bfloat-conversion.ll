; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs
; RUN: llc < %s -march=pisa -verify-machineinstrs -o %t.pisa
; RUN: FileCheck %s < %t.pisa

define bfloat @u8_to_bf(i8 %u8) {
; CHECK-LABEL: .16b @u8_to_bf(
; CHECK-SAME: .reg .8b [[R8_B0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.u8 	[[R16_H0]], [[R8_B0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = uitofp i8 %u8 to bfloat
  ret bfloat %result
}

define bfloat @s8_to_bf(i8 %s8) {
; CHECK-LABEL: .16b @s8_to_bf(
; CHECK-SAME: .reg .8b [[R8_B0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.s8 	[[R16_H0]], [[R8_B0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = sitofp i8 %s8 to bfloat
  ret bfloat %result
}

define bfloat @u16_to_bf(i16 %u16) {
; CHECK-LABEL: .16b @u16_to_bf(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H1:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.u16 	[[R16_H1]], [[R16_H0]];
; CHECK-NEXT: 	return [[R16_H1]];
  %result = uitofp i16 %u16 to bfloat
  ret bfloat %result
}

define bfloat @s16_to_bf(i16 %s16) {
; CHECK-LABEL: .16b @s16_to_bf(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H1:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.s16 	[[R16_H1]], [[R16_H0]];
; CHECK-NEXT: 	return [[R16_H1]];
  %result = sitofp i16 %s16 to bfloat
  ret bfloat %result
}

define bfloat @u32_to_bf(i32 %u32) {
; CHECK-LABEL: .16b @u32_to_bf(
; CHECK-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.u32 	[[R16_H0]], [[R32_W0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = uitofp i32 %u32 to bfloat
  ret bfloat %result
}

define bfloat @s32_to_bf(i32 %s32) {
; CHECK-LABEL: .16b @s32_to_bf(
; CHECK-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.s32 	[[R16_H0]], [[R32_W0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = sitofp i32 %s32 to bfloat
  ret bfloat %result
}

define bfloat @u64_to_bf(i64 %u64) {
; CHECK-LABEL: .16b @u64_to_bf(
; CHECK-SAME: .reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.u64 	[[R16_H0]], [[R64_D0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = uitofp i64 %u64 to bfloat
  ret bfloat %result
}

define bfloat @s64_to_bf(i64 %s64) {
; CHECK-LABEL: .16b @s64_to_bf(
; CHECK-SAME: .reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	i2f.bf.s64 	[[R16_H0]], [[R64_D0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = sitofp i64 %s64 to bfloat
  ret bfloat %result
}

define i8 @bf_to_u8(bfloat %bf) {
; CHECK-LABEL: .8b @bf_to_u8(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .8b [[R8_B0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.u8.bf 	[[R8_B0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R8_B0]];
  %result = fptoui bfloat %bf to i8
  ret i8 %result
}

define i8 @bf_to_s8(bfloat %bf) {
; CHECK-LABEL: .8b @bf_to_s8(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .8b [[R8_B0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.s8.bf 	[[R8_B0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R8_B0]];
  %result = fptosi bfloat %bf to i8
  ret i8 %result
}

define i16 @bf_to_u16(bfloat %bf) {
; CHECK-LABEL: .16b @bf_to_u16(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H1:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.u16.bf 	[[R16_H1]], [[R16_H0]];
; CHECK-NEXT: 	return [[R16_H1]];
  %result = fptoui bfloat %bf to i16
  ret i16 %result
}

define i16 @bf_to_s16(bfloat %bf) {
; CHECK-LABEL: .16b @bf_to_s16(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H1:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.s16.bf 	[[R16_H1]], [[R16_H0]];
; CHECK-NEXT: 	return [[R16_H1]];
  %result = fptosi bfloat %bf to i16
  ret i16 %result
}

define i32 @bf_to_u32(bfloat %bf) {
; CHECK-LABEL: .32b @bf_to_u32(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.u32.bf 	[[R32_W0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R32_W0]];
  %result = fptoui bfloat %bf to i32
  ret i32 %result
}

define i32 @bf_to_s32(bfloat %bf) {
; CHECK-LABEL: .32b @bf_to_s32(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.s32.bf 	[[R32_W0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R32_W0]];
  %result = fptosi bfloat %bf to i32
  ret i32 %result
}

define i64 @bf_to_u64(bfloat %bf) {
; CHECK-LABEL: .64b @bf_to_u64(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.u64.bf 	[[R64_D0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R64_D0]];
  %result = fptoui bfloat %bf to i64
  ret i64 %result
}

define i64 @bf_to_s64(bfloat %bf) {
; CHECK-LABEL: .64b @bf_to_s64(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	f2i.s64.bf 	[[R64_D0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R64_D0]];
  %result = fptosi bfloat %bf to i64
  ret i64 %result
}

define bfloat @bfptrunc_f32(float %a) {
; CHECK-LABEL: .16b @bfptrunc_f32(
; CHECK-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	ftrunc.bf.f 	[[R16_H0]], [[R32_W0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = fptrunc float %a to bfloat
  ret bfloat %result
}

define bfloat @bfptrunc_f64(double %a) {
; CHECK-LABEL: .16b @bfptrunc_f64(
; CHECK-SAME: .reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	ftrunc.bf.df 	[[R16_H0]], [[R64_D0]];
; CHECK-NEXT: 	return [[R16_H0]];
  %result = fptrunc double %a to bfloat
  ret bfloat %result
}

define float @bfext_f32(bfloat %a) {
; CHECK-LABEL: .32b @bfext_f32(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	fext.f.bf 	[[R32_W0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R32_W0]];
  %result = fpext bfloat %a to float
  ret float %result
}

define double @bfext_f64(bfloat %a) {
; CHECK-LABEL: .64b @bfext_f64(
; CHECK-SAME: .reg .16b [[R16_H0:%[-a-zA-Z$._0-9]+]]
; CHECK: 	.reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]];
; CHECK: 	fext.df.bf 	[[R64_D0]], [[R16_H0]];
; CHECK-NEXT: 	return [[R64_D0]];
  %result = fpext bfloat %a to double
  ret double %result
}

define half @bf_hf_imm() {
entry:
  %result = bitcast bfloat 0xR3CC3 to half
  ret half %result
}

define bfloat @hf_bf_imm() {
entry:
  %result = bitcast half 0xH3CC3 to bfloat
  ret bfloat %result
}


; This test checks global variables lowering and decl printing
; RUN: llc < %s -march=pisa -verify-machineinstrs -o %t.pisa
; RUN: FileCheck %s < %t.pisa
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs

; CHECK-LABEL: .import .function void @"\01?decl_func@@YAXXZ"()
declare void @"\01?decl_func@@YAXXZ"()

; CHECK: .import .global .align 4 @gvar[4];
@gvar = external addrspace(1) global i32

; CHECK: .import .global .align 4 @gvararray[16384];
@gvararray = external addrspace(1) global [4096 x i32]

; CHECK: .export .const .align 4 @cvar = { .32b 0x5 };
@cvar = addrspace(2) constant i32 5

; CHECK: .export .const .align 16 @cvector = { .32b 0x3, .32b 0x2, .32b 0x1, .zero 4 };
@cvector = addrspace(2) constant <4 x i32> <i32 3, i32 2, i32 1, i32 0>

; CHECK: .global .align 4 @carray = { .32b 0x3, .32b 0x2, .32b 0x1, .zero 4 };
@carray = internal addrspace(1) constant [4 x i32] [i32 3, i32 2, i32 1, i32 0]

; CHECK: .global .align 2 @bfloatval = { .16b 0x1234 };
@bfloatval = internal addrspace(1) constant bfloat 0xR1234

; CHECK: .global .align 2 @halfval = { .16b 0x3c00 };
@halfval = internal addrspace(1) constant half 0xH3C00

; CHECK: .global .align 4 @farray = { .32b 0x3f800000, .32b 0x40000000, .32b 0x40400000, .32b 0x40800000 };
@farray = internal addrspace(1) constant [4 x float] [float 1.0, float 2.0, float 3.0, float 4.0]

; CHECK: .global .align 8 @doublearray = { .64b 0x3ff0000000000000, .64b 0x4000000000000000, .64b 0x4008000000000000, .64b 0x4010000000000000 };
@doublearray = internal addrspace(1) constant [4 x double] [double 1.0, double 2.0, double 3.0, double 4.0], align 8

; CHECK: .global .align 256 @zarray = { .zero 40 };
@zarray = internal addrspace(1) constant [10 x i32] zeroinitializer, align 256

; CHECK: .global .align 32 @zvector = { .zero 32 };
@zvector = internal addrspace(1) constant <8 x i32> zeroinitializer

; CHECK: .global .align 2 @igvar = { .16b 0x64 };
@igvar = internal addrspace(1) global i16 100

; CHECK: .global .align 8 @igvar64 = { .64b 0x20 };
@igvar64 = internal addrspace(1) global i64 32

%struct.S1 = type { i16, i32 }
; CHECK: .const .align 16 @S1 = { .16b 0x3, .zero 2, .32b 0x9 };
@S1 = internal addrspace(2) constant %struct.S1 { i16 3, i32 9 }, align 16

%struct.S1Packed = type <{ i16, i32 }>
; CHECK: .const .align 8 @S1Packed = { .16b 0x3, .32b 0x9 };
@S1Packed = internal addrspace(2) constant %struct.S1Packed <{ i16 3, i32 9 }>

%struct.S2Array = type { [3 x i32], [2 x i32] }

%struct.complex = type { %struct.S1, i8, <2 x float>, %struct.S1Packed, %struct.S2Array }
; CHECK: .const .align 16 @Complex = { .16b 0x1, .zero 2, .32b 0x3, .8b 0x2a, .zero 7, .32b 0x3f800000, .32b 0x40000000, .16b 0x7, .32b 0x8, .zero 2, .32b 0xb, .32b 0xc, .32b 0xd, .32b 0xe, .32b 0xf, .zero 4 };
@Complex = internal addrspace(2) constant %struct.complex { %struct.S1 { i16 1, i32 3 }, i8 42,
                                                            <2 x float> <float 1.0, float 2.0>,
                                                            %struct.S1Packed <{ i16 7, i32 8 }>,
                                                            %struct.S2Array { [3 x i32] [i32 11, i32 12, i32 13], [2 x i32] [i32 14, i32 15] } }

; CHECK: .const .align 16 @Vec3 = { .32b 0x1, .32b 0x2, .32b 0x3, .zero 4 };
@Vec3 = internal addrspace(2) constant <3 x i32> <i32 1, i32 2, i32 3>

; CHECK: .const .align 16 @NestedArray = { .32b 0x1, .32b 0x2, .32b 0x3, .32b 0x4, .32b 0x5, .32b 0x6 };
@NestedArray = internal addrspace(2) constant [2 x [3 x i32]] [[3 x i32] [i32 1, i32 2, i32 3], [3 x i32] [i32 4, i32 5, i32 6]]

%struct.nulls = type { i32, i16, ptr addrspace(1) }
; CHECK: .const .align 8 @Nulls = { .zero 16 };
@Nulls = internal addrspace(2) constant %struct.nulls { i32 undef, i16 poison, ptr addrspace(1) null }

; CHECK: .const .align 1 [[NAME0:@[_a-z0-9]+]] = { .zero 8 };
@0 = internal unnamed_addr addrspace(2) constant [8 x i8] zeroinitializer
; CHECK: .const .align 1 [[NAME1:@[_a-z0-9]+]] = { .zero 4 };
@1 = internal unnamed_addr addrspace(2) constant [4 x i8] zeroinitializer

; CHECK: .global .align 1 @BoolGVar = { .8b 0x1 };
@BoolGVar = internal addrspace(1) global i1 true
; CHECK: .global .align 1 @BoolGVarArray = { .8b 0x1, .zero 3, .8b 0x1, .8b 0x1, .zero 1, .8b 0x1 };
@BoolGVarArray = internal addrspace(1) global [8 x i1] [i1 true, i1 false, i1 false, i1 false, i1 true, i1 true, i1 false, i1 true]

%struct.Foo = type { [4 x i32] }
%struct.Bar = type { ptr addrspace(1), i32 }

; CHECK: .global .align 4 @foo = { .32b 0x1, .32b 0x2, .32b 0x3, .32b 0x4 };
@foo = internal addrspace(1) global %struct.Foo { [4 x i32] [i32 1, i32 2, i32 3, i32 4] }, align 4
; CHECK: .global .align 8 @bar = { .64b @foo+8, .32b 0x3, .zero 4 };
@bar = internal addrspace(1) global %struct.Bar { ptr addrspace(1) getelementptr (i8, ptr addrspace(1) @foo, i64 8), i32 3 }, align 8
; CHECK: .global .align 8 @single = { .64b @foo, .32b 0x4, .zero 4 };
@single = internal addrspace(1) global %struct.Bar { ptr addrspace(1) @foo, i32 4 }, align 8

; CHECK: .global .align 16 @ManyGlobals = { .64b @zarray, .64b @zvector, .64b @gvararray+32, .64b @farray+4 };
@ManyGlobals = internal addrspace(1) constant [4 x ptr addrspace(1)] [ptr addrspace(1) @zarray,
                                                                      ptr addrspace(1) @zvector,
                                                                      ptr addrspace(1) getelementptr (i8, ptr addrspace(1) @gvararray, i64 32),
                                                                      ptr addrspace(1) getelementptr (i8, ptr addrspace(1) @farray, i64 4)]

; CHECK: .const .align 8 @UnnamedRefs = { .64b [[NAME0]], .64b [[NAME1]] };
@UnnamedRefs = internal addrspace(2) constant [2 x ptr addrspace(2)] [ptr addrspace(2) @0, ptr addrspace(2) @1]

; CHECK: .global .align 4 @ZeroInt = { .zero 4, .32b 0x3 };
@ZeroInt = internal addrspace(1) global [2 x i32] [i32 0, i32 3]

; CHECK: .global .align 4 @ZeroFloat = { .zero 4, .32b 0x40400000 };
@ZeroFloat = internal addrspace(1) global [2 x float] [float 0.0, float 3.0]

; CHECK: .global .align 8 @ZeroPointer = { .zero 8, .64b @zarray };
@ZeroPointer = internal addrspace(1) global [2 x ptr addrspace(1)] [ptr addrspace(1) null, ptr addrspace(1) @zarray]

declare void @declfunc(i32 %arg) addrspace(2)

; CHECK: .global .align 8 @FuncPointers = { .64b @test, .64b @declfunc };
@FuncPointers = internal addrspace(1) global [2 x ptr addrspace(2)] [ptr addrspace(2) @test, ptr addrspace(2) @declfunc]

%struct.Pointers = type <{ ptr addrspace(4), ptr addrspace(1), ptr addrspace(2), ptr addrspace(3), ptr, i32 }>

; CHECK: .export .global .align 16 @NullPointers = { .32b 0xffffffff, .zero 16, .32b 0xffffffff, .zero 8, .32b 0x5 };
@NullPointers = addrspace(1) global %struct.Pointers <{ ptr addrspace(4) null, ptr addrspace(1) null, ptr addrspace(2) null, ptr addrspace(3) null, ptr null, i32 5 }>

; .global .align 1 @Neg8b = { .8b 0xff, .8b 0xfe, .8b 0xfd, .8b 0xfc };
@Neg8b = internal addrspace(1) global [4 x i8] [i8 -1, i8 -2, i8 -3, i8 -4]

; CHECK: .global .align 2 @Neg16b = { .16b 0xffff, .16b 0xfffe, .16b 0xfffd, .16b 0xfffc };
@Neg16b = internal addrspace(1) global [4 x i16] [i16 -1, i16 -2, i16 -3, i16 -4]

; CHECK: .global .align 4 @Neg32b = { .32b 0xffffffff, .32b 0xfffffffe, .32b 0xfffffffd, .32b 0xfffffffc };
@Neg32b = internal addrspace(1) global [4 x i32] [i32 -1, i32 -2, i32 -3, i32 -4]

; CHECK: .global .align 16 @Neg64b = { .64b 0xffffffffffffffff, .64b 0xfffffffffffffffe, .64b 0xfffffffffffffffd, .64b 0xfffffffffffffffc };
@Neg64b = internal addrspace(1) global [4 x i64] [i64 -1, i64 -2, i64 -3, i64 -4]

; CHECK: .global .align 16 @UninitInternal[32768];
@UninitInternal = internal addrspace(1) global [4096 x i64] undef

; CHECK: .export .global .align 16 @UninitDefault[32768];
@UninitDefault = addrspace(1) global [4096 x i64] undef

; CHECK: .export .global .align 4 @"Test_\01?MyGlobal@@YAXXZ"[4];
@"Test_\01?MyGlobal@@YAXXZ" = addrspace(1) global i32 undef

; CHECK: .import .global .align 4 @"\01?MyGlobal@@YAXXZ"[4];
@"\01?MyGlobal@@YAXXZ" = external addrspace(1) global i32

; CHECK: .export .global .align 4 .host_access("global_var_uid") @global_var = { .32b 0x2a };
@global_var = addrspace(1) global i32 42, align 4, !intel_host_access !0
; CHECK: .export .const .align 4 .host_access("const_global_var_uid") @const_global_var = { .32b 0x64 };
@const_global_var = addrspace(2) constant i32 100, align 4, !intel_host_access !1

; CHECK-NOT: .global
; @llvm.used should not be emitted
@llvm.used = appending global [1 x ptr] [ptr addrspacecast (ptr addrspace(2) @cvar to ptr)]
; variables in the "llvm.metadata" section should not be emitted
@llvm.compiler.used = appending global [1 x ptr] [ptr addrspacecast (ptr addrspace(1) @igvar64 to ptr)], section "llvm.metadata"

; CHECK-LABEL: .export .function .32b @test
define i32 @test(i32 %arg) addrspace(2) {
; CHECK: addrof.64b [[PTR1:%d[0-9]+]], @gvar;
; CHECK: addrof.64b [[PTR2:%d[0-9]+]], @cvar;
; CHECK: addrof.64b [[PTR3:%d[0-9]+]], @carray;
; CHECK: addrof.64b [[UPTR0:%d[0-9]+]], [[NAME0]];
; CHECK: addrof.64b [[UPTR1:%d[0-9]+]], [[NAME1]];

; CHECK: ld.global.32b [[RET:%w[0-9]+]], [[[PTR1]]]
  %gvarval = load i32, i32 addrspace(1)* @gvar

; CHECK: ld.const.32b [[STVAL:%w[0-9]+]], [[[PTR2]]]
  %cvarval = load i32, i32 addrspace(2)* @cvar

; CHECK: st.global.32b [[[PTR3]] + 12], [[STVAL]]
  %stptr = getelementptr [4 x i32], [4 x i32] addrspace(1)* @carray, i32 0, i32 3
  store i32 %cvarval, ptr addrspace(1) %stptr

; CHECK: ld.const.32b [[USTVAL0:%w[0-9]+]], [[[UPTR0]]]
  %zeroval0 = load i32, i32 addrspace(2)* @0
; CHECK: st.global.32b [[[PTR3]] + 12], [[USTVAL0]]
  store i32 %zeroval0, ptr addrspace(1) %stptr
; CHECK: ld.const.32b [[USTVAL1:%w[0-9]+]], [[[UPTR1]]]
  %zeroval1 = load i32, i32 addrspace(2)* @1
; CHECK: st.global.32b [[[PTR3]] + 12], [[USTVAL1]]
  store i32 %zeroval1, ptr addrspace(1) %stptr

; CHECK: return [[RET]]
  ret i32 %gvarval
}

; COM: globals should only be printed once at the beginning of the module
; CHECK-NOT: .global

define i32 @test2(i32 %arg) addrspace(2) {
; CHECK: addrof.64b [[PTR:%d[0-9]+]], @cvar;
; CHECK: ld.const.32b {{%w[0-9]+}}, [[[PTR]]]
  %cvarval = load i32, i32 addrspace(2)* @cvar
  ret i32 %cvarval
}

; CHECK-LABEL: .export .function void @"\01?my_func@@YAXXZ"
define void @"\01?my_func@@YAXXZ"() {
; CHECK: addrof.64b {{%d[0-9]+}}, @"\01?MyGlobal@@YAXXZ";
  store i32 0, ptr addrspace(1) @"\01?MyGlobal@@YAXXZ"
; CHECK: addrof.64b {{%d[0-9]+}}, @"Test_\01?MyGlobal@@YAXXZ";
  store i32 0, ptr addrspace(1) @"Test_\01?MyGlobal@@YAXXZ"
  ret void
}

!0 = !{i32 3, !"global_var_uid"}
!1 = !{i32 3, !"const_global_var_uid"}

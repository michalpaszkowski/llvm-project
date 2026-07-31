; RUN: llc < %s -march=pisa -verify-machineinstrs \
; RUN: | FileCheck %s --implicit-check-not=.import --implicit-check-not=.export

; Verify how LLVM function linkages are translated to PISA.
; PISA only has module local, and externally visible linkage,
; thus the semantics of other linkages are not preserved.

; .import marks declarations, .export marks definitions of externally visible functions,
; while no annotation means module local functions.

; CHECK: .import .function void @extern_func();
declare void @extern_func()

; CHECK: .import .function void @extern_weak_func();
declare extern_weak void @extern_weak_func()

; CHECK: .function void @private_func()
define private void @private_func() {
  ret void
}

; CHECK: .function void @internal_func()
define internal void @internal_func() {
  ret void
}

; CHECK-NOT: .function
; available_externally functions should not be emitted at all
define available_externally void @available_externally_func() {
  ret void
}

; CHECK: .export .function void @linkonce_func()
define linkonce void @linkonce_func() {
  ret void
}

; CHECK: .export .function void @linkonce_odr_func()
define linkonce_odr void @linkonce_odr_func() {
  ret void
}

; CHECK: .export .function void @weak_func()
define weak void @weak_func() {
  ret void
}

; CHECK: .export .function void @weak_odr_func()
define weak_odr void @weak_odr_func() {
  ret void
}

; CHECK: .export .function void @exported_func()
define void @exported_func() {
  ret void
}

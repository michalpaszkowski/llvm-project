; RUN: llc < %s -march=pisa -verify-machineinstrs -o %t.pisa
; RUN: FileCheck %s < %t.pisa

;; --- LLVM IR tests: address-space casts that roundtrip through .pisa. ---

; CHECK-LABEL: @global_to_generic_store
define void @global_to_generic_store(ptr addrspace(1) %gptr, i32 %val) {
; O0-LABEL: void @global_to_generic_store(
; O0-SAME: .reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]]
; O0-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .64b [[R64_D1:%[-a-zA-Z$._0-9]+]];
; O0: 	addrcast.generic.global 	[[R64_D1]], [[R64_D0]];
; O0-NEXT: 	st.generic.32b	 [[[R64_D1]]], [[R32_W0]];
; O0-NEXT: 	return;
;
; CHECK: addrcast.generic.global
; CHECK: st.generic.32b
  %genptr = addrspacecast ptr addrspace(1) %gptr to ptr
  store i32 %val, ptr %genptr
  ret void
}

; CHECK-LABEL: @global_to_generic_to_global
define void @global_to_generic_to_global(ptr addrspace(1) %gptr, i32 %val) {
; O0-LABEL: void @global_to_generic_to_global(
; O0-SAME: .reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]]
; O0-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .64b [[R64_D1:%[-a-zA-Z$._0-9]+]], [[R64_D2:%[-a-zA-Z$._0-9]+]];
; O0: 	addrcast.generic.global 	[[R64_D1]], [[R64_D0]];
; O0-NEXT: 	st.generic.32b	 [[[R64_D1]]], [[R32_W0]];
; O0-NEXT: 	addrcast.global.generic 	[[R64_D2]], [[R64_D1]];
; O0-NEXT: 	st.global.32b	 [[[R64_D2]]], [[R32_W0]];
; O0-NEXT: 	return;
;
; CHECK: addrcast.generic.global
; CHECK: st.generic.32b
; CHECK: addrcast.global.generic
; CHECK: st.global.32b
  %genptr = addrspacecast ptr addrspace(1) %gptr to ptr
  store i32 %val, ptr %genptr
  %gptr2 = addrspacecast ptr %genptr to ptr addrspace(1)
  store i32 %val, ptr addrspace(1) %gptr2
  ret void
}

; CHECK-LABEL: @shared_to_generic_store
define void @shared_to_generic_store(ptr addrspace(3) %sptr, i32 %val) {
; O0-LABEL: void @shared_to_generic_store(
; O0-SAME: .reg .32b [[R32_W0:%[-a-zA-Z$._0-9]+]]
; O0-SAME: .reg .32b [[R32_W1:%[-a-zA-Z$._0-9]+]]
; O0: 	.reg .32b [[R32_W2:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.reg .64b [[R64_D0:%[-a-zA-Z$._0-9]+]], [[R64_D1:%[-a-zA-Z$._0-9]+]], [[R64_D2:%[-a-zA-Z$._0-9]+]];
; O0-NEXT: 	.pred [[P_P0:%[-a-zA-Z$._0-9]+]];
; O0: 	mov.32b 	[[R32_W2]], -1;
; O0-NEXT: 	mov.64b 	[[R64_D0]], 0;
; O0-NEXT: 	addrcast.generic.shared 	[[R64_D1]], [[R32_W0]];
; O0-NEXT: 	ucmp.ne.32b 	[[P_P0]], [[R32_W0]], [[R32_W2]];
; O0-NEXT: 	sel.64b 	[[R64_D2]], [[R64_D1]], [[R64_D0]], [[P_P0]];
; O0-NEXT: 	st.generic.32b	 [[[R64_D2]]], [[R32_W1]];
; O0-NEXT: 	return;
;
; CHECK: addrcast.generic.shared
; CHECK: st.generic.32b
  %genptr = addrspacecast ptr addrspace(3) %sptr to ptr
  store i32 %val, ptr %genptr
  ret void
}

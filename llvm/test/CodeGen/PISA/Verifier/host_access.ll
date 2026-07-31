; RUN: not llc -march=pisa -stop-after=pisa-verifier -o /dev/null %s 2>&1 \
; RUN: | FileCheck %s --implicit-check-not="PISA Verifier:"

; CHECK: PISA Verifier: !intel_host_access metadata must have exactly 2 operands
@gv_wrong_operands_1 = addrspace(1) global i32 0, !intel_host_access !0

; CHECK: PISA Verifier: !intel_host_access metadata must have exactly 2 operands
@gv_wrong_operands_3 = addrspace(1) global i32 0, !intel_host_access !1

; CHECK: PISA Verifier: Host access mode (first operand) of !intel_host_access metadata must be a 32-bit integer in the range [0, 3].
@gv_first_not_int = addrspace(1) constant i32 0, !intel_host_access !2

; CHECK: PISA Verifier: Host access mode (first operand) of !intel_host_access metadata must be a 32-bit integer in the range [0, 3].
@gv_first_wrong_width = addrspace(1) global i32 0, !intel_host_access !3

; CHECK: PISA Verifier: Host access mode (first operand) of !intel_host_access metadata must be a 32-bit integer in the range [0, 3].
@gv_first_out_of_range = addrspace(1) constant i32 0, !intel_host_access !4

; CHECK: PISA Verifier: Host name (second operand) of !intel_host_access metadata must be a string.
@gv_second_not_string = addrspace(1) global i32 0, !intel_host_access !5

; CHECK: PISA Verifier: Host access name 'duplicate_name' is specified for more than one global variable
@gv_duplicate_1 = addrspace(1) constant i32 0, !intel_host_access !6
@gv_duplicate_2 = addrspace(1) constant i32 0, !intel_host_access !7

; CHECK: PISA Verifier: !intel_host_access metadata attached more than once to global 'gv_attached_twice'
@gv_attached_twice = addrspace(1) global i32 0, !intel_host_access !8, !intel_host_access !9

; No errors (verifier should accept correct usage).
@gv_ok_1 = addrspace(1) global i32 0, !intel_host_access !10

!0 = !{i32 0}
!1 = !{i32 0, !"name", i32 1}
!2 = !{!"not_an_int", !"name1"}
!3 = !{i64 0, !"name2"}
!4 = !{i32 4, !"name3"}
!5 = !{i32 0, i32 42}
!6 = !{i32 1, !"duplicate_name"}
!7 = !{i32 2, !"duplicate_name"}
!8 = !{i32 3, !"attached_twice"}
!9 = !{i32 3, !"attached_twice"}
!10 = !{i32 2, !"unique_name"}

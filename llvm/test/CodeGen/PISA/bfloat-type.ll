; RUN: llc < %s -march=pisa -o %t.pisa 2>%t || true; FileCheck --allow-empty %s < %t
; CHECK-NOT: UNREACHABLE

define void @bfloat_formal_arg(bfloat %a) {
  ret void
}

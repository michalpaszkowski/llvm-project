; RUN: llc < %s -march=pisa -o %t.pisa
; RUN: FileCheck %s < %t.pisa --check-prefixes=FADD
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

; FADD-LABEL: @test_fadd32_ftz
; O0-LABEL: @test_fadd32_ftz
; FADD:       fadd.ftz.f [[RES:%w[0-9]+]], %w{{[0-9]+}}, %w{{[0-9]+}}
; O0:       fadd.ftz.f [[RES:%w[0-9]+]], %w{{[0-9]+}}, %w{{[0-9]+}}
; FADD-NEXT:  return [[RES]]
; O0-NEXT:  return [[RES]]

; GMIR-LABEL: name: test_fadd32_ftz
; GMIR:       [[RES:%[0-9]+]]:_(f32) = G_FADD %{{[0-9]+}}, %{{[0-9]+}}
; GMIR-NEXT:  %{{[0-9]+}}:_(f32) = G_INTRINSIC intrinsic(@llvm.pisa.assign.ftz), [[RES]](f32)

define float @test_fadd32_ftz(float %a, float %b) #0 {
  %result = fadd float %a, %b
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }


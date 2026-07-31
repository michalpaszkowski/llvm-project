; RUN: llc < %s -march=pisa -o %t.pisa
; RUN: FileCheck %s < %t.pisa --check-prefixes=FADD
; RUN: llc < %s -march=pisa -O0 -verify-machineinstrs | FileCheck --check-prefix=O0 %s

declare double @llvm.experimental.constrained.fadd.f64(double, double, metadata, metadata) #1
declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata) #1
declare half @llvm.experimental.constrained.fadd.f16(half, half, metadata, metadata) #1

; FADD-LABEL: @test_fadd32_rnd_ftz
; O0-LABEL: @test_fadd32_rnd_ftz
; FADD:        fadd.ru.ftz.f [[RES:%w[0-9]+]], %w{{[0-9]+}}, %w{{[0-9]+}}
; O0:        fadd.ru.ftz.f [[RES:%w[0-9]+]], %w{{[0-9]+}}, %w{{[0-9]+}}
; FADD-NEXT:   return [[RES]]
; O0-NEXT:   return [[RES]]

; GMIR-LABEL: name: test_fadd32_rnd_ftz
; GMIR:       [[ADDRND:%[0-9]+]]:_(f32) = G_INTRINSIC intrinsic(@llvm.pisa.fadd), %{{[0-9]+}}(f32), %{{[0-9]+}}(f32), 2, 0
; GMIR-NEXT:  %{{[0-9]+}}:_(f32) = G_INTRINSIC intrinsic(@llvm.pisa.assign.ftz), [[ADDRND]](f32)

define float @test_fadd32_rnd_ftz(float %a, float %b) #0 {
  %result = call float @llvm.experimental.constrained.fadd.f32(
                        float %a, float %b,
                        metadata !"round.upward",
                        metadata !"fpexcept.ignore") #1
  ret float %result
}

attributes #0 = { denormal_fpenv(preservesign) }
attributes #1 = { strictfp }



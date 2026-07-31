; RUN: not --crash llc < %s -march=pisa 2>&1 | FileCheck %s

; CHECK: unknown special variable with appending linkage
@foo = appending constant [1 x i32] zeroinitializer

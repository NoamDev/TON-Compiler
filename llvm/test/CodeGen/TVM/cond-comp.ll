; RUN: llc < %s -march=tvm | FileCheck %s
define i64 @cond_comp(i64 %sel, i64 %par) nounwind {
  switch i64 %sel, label %bb3 [ i64 0, label %bb1
                                i64 1, label %bb2 ]
; CHECK:	PUSHINT	1
; CHECK-NEXT:	PUSH	s2
; CHECK-NEXT:	PUSH	s1
; CHECK-NEXT:	LESS
; CHECK-NEXT:	PUSHCONT 
; CHECK-NEXT:		POP	s0
; CHECK-NEXT:		PUSHINT	0
; CHECK-NEXT:		XCHG	s1, s2
; CHECK-NEXT:		NEQ
; CHECK-NEXT:		PUSHCONT 
; CHECK-NEXT:			PUSH	s0
; CHECK-NEXT:			PUSH	s0
; CHECK-NEXT:			MUL 
; CHECK-NEXT:			MUL 
; CHECK-NEXT:			RET
; CHECK-NEXT:		}
; CHECK-NEXT:		IFJMP
; CHECK-NEXT:		PUSHCONT 
; CHECK:		JMPX
; CHECK:	IFJMP
; CHECK-NEXT:	PUSHCONT 
; CHECK-NEXT:		XCHG	s1, s2
; CHECK-NEXT:		EQUAL
; CHECK-NEXT:		PUSHCONT 
; CHECK-NEXT:			PUSH	s0
; CHECK-NEXT:			MUL 
; CHECK-NEXT:			RET
; CHECK:		IFJMP
; CHECK-NEXT:		PUSHCONT 
; CHECK-NEXT:			PUSH	s0
; CHECK-NEXT:			PUSH	s0
; CHECK-NEXT:			MUL 
; CHECK-NEXT:			MUL 
; CHECK-NEXT:			RET
; CHECK:		JMPX
; CHECK:	JMPX
bb1:
  %1 = add i64 0, %par
  br label %exit
bb2:
  %2 = mul i64 %par, %par
  ret i64 %2
bb3:
  %3 = mul i64 %par, %par
  %4 = mul i64 %3, %par
  ret i64 %4 
exit:
  ret i64 %1
}

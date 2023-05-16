global _sum, _sub, _mul, _div

_sum:
    ; Args:
    ;   AX: value1
    ;   BX: value2
    ;   DI: Must point to result word
    MOV     [DI],AX
    ADD     [DI],BX
    RET

_sub:
    ; Args:
    ;   AX: value1
    ;   BX: value2
    ;   DI: Must point to result word
    MOV     [DI],AX
    SUB     [DI],BX
    RET

_mul:
    ; Args:
    ;   AX: value1
    ;   BX: value2
    ;   DI: Must point to result word
    IMUL    BX
    MOV     [DI],AX
    RET

_div:
    ; Args:
    ;   AX: value1
    ;   BX: value2
    ;   DI: Must point to result word
    CWD
    IDIV    BX
    MOV     [DI],AX
    RET
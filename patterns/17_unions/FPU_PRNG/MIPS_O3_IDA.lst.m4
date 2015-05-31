include(`commons.m4')float_rand:

var_10          = -0x10
var_4           = -4

                lui     $gp, (__gnu_local_gp >> 16)
                addiu   $sp, -0x20
                la      $gp, (__gnu_local_gp & 0xFFFF)
                sw      $ra, 0x20+var_4($sp)
                sw      $gp, 0x20+var_10($sp)
; _EN(`call')_RU(`вызвать') my_rand():
                jal     my_rand
                or      $at, $zero ; branch delay slot, NOP
; $v0=_EN(`32-bit pseudorandom value')_RU(`32-битное псевдослучайное значение')
                li      $v1, 0x7FFFFF
; $v1=0x7FFFFF
                and     $v1, $v0, $v1
; $v1=_EN(`pseudorandom value')_RU(`псевдослучайное значение') & 0x7FFFFF
                lui     $a0, 0x3F80
; $a0=0x3F800000
                or      $v1, $a0
; $v1=_EN(`pseudorandom value')_RU(`псевдослучайное значение') & 0x7FFFFF | 0x3F800000
; _EN(`matter of the following instruction is still hard to get:')_RU(`смысл этой инструкции всё так же трудно понять:')
                lui     $v0, ($LC0 >> 16)
; _EN(`load 1.0 into')_RU(`загрузить 1.0 в') $f0:
                lwc1    $f0, $LC0
; _EN(`move value from \$v1 to coprocessor 1 (into register \$f2)')_RU(`скопировать значение из \$v1 в первый сопроцессор (в регистр \$f2)')
; _EN(``it behaves like bitwise copy, no conversion done:'')_RU(``это работает как побитовая копия, без всякого конвертирования'')
                mtc1    $v1, $f2
                lw      $ra, 0x20+var_4($sp)
; _EN(`subtract 1.0. leave result in \$f0:')_RU(`вычесть 1.0. оставить результат в \$f0:')
                sub.s   $f0, $f2, $f0
                jr      $ra
                addiu   $sp, 0x20  ; branch delay slot

main:

var_18          = -0x18
var_10          = -0x10
var_C           = -0xC
var_8           = -8
var_4           = -4

                lui     $gp, (__gnu_local_gp >> 16)
                addiu   $sp, -0x28
                la      $gp, (__gnu_local_gp & 0xFFFF)
                sw      $ra, 0x28+var_4($sp)
                sw      $s2, 0x28+var_8($sp)
                sw      $s1, 0x28+var_C($sp)
                sw      $s0, 0x28+var_10($sp)
                sw      $gp, 0x28+var_18($sp)
                lw      $t9, (time & 0xFFFF)($gp)
                or      $at, $zero ; load delay slot, NOP
                jalr    $t9
                move    $a0, $zero ; branch delay slot
                lui     $s2, ($LC1 >> 16)  # "%f\n"
                move    $a0, $v0
                la      $s2, ($LC1 & 0xFFFF)  # "%f\n"
                move    $s0, $zero
                jal     my_srand
                li      $s1, 0x64  # 'd' ; branch delay slot

loc_104:
                jal     float_rand
                addiu   $s0, 1
                lw      $gp, 0x28+var_18($sp)
; _EN(`convert value we got from float\_rand() to double type (printf() need it):')_RU(`сконвертировать полученное из float\_rand() значение в тип double (для printf()):')
                cvt.d.s $f2, $f0
                lw      $t9, (printf & 0xFFFF)($gp)
                mfc1    $a3, $f2
                mfc1    $a2, $f3
                jalr    $t9
                move    $a0, $s2
                bne     $s0, $s1, loc_104
                move    $v0, $zero
                lw      $ra, 0x28+var_4($sp)
                lw      $s2, 0x28+var_8($sp)
                lw      $s1, 0x28+var_C($sp)
                lw      $s0, 0x28+var_10($sp)
                jr      $ra
                addiu   $sp, 0x28 ; branch delay slot

$LC1:           .ascii "%f\n"<0>
$LC0:           .float 1.0

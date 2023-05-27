@echo off
nasm16 -f obj -o OBJ\plot_xy.obj -l LST\plot_xy.lst asm-calc\plot_xy.asm
nasm16 -f obj -o OBJ\caracter.obj -l LST\caracter.lst asm-calc\caracter.asm
nasm16 -f obj -o OBJ\cursor.obj -l LST\cursor.lst asm-calc\cursor.asm
nasm16 -f obj -o OBJ\circle.obj -l LST\circle.lst asm-calc\circle.asm
nasm16 -f obj -o OBJ\fcircle.obj -l LST\fcircle.lst asm-calc\fcircle.asm
nasm16 -f obj -o OBJ\line.obj -l LST\line.lst asm-calc\line.asm
nasm16 -f obj -o OBJ\math.obj -l LST\math.lst asm-calc\math.asm
nasm16 -f obj -o OBJ\gui.obj -l LST\gui.lst asm-calc\gui.asm
nasm16 -f obj -o OBJ\input.obj -l LST\input.lst asm-calc\input.asm
nasm16 -f obj -o OBJ\print.obj -l LST\print.lst asm-calc\print.asm
nasm16 -f obj -o OBJ\main.obj -l LST\main.lst asm-calc\main.asm
freelink obj\main obj\math obj\print obj\input obj\gui obj\line obj\fcircle obj\circle obj\cursor obj\caracter obj\plot_xy,o
echo "\n"
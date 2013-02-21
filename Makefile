routines.c : routines.f
	f2c routines.f

routines.o : routines.c
	gcc -fPIC -c routines.c

cclib : routines.o
	gcc -shared -o lbfgsb.so routines.o -lf2c

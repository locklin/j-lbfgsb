NB. lbfgsb 

NB.
NB.     Subroutine setulb
NB.    call convention:
NB.   call setulb(n,m,x,l,u,nbd,f,g,factr,pgtol,wa,iwa,task,iprint, csave,lsave,isave,dsave)
NB.     This subroutine partitions the working arrays wa and iwa, and
NB.       then uses the limited memory BFGS method to solve the bound
NB.       constrained optimization problem by calling mainlb.
NB.       (The direct method will be used in the subspace minimization.)
NB.
NB.     n is an integer variable.
NB.       On entry n is the dimension of the problem.
NB.       On exit n is unchanged.
NB.
NB.     m is an integer variable.
NB.       On entry m is the maximum number of variable metric corrections
NB.         used to define the limited memory matrix.
NB.       On exit m is unchanged.
NB.
NB.     x is a double precision array of dimension n.
NB.       On entry x is an approximation to the solution.
NB.       On exit x is the current approximation.
NB.
NB.     l is a double precision array of dimension n.
NB.       On entry l is the lower bound on x.
NB.       On exit l is unchanged.
NB.
NB.     u is a double precision array of dimension n.
NB.       On entry u is the upper bound on x.
NB.       On exit u is unchanged.
NB.
NB.     nbd is an integer array of dimension n.
NB.       On entry nbd represents the type of bounds imposed on the
NB.         variables, and must be specified as follows:
NB.         nbd(i)=0 if x(i) is unbounded,
NB.                1 if x(i) has only a lower bound,
NB.                2 if x(i) has both lower and upper bounds, and
NB.                3 if x(i) has only an upper bound.
NB.       On exit nbd is unchanged.
NB.
NB.     f is a double precision variable.
NB.       On first entry f is unspecified.
NB.       On final exit f is the value of the function at x.
NB.
NB.     g is a double precision array of dimension n.
NB.       On first entry g is unspecified.
NB.       On final exit g is the value of the gradient at x.
NB.
NB.     factr is a double precision variable.
NB.       On entry factr >= 0 is specified by the user.  The iteration
NB.         will stop when
NB.
NB.         (f^k - f^{k+1})/max{|f^k|,|f^{k+1}|,1} <= factr*epsmch
NB.
NB.         where epsmch is the machine precision, which is automatically
NB.         generated by the code. Typical values for factr: 1.d+12 for
NB.         low accuracy; 1.d+7 for moderate accuracy; 1.d+1 for extremely
NB.         high accuracy.
NB.       On exit factr is unchanged.
NB.
NB.     pgtol is a double precision variable.
NB.       On entry pgtol >= 0 is specified by the user.  The iteration
NB.         will stop when
NB.
NB.                 max{|proj g_i | i = 1, ..., n} <= pgtol
NB.
NB.         where pg_i is the ith component of the projected gradient.
NB.       On exit pgtol is unchanged.
NB.
NB.     wa is a double precision working array of length
NB.       (2mmax + 4)nmax + 12mmax^2 + 12mmax.
NB.
NB.     iwa is an integer working array of length 3nmax.
NB.
NB.     task is a working string of characters of length 60 indicating
NB.       the current job when entering and quitting this subroutine.
NB.
NB.     iprint is an integer variable that must be set by the user.
NB.       It controls the frequency and type of output generated:
NB.        iprint<0    no output is generated;
NB.        iprint=0    print only one line at the last iteration;
NB.        0<iprint<99 print also f and |proj g| every iprint iterations;
NB.        iprint=99   print details of every iteration except n-vectors;
NB.        iprint=100  print also the changes of active set and final x;
NB.        iprint>100  print details of every iteration including x and g;
NB.       When iprint > 0, the file iterate.dat will be created to
NB.                        summarize the iteration.
NB.
NB.     csave is a working string of characters of length 60.
NB.
NB.     lsave is a logical working array of dimension 4.
NB.       On exit with 'task' = NEW_X, the following information is
NB.                                                             available:
NB.         If lsave(1) = .true.  then  the initial X has been replaced by
NB.                                     its projection in the feasible set;
NB.         If lsave(2) = .true.  then  the problem is constrained;
NB.         If lsave(3) = .true.  then  each variable has upper and lower
NB.                                     bounds;
NB.
NB.     isave is an integer working array of dimension 44.
NB.       On exit with 'task' = NEW_X, the following information is
NB.                                                             available:
NB.         isave(22) = the total number of intervals explored in the
NB.                         search of Cauchy points;
NB.         isave(26) = the total number of skipped BFGS updates before
NB.                         the current iteration;
NB.         isave(30) = the number of current iteration;
NB.         isave(31) = the total number of BFGS updates prior the current
NB.                         iteration;
NB.         isave(33) = the number of intervals explored in the search of
NB.                         Cauchy point in the current iteration;
NB.         isave(34) = the total number of function and gradient
NB.                         evaluations;
NB.         isave(36) = the number of function value or gradient
NB.                                  evaluations in the current iteration;
NB.         if isave(37) = 0  then the subspace argmin is within the box;
NB.         if isave(37) = 1  then the subspace argmin is beyond the box;
NB.         isave(38) = the number of free variables in the current
NB.                         iteration;
NB.         isave(39) = the number of active constraints in the current
NB.                         iteration;
NB.         n + 1 - isave(40) = the number of variables leaving the set of
NB.                           active constraints in the current iteration;
NB.         isave(41) = the number of variables entering the set of active
NB.                         constraints in the current iteration.
NB.
NB.     dsave is a double precision working array of dimension 29.
NB.       On exit with 'task' = NEW_X, the following information is
NB.                                                             available:
NB.         dsave(1) = current 'theta' in the BFGS matrix;
NB.         dsave(2) = f(x) in the previous iteration;
NB.         dsave(3) = factr*epsmch;
NB.         dsave(4) = 2-norm of the line search direction vector;
NB.         dsave(5) = the machine precision epsmch generated by the code;
NB.         dsave(7) = the accumulated time spent on searching for
NB.                                                         Cauchy points;
NB.         dsave(8) = the accumulated time spent on
NB.                                                 subspace minimization;
NB.         dsave(9) = the accumulated time spent on line search;
NB.         dsave(11) = the slope of the line search function at
NB.                                  the current point of line search;
NB.         dsave(12) = the maximum relative step length imposed in
NB.                                                           line search;
NB.         dsave(13) = the infinity norm of the projected gradient;
NB.         dsave(14) = the relative step length in the line search;
NB.         dsave(15) = the slope of the line search function at
NB.                                 the starting point of the line search;
NB.         dsave(16) = the square of the 2-norm of the line search
NB.                                                      direction vector.
NB.
NB.     Subprograms called:
NB.
NB.       L-BFGS-B Library ... mainlb.
NB.
NB.
NB.     References:
NB.
NB.       [1] R. H. Byrd, P. Lu, J. Nocedal and C. Zhu, ``A limited
NB.       memory algorithm for bound constrained optimization'',
NB.       SIAM J. Scientific Computing 16 (1995), no. 5, pp. 1190--1208.
NB.
NB.       [2] C. Zhu, R.H. Byrd, P. Lu, J. Nocedal, ``L-BFGS-B: a
NB.       limited memory FORTRAN code for solving bound constrained
NB.       optimization problems'', Tech. Report, NAM-11, EECS Department,
NB.       Northwestern University, 1994.
NB.
NB.       (Postscript files of these papers are available via anonymous
NB.        ftp to eecs.nwu.edu in the directory pub/lbfgs/lbfgs_bcm.)
NB.
NB.                           *  *  *
NB.
NB.     NEOS, November 1994. (Latest revision June 1996.)
NB.     Optimization Technology Center.
NB.     Argonne National Laboratory and Northwestern University.
NB.     Written by
NB.                        Ciyou Zhu
NB.     in collaboration with R.H. Byrd, P. Lu-Chen and J. Nocedal.













NB. path=: jpath '~addons/math/lbfgs/'

3 : 0''
if. UNAME-:'Linux' do.
  DLL=: jpath'~temp/lbfgsb.so'
elseif. UNAME-:'Darwin' do.
  DLL=: '"',~'"',jpath '~temp/lbfgsb.dylib'
elseif. do.
  DLL=: 'windows is out of luck'
end.
)

NB. =========================================================
call=: 4 : 0
xx=. DLL,x,' + i ',(+:#y)$' *'
r=. xx cd LASTIN=: , each y
if. > {. r do.
  error x;'lbfgsb dll return code: ',": > {. r
else.
  LASTOUT=: }.r
end.
)

NB. =========================================================
NB. error - display message and signal error
error=: 3 : 0
wdinfo y
error=. 13!:8@1:
error ''
)

NB. =========================================================
NB. lbfgsb_test - run test case using the lbgfs routine.
NB. the function being evaluated makes no sense to me...
optim_test=: 3 : 0
NDIM=. 2000
MSAVE=. 7
X=. G=. NDIM$2.2-2.2
N=.,100
M=.,5
DIAGCO=. ,2-2

ICALL=. 0
IFLAG=. ,2-2
LB=. ,N $ -100.3
UB=. ,N $ 300.1
NBH=. ,N $ 0 2 NB. set 0 for unbounded (same as lbfgs), 1 for lower, 2 for both, 3 for upper
FACTR=. 1.1 NB. high precision
PGTOL=. ,2.2-2.2
WA=. ,(2*MSAVE*NDIM+4*NDIM+12*MSAVE*MSAVE+12*MSAVE) $ (2.2-2.2)
IWA=. ,(3*NDIM) $ 0-0
TASK=. ,'START',(55 $ ' ')
IPRINT=. 2 2-2 2 NB. set to 101.1 to dump all kinds of data to the screen
CSAVE=. ,60 $ ' '
LSAVE=. ,4 $ 2-2
ISAVE=. ,44 $ 2-2
DSAVE=. ,29 $ 2.2-2.2

for_JJ. 2*i. -:N do.
 X=. (_1.2e0 1.0e0) (JJ+0 1)}X
end.
while. 1 do.
 F=. ,0.0e0
 for_J. 2*i. -:N do.
  T1=. 1.0e0-J{X
  T2=. 1.0e1*((J+1){X)-*:J{X
  G=. (2.0e1*T2) (J+1)}G
  G=. (_2.0e0*(((J{X)*((J+1){G))+T1)) J}G
  F=. F+(*:T1)+*:T2
 end.
 'N M X LB UB NBH F G FACTR PGTOL WA IWA TASK IPRINT CSAVE LSAVE ISAVE DSAVE'=.r=.' setulb_' call (N;M;X;LB;UB;NBH;F;G;FACTR;PGTOL;WA;IWA;TASK;IPRINT;CSAVE;LSAVE;ISAVE;DSAVE)
 
state=. (0,1){TASK
 NB. if. IFLAG<:0 NB. ((state e. 'FG') OR (state e. 'NE')) do. break. end.
  ICALL=. 1+ICALL 
 if. ((ICALL > 2000) OR (state e. 'ST')) do. break. end.
end.
(ICALL;TASK;state),r
)

#include "fintrf.h"
C
#if 0
C     generate with :  mex mkcurvec.f curvec.f
C
C     curvec.f
C     .F file needs to be preprocessed to generate .for equivalent
C
#endif
C
C     curvec.f
C
C     multiple the first input by the second input

C     This is a MEX file for MATLAB.
C     Copyright 1984-2004 The MathWorks, Inc.
C     $Revision: 406 $

      subroutine mexFunction(nlhs, plhs, nrhs, prhs)
C-----------------------------------------------------------------------
C     (pointer) Replace integer by integer*8 on 64-bit platforms
C

C      mwpointer plhs(*), prhs(*)
C      mwpointer mxCreateDoubleMatrix
C      mwpointer mxGetPr
C      mwpointer x2_pr,y2_pr,x1_pr,y1_pr,u_pr,v_pr
C      mwpointer dt_pr,nt_pr,hdtck_pr,arthck_pr,xp_pr,yp_pr

C-----------------------------------------------------------------------
C
      integer plhs(*), prhs(*)

      integer nlhs, nrhs

      integer mxCreateDoubleMatrix, mxGetPr
      integer mxGetM, mxGetN

      integer x1_pr
      integer y1_pr
      integer x2_pr
      integer y2_pr
      integer a_pr
      integer finv_pr
      integer lonf_pr
      integer fe_pr
      integer latf_pr
      integer fn_pr
      integer lat1_pr
      integer lat2_pr
      integer iopt_pr

      integer m1,n1,np,iopt1

      real*8, dimension(:),   allocatable ::  x1
      real*8, dimension(:),   allocatable ::  y1
      real*8, dimension(:),   allocatable ::  x2
      real*8, dimension(:),   allocatable ::  y2

      real*8 a
      real*8 finv
      real*8 lato
      real*8 lono
      real*8 fe
      real*8 fn
      real*8 ko
      real*8 iopt

      m1 = mxGetM(prhs(1))
      n1 = mxGetN(prhs(1))

      np=n1*m1

      allocate(x1(1:np))
      allocate(y1(1:np))
      allocate(x2(1:np))
      allocate(y2(1:np))

C     Create matrix for the return argument.
      plhs(1) = mxCreateDoubleMatrix(m1,n1,0)
      plhs(2) = mxCreateDoubleMatrix(m1,n1,0)

      x1_pr   = mxGetPr(prhs(1))
      y1_pr   = mxGetPr(prhs(2))
      a_pr    = mxGetPr(prhs(3))
      finv_pr = mxGetPr(prhs(4))
      lato_pr = mxGetPr(prhs(5))
      lono_pr = mxGetPr(prhs(6))
      fe_pr   = mxGetPr(prhs(7))
      fn_pr   = mxGetPr(prhs(8))
      ko_pr   = mxGetPr(prhs(9))
      iopt_pr = mxGetPr(prhs(10))

      x2_pr    = mxGetPr(plhs(1))
      y2_pr    = mxGetPr(plhs(2))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(x1_pr,x1,np)
      call mxCopyPtrToReal8(y1_pr,y1,np)
      call mxCopyPtrToReal8(a_pr,a,1)
      call mxCopyPtrToReal8(finv_pr,finv,1)
      call mxCopyPtrToReal8(lato_pr,lato,1)
      call mxCopyPtrToReal8(lono_pr,lono,1)
      call mxCopyPtrToReal8(fe_pr,fe,1)
      call mxCopyPtrToReal8(fn_pr,fn,1)
      call mxCopyPtrToReal8(ko_pr,ko,1)
      call mxCopyPtrToReal8(iopt_pr,iopt,1)

      iopt1=int(iopt)

C     Call the computational subroutine
      call lcc1sp(x1,y1,x2,y2,a,finv,lato,lono,fe,fn,ko,                       &
     &            iopt1,np)

C     Load the output into a MATLAB array.
      call mxCopyReal8ToPtr(x2,x2_pr,np)
      call mxCopyReal8ToPtr(y2,y2_pr,np)

      deallocate(x1)
      deallocate(y1)

      return
      end


      subroutine lcc1sp(x1,y1,x2,y2,a,finv,lato,lono,fe,fn,                    &
     &                  ko,iopt,n1)

      integer i
      integer iopt
      integer n1

      real*8 x1(n1)
      real*8 y1(n1)
      real*8 x2(n1)
      real*8 y2(n1)
      real*8 finv
      real*8 a
      real*8 lono
      real*8 fe
      real*8 lato
      real*8 fn
      real*8 f
      real*8 e
      real*8 e2
      real*8 mo
      real*8 to
      real*8 n
      real*8 lon
      real*8 lat
      real*8 east
      real*8 north
      real*8 t
      real*8 r
      real*8 theta
      real*8 rac
      real*8 tac
      real*8 thetaac
      real*8 ro
      real*8 ko

      real*8 pi

      pi = 3.141592653589793
     
      f=1/finv
      e2=2*f-f**2
      e=sqrt(e2)

      n = sin(lato)
      mo = cos(lato)/(1.0 - e**2 * (sin(lato))**2)**0.5
      to = tan(pi/4.0 - lato/2.0)/((1.0 - e * sin(lato))/                      &
     &     (1.0 + e * sin(lato)))**(e/2.0)

      F = mo/(n*to**n)

      ro = a*F*to**n

      do i = 1,n1
         if (iopt==1) then

c           geo2xy

            lon=x1(i)
            lat=y1(i)

            t  = tan(pi/4.0 - lat /2.0)/((1.0 - e * sin(lat ))/                &
     &           (1.0 + e * sin(lat )))**(e/2.0)
            r  = a*F*t**n

            theta = n*(lon - lono)


            x2(i) = fe - r*sin(theta)
            y2(i) = fn + ro - r*cos(theta)

         else

c           xy2geo

            east=x1(i)
            north=y1(i)

            rac = ((fe - east)**2 + (ro - (north - fn))**2)**0.5

            if (n < 0) then
               rac=-rac
            endif

            tac = (rac/(a*ko*F))**(1/n)
            thetaac = atan((fe - east)/(ro - (north - fn)))

            y2(i) = pi/2.0 - 2.0*atan(tac*((1.0 - e*sin(lat))/                  &
     &              (1.0 + e*sin(lat)))**(e/2.0))
            x2(i) = thetaac/n + lono

         endif
      enddo

      end

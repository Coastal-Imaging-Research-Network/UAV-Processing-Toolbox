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
      integer*8 plhs(*), prhs(*)

      integer*8 nlhs, nrhs

      integer*8 mxCreateDoubleMatrix, mxGetPr
      integer*8 mxGetM, mxGetN

      integer*8 x1_pr
      integer*8 y1_pr
      integer*8 x2_pr
      integer*8 y2_pr
      integer*8 a_pr
      integer*8 finv_pr
      integer*8 lonf_pr
      integer*8 fe_pr
      integer*8 latf_pr
      integer*8 fn_pr
      integer*8 lat1_pr
      integer*8 lat2_pr
      integer*8 iopt_pr

      integer m1,n1,np,iopt1

      real*8, dimension(:),   allocatable ::  x1
      real*8, dimension(:),   allocatable ::  y1
      real*8, dimension(:),   allocatable ::  x2
      real*8, dimension(:),   allocatable ::  y2

      real*8 a
      real*8 finv
      real*8 lonf
      real*8 fe
      real*8 latf
      real*8 fn
      real*8 lat1
      real*8 lat2
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
      lonf_pr = mxGetPr(prhs(5))
      fe_pr   = mxGetPr(prhs(6))
      latf_pr = mxGetPr(prhs(7))
      fn_pr   = mxGetPr(prhs(8))
      lat1_pr = mxGetPr(prhs(9))
      lat2_pr = mxGetPr(prhs(10))
      iopt_pr = mxGetPr(prhs(11))

      x2_pr    = mxGetPr(plhs(1))
      y2_pr    = mxGetPr(plhs(2))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(x1_pr,x1,np)
      call mxCopyPtrToReal8(y1_pr,y1,np)
      call mxCopyPtrToReal8(a_pr,a,1)
      call mxCopyPtrToReal8(finv_pr,finv,1)
      call mxCopyPtrToReal8(lonf_pr,lonf,1)
      call mxCopyPtrToReal8(fe_pr,fe,1)
      call mxCopyPtrToReal8(latf_pr,latf,1)
      call mxCopyPtrToReal8(fn_pr,fn,1)
      call mxCopyPtrToReal8(lat1_pr,lat1,1)
      call mxCopyPtrToReal8(lat2_pr,lat2,1)
      call mxCopyPtrToReal8(iopt_pr,iopt,1)

      iopt1=int(iopt)

C     Call the computational subroutine
      call lcc2sp(x1,y1,x2,y2,a,finv,lonf,fe,latf,fn,lat1,                     &
     &            lat2,iopt1,np)

C     Load the output into a MATLAB array.
      call mxCopyReal8ToPtr(x2,x2_pr,np)
      call mxCopyReal8ToPtr(y2,y2_pr,np)

      deallocate(x1)
      deallocate(y1)

      return
      end


      subroutine lcc2sp(x1,y1,x2,y2,a,finv,lonf,fe,latf,fn,                    &
     &                  lat1,lat2,iopt,n1)

      integer i
      integer iopt
      integer n1

      real*8 x1(n1)
      real*8 y1(n1)
      real*8 x2(n1)
      real*8 y2(n1)
      real*8 finv
      real*8 a
      real*8 lonf
      real*8 fe
      real*8 latf
      real*8 fn
      real*8 lat1
      real*8 lat2
      real*8 f
      real*8 e
      real*8 e2
      real*8 m1
      real*8 m2
      real*8 t1
      real*8 t2
      real*8 tf
      real*8 n
      real*8 rf
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
      real*8 alpha

      real*8 pi

      pi = 3.141592653589793
      alpha=pi*(29.2985/3600.0)/180.0

      f=1/finv
      e2=2*f-f**2
      e=sqrt(e2)

      if (abs(0.5*pi-latf)<0.001) then
         latf = 0.5*pi
      endif

      m1 = cos(lat1)/(1.0 - e**2 * (sin(lat1))**2)**0.5
      m2 = cos(lat2)/(1.0 - e**2 * (sin(lat2))**2)**0.5
      t1 = tan(pi/4.0 - lat1/2.0)/((1.0 - e * sin(lat1))/                      &
     &     (1.0 + e * sin(lat1)))**(e/2.0)
      t2 = tan(pi/4.0 - lat2/2.0)/((1.0 - e * sin(lat2))/                      &
     &     (1.0 + e * sin(lat2)))**(e/2.0)

      tf = tan(pi/4.0 - latf/2.0)/((1.0 - e * sin(latf))/                      &
     &     (1.0 + e * sin(latf)))**(e/2.0)

      n = (log(m1) - log(m2))/(log(t1) - log(t2))
      F = m1/(n*t1**n)


      rf = a*F*tf**n

c      rf=0.0

      do i = 1,n1
         if (iopt==1) then

c           geo2xy

            lon=x1(i)
            lat=y1(i)

            t  = tan(pi/4.0 - lat /2.0)/((1.0 - e * sin(lat ))/                &
     &           (1.0 + e * sin(lat )))**(e/2.0)

            r  = a*F*t**n

            theta = n*(lon - lonf)

            x2(i) = fe + r*sin(theta - alpha)
            y2(i) = fn + rf - r*cos(theta - alpha)

         else

c           xy2geo

            east=x1(i)
            north=y1(i)

            rac = ((east - fe)**2 + (rf - (north - fn))**2)**0.5

            if (n<0) then
               rac = -rac
            endif

            tac = (rac/(a*F))**(1/n)
            thetaac = atan((east - fe)/(rf - (north - fn)))

            y2(i) = pi/2.0 - 2.0*atan(tac*((1.0 - e*sin(lat))/                  &
     &              (1.0 + e*sin(lat)))**(e/2.0))
            x2(i) = (thetaac + alpha)/n + lonf

         endif
      enddo

      end

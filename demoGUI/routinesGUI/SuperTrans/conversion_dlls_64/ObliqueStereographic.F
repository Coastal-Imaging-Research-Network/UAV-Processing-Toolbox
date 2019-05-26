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
      integer*8 k0_pr
      integer*8 fe_pr
      integer*8 fn_pr
      integer*8 lat0_pr
      integer*8 lon0_pr
      integer*8 iopt_pr
 
      integer m1,n1,np,iopt1

      real*8, dimension(:),   allocatable ::  x1
      real*8, dimension(:),   allocatable ::  y1
      real*8, dimension(:),   allocatable ::  x2
      real*8, dimension(:),   allocatable ::  y2

      real*8 a
      real*8 finv
      real*8 k0
      real*8 fe
      real*8 fn
      real*8 lat0
      real*8 lon0
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
      k0_pr   = mxGetPr(prhs(5))
      fe_pr   = mxGetPr(prhs(6))
      fn_pr   = mxGetPr(prhs(7))
      lat0_pr = mxGetPr(prhs(8))
      lon0_pr = mxGetPr(prhs(9))
      iopt_pr = mxGetPr(prhs(10))

      x2_pr    = mxGetPr(plhs(1))
      y2_pr    = mxGetPr(plhs(2))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(x1_pr,x1,np)
      call mxCopyPtrToReal8(y1_pr,y1,np)
      call mxCopyPtrToReal8(a_pr,a,1)
      call mxCopyPtrToReal8(finv_pr,finv,1)
      call mxCopyPtrToReal8(k0_pr,k0,1)
      call mxCopyPtrToReal8(fe_pr,fe,1)
      call mxCopyPtrToReal8(fn_pr,fn,1)
      call mxCopyPtrToReal8(lat0_pr,lat0,1)
      call mxCopyPtrToReal8(lon0_pr,lon0,1)
      call mxCopyPtrToReal8(iopt_pr,iopt,1)

      iopt1=int(iopt)
      
C     Call the computational subroutine
      call obls(x1,y1,x2,y2,a,finv,k0,fe,fn,lat0,lon0,                          &
     &                        iopt1,np)
      
C     Load the output into a MATLAB array.

      call mxCopyReal8ToPtr(x2,x2_pr,np)
      call mxCopyReal8ToPtr(y2,y2_pr,np)

      deallocate(x1)
      deallocate(y1)
      
      return
      end


      subroutine obls(x1,y1,x2,y2,a,finv,k0,fe,fn,                              &
     &                              lat0,lon0,iopt,n1)
      
      integer i
      integer iopt
      integer n1

      real*8 x1(n1)
      real*8 y1(n1)
      real*8 x2(n1)
      real*8 y2(n1)
      real*8 f
      real*8 finv
      real*8 a
      real*8 k0
      real*8 fe
      real*8 fn
      real*8 lat0
      real*8 lon0

      real*8 pi
      
      real*8 e
      real*8 e2
      real*8 rho0
      real*8 nu0
      real*8 R
      real*8 n
      real*8 S1
      real*8 S2
      real*8 w1
      real*8 chi0
      real*8 c
      real*8 w2
      real*8 lambda0
      real*8 lon
      real*8 lat
      real*8 Sa
      real*8 Sb
      real*8 w
      real*8 chi
      real*8 B
      real*8 east
      real*8 north
      real*8 g
      real*8 h
      real*8 ii
      real*8 jj
      real*8 lambda
      real*8 psi
      real*8 lati
      real*8 psii
      real*8 latip1

      pi = 3.141592654

      f = 1.0/finv
      e2 = 2.0*f-f**2
      e=sqrt(e2)

      rho0=(a*(1.0 - e**2))/(1.0 - e**2*(sin(lat0))**2)**1.5
      nu0=a/sqrt(1.0 - e2*(sin(lat0))**2)
      R= sqrt( rho0 * nu0)
      n=  sqrt(1.0 + (e2*(cos(lat0))**4/(1.0 - e2)))
      S1 = (1.0 + sin(lat0))/(1.0 - sin(lat0))
      S2 = (1.0 - e*sin(lat0))/(1.0 + e*sin(lat0))
      w1 = (S1*S2**e)**n
      chi0 = asin((w1-1)/(w1+1))
      c =  ((n+sin(lat0))*(1.0 - sin(chi0)))/((n - sin(lat0))*                       &
     &     (1.0 + sin(chi0)))
      w2 = c*(S1*(S2)**e)**n
      chi0 = asin((w2 - 1.0)/(w2 + 1.0))
      lambda0  = lon0

      do i=1,n1
      
         if (iopt==1) then
c           geo2xy
            lon=x1(i)
            lat=y1(i)
            lambda = n*(lon - lambda0) + lambda0
            Sa = (1.0 + sin(lat))/(1.0 - sin(lat))
            Sb = (1.0 - e*sin(lat))/(1.0 + e*sin(lat))
            w = c*(Sa*(Sb)**e)**n
            chi = asin((w - 1.0)/(w + 1.0))
            B = (1.0 + sin(chi)*sin(chi0) + cos(chi)*cos(chi0)*                      &
     &          cos(lambda - lambda0))
            x2(i) = FE + 2.0*R*k0*cos(chi)*sin(lambda-lambda0)/B
            y2(i) = FN + 2.0*R*k0*(sin(chi)*cos(chi0) -                              &
     &              cos(chi)*sin(chi0)*cos(lambda - lambda0))/B
         else
c           xy2geo
            east=x1(i)
            north=y1(i)
            g = 2.0*R*k0*tan(pi/4.0 - chi0/2.0)
            h = 4.0*R*k0*tan(chi0) + g
            ii = atan((east - FE) / (h + (north - FN)))
            jj = atan((east - FE) / (g - (north - FN))) - ii
            chi = chi0 + 2.0*atan(((north - FN) -                                    &
     &            (east - FE)*tan(jj/2.0))/(2.0*R*k0))
            lambda = jj + 2.0*ii + lambda0
            lon = (lambda-lambda0 ) / n + lambda0
            psi = 0.5*log ((1.0 + sin(chi)) / ( c*(1 - sin(chi)))) / n
c           First approximation
            lati = 2*atan(exp(1.0)**psi) - pi/2.0
            do k = 1,2
               psii = log(tan(lati/2.0 + pi/4.0) *                                   &
     &         ((1.0 - e*sin(lati))/(1.0 + e*sin(lati)))**(e/2.0))
               latip1 = lati - ( psii - psi )*cos(lati)*                             &
     &         (1.0 - e**2*(sin(lati))**2) / (1.0 - e**2)
               lati = latip1
            enddo
            x2(i)=lon
            y2(i)=lati
         endif
      enddo

      end

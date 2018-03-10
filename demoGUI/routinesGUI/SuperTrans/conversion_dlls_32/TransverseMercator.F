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
 
      integer   x1_pr
      integer   y1_pr
      integer   x2_pr
      integer   y2_pr
      integer    a_pr
      integer finv_pr
      integer   k0_pr
      integer   fe_pr
      integer   fn_pr
      integer lat0_pr
      integer lon0_pr
      integer iopt_pr
 
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

        x1_pr = mxGetPr(prhs(1))
        y1_pr = mxGetPr(prhs(2))
         a_pr = mxGetPr(prhs(3))
      finv_pr = mxGetPr(prhs(4))
        k0_pr = mxGetPr(prhs(5))
        fe_pr = mxGetPr(prhs(6))
        fn_pr = mxGetPr(prhs(7))
      lat0_pr = mxGetPr(prhs(8))
      lon0_pr = mxGetPr(prhs(9))
      iopt_pr = mxGetPr(prhs(10))

      x2_pr    = mxGetPr(plhs(1))
      y2_pr    = mxGetPr(plhs(2))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(  x1_pr,x1  ,np)
      call mxCopyPtrToReal8(  y1_pr,y1  ,np)
      call mxCopyPtrToReal8(   a_pr,a   ,1)
      call mxCopyPtrToReal8(finv_pr,finv,1)
      call mxCopyPtrToReal8(  k0_pr,k0  ,1)
      call mxCopyPtrToReal8(  fe_pr,fe  ,1)
      call mxCopyPtrToReal8(  fn_pr,fn  ,1)
      call mxCopyPtrToReal8(lat0_pr,lat0,1)
      call mxCopyPtrToReal8(lon0_pr,lon0,1)
      call mxCopyPtrToReal8(iopt_pr,iopt,1)

      iopt1=int(iopt)
      
C     Call the computational subroutine
      call transversemercator(x1,y1,x2,y2,a,finv,k0,fe,fn,lat0,lon0,         &
     &                        iopt1,np)
      
C     Load the output into a MATLAB array.
      call mxCopyReal8ToPtr(x2,x2_pr,np)
      call mxCopyReal8ToPtr(y2,y2_pr,np)

      deallocate(x1)
      deallocate(y1)
      
      return
      end


      subroutine transversemercator(x1,y1,x2,y2,a,finv,k0,fe,fn,             &
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
      
      real*8 e2
      real*8 e4
      real*8 e6
      real*8 eac2
      real*8 M0
      real*8 lon
      real*8 lat
      real*8 T
      real*8 nu
      real*8 C
      real*8 AA
      real*8 M
      real*8 E
      real*8 N
      real*8 e1
      real*8 M1
      real*8 mu1
      real*8 lat1
      real*8 nu1
      real*8 rho1
      real*8 T1
      real*8 D

      f=1/finv
      e2=2.0*f-f**2
      e4=e2**2
      e6=e2**3
      eac2=e2/(1.0-e2)
      M0 = a*((1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0)*lat0 -                &
     &   (3.0*e2/8.0 +                                                          &
     &   3.0*e4/32.0 + 45.0*e6/1024.0)*sin(2.0*lat0) + (15.0*e4/256.0 +         &
     &   45.0*e6/1024.0)*sin(4.0*lat0) - (35.0*e6/3072.0)*sin(6.0*lat0))

      do i=1,n1
         if (iopt==1) then
c           geo2xy
            lon=x1(i)
            lat=y1(i)
            T  = (tan(lat))**2
            nu = a /(1.0 - e2*(sin(lat))**2)**0.5
            C  = e2*(cos(lat))**2/(1.0 - e2)
            AA  = (lon - lon0)*cos(lat)
            M  = a*((1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0)*lat -           &
     &      (3.0*e2/8.0 + 3.0*e4/32.0 + 45.0*e6/1024.0)*sin(2.0*lat) +          &
     &      (15.0*e4/256.0 + 45.0*e6/1024.0)*sin(4.0*lat) -                     &
     &      (35.0*e6/3072.0)*sin(6.0*lat))

            x2(i) =  FE + k0*nu*(AA + (1 - T + C)*AA**3/6.0 +                   &
     &      (5.0 - 18.0*T + T**2 + 72.0*C - 58.0*eac2)*AA**5/120.0)

            y2(i) =  FN + k0*(M - M0 + nu*tan(lat)*(AA**2/2.0 +                 &
     &      (5.0 - T + 9.0*C + 4.0*C**2)*AA**4/24.0 +                           &
     &      (61.0 - 58.0*T + T**2 +                                             &
     &      600.0*C - 330.0*eac2)*AA**6/720.0))
         else
c           xy2geo
            E=x1(i)
            N=y1(i)
            e1  = (1.0 - (1.0 - e2)**0.5)/(1.0 + (1.0 - e2)**0.5)
            M1  = M0 + (N - FN)/k0
            mu1 = M1/(a*(1.0 - e2/4.0 - 3.0*e4/64.0 - 5.0*e6/256.0))
            lat1 = mu1 + ((3.0*e1)/2.0 - 27.0*e1**3/32.0)*sin(2.0*mu1) +        &
     &      (21.0*e1**2/16.0 -55.0*e1**4/32.0)*sin(4.0*mu1)+                    &
     &      (151.0*e1**3/96.0)*sin(6.0*mu1) +                                   &
     &      (1097.0*e1**4/512.0)*sin(8.0*mu1)
            nu1  = a /(1.0 - e2*(sin(lat1))**2)**0.5
            rho1 = a*(1.0 - e2)/(1.0 - e2*(sin(lat1))**2)**1.5
            T1   = (tan(lat1))**2
            C1   = eac2*(cos(lat1))**2
            D    = (E - FE)/(nu1*k0)
            lat = lat1 - (nu1*tan(lat1)/rho1)*(D**2/2.0 - (5.0 +                &
     &      3.0*T1 + 10.0*C1 - 4.0*C1**2 - 9.0*eac2)*D**4/24.0 + (61.0          &
     &      + 90.0*T1 + 298.0*C1 + 45.0*T1**2 - 252.0*eac2 -                    &
     &      3.0*C1**2)*D**6/720.0)
            lon = lon0 + (D - (1 + 2.0*T1 + C1)*D**3/6.0 + (5.0 -               &
     &      2.0*C1 + 28.0*T1 - 3.0*C1**2 + 8.0*eac2 +                           &
     &      24.0*T1**2)*D**5/120.0) / cos(lat1)
            x2(i)=lon
            y2(i)=lat
         endif
      enddo

      end

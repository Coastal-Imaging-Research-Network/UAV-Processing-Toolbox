#include "fintrf.h"
C
#if 0
C     generate with :  mex ObliqueMercator.f
C     
C     curvec.f
C     .F file needs to be preprocessed to generate .for equivalent
C     
#endif
C     
C     curvec.f
C
C     multiple the first input by the second input
      
C     This is a MEX file for MAATLAAB.
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
      integer*8 phic_pr
      integer*8 labc_pr
      integer*8 alphac_pr
      integer*8 gammac_pr
      integer*8 kc_pr
      integer*8 ec_pr
      integer*8 nc_pr

      integer*8 iopt_pr
 
      integer m1,n1,np,iopt1

      real*8, dimension(:),   allocatable ::  x1
      real*8, dimension(:),   allocatable ::  y1
      real*8, dimension(:),   allocatable ::  x2
      real*8, dimension(:),   allocatable ::  y2

      real*8 a
      real*8 finv
      real*8 phic
      real*8 labc
      real*8 alphac
      real*8 gammac
      real*8 kc
      real*8 ec
      real*8 nc
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

      x1_pr     = mxGetPr(prhs(1))
      y1_pr     = mxGetPr(prhs(2))
      a_pr      = mxGetPr(prhs(3))
      finv_pr   = mxGetPr(prhs(4))
      phic_pr   = mxGetPr(prhs(5))
      labc_pr   = mxGetPr(prhs(6))
      alphac_pr = mxGetPr(prhs(7))
      gammac_pr = mxGetPr(prhs(8))
      kc_pr     = mxGetPr(prhs(9))
      ec_pr     = mxGetPr(prhs(10))
      nc_pr     = mxGetPr(prhs(11))
      iopt_pr   = mxGetPr(prhs(12))

      x2_pr    = mxGetPr(plhs(1))
      y2_pr    = mxGetPr(plhs(2))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(x1_pr,x1,np)
      call mxCopyPtrToReal8(y1_pr,y1,np)
      call mxCopyPtrToReal8(a_pr,a,1)
      call mxCopyPtrToReal8(finv_pr,finv,1)
      call mxCopyPtrToReal8(phic_pr,phic,1)
      call mxCopyPtrToReal8(labc_pr,labc,1)
      call mxCopyPtrToReal8(alphac_pr,alphac,1)
      call mxCopyPtrToReal8(gammac_pr,gammac,1)
      call mxCopyPtrToReal8(kc_pr,kc,1)
      call mxCopyPtrToReal8(ec_pr,ec,1)
      call mxCopyPtrToReal8(nc_pr,nc,1)
      call mxCopyPtrToReal8(iopt_pr,iopt,1)

      iopt1=int(iopt)
      
C     Call the computational subroutine
      call oblmerc(x1,y1,x2,y2,a,finv,phic,labc,alphac,                      &
     &             gammac,kc,ec,nc,iopt1,np)
      
C     Load the output into a MAATLAAB array.

      call mxCopyReal8ToPtr(x2,x2_pr,np)
      call mxCopyReal8ToPtr(y2,y2_pr,np)

      deallocate(x1)
      deallocate(y1)
      
      return
      end


      subroutine oblmerc(x1,y1,x2,y2,a,finv,latc,lonc,alphac,                &
     &                   gammac,kc,ec,nc,iopt,n1)
      
      integer i
      integer iopt
      integer n1

      real*8 x1(n1)
      real*8 y1(n1)
      real*8 x2(n1)
      real*8 y2(n1)
      real*8 a
      real*8 f
      real*8 finv

      real*8 latc
      real*8 lonc
      real*8 alphac
      real*8 gammac
      real*8 kc
      real*8 ec
      real*8 nc

      real*8 pi      
      real*8 ee

      real*8 e
      real*8 e2
      real*8 e4
      real*8 e6
      real*8 e8

      real*8 B
      real*8 AA
      real*8 t0
      real*8 D
      real*8 D2
      real*8 FF
      real*8 H
      real*8 G
      real*8 gamma0
      real*8 lon0
      real*8 uc
      real*8 vc
      real*8 t
      real*8 Q
      real*8 S
      real*8 TT
      real*8 u
      real*8 v
      real*8 chi
      real*8 lat
      real*8 lon
      
      pi = 3.141592654
      ee = 2.718281828

      f = 1.0/finv
      e2 = 2.0*f-f**2
      e4=e2**2
      e6=e2**3
      e8=e4**2

      e=sqrt(e2)

      B = (1.0 + (e2 * (cos(latc))**4 / (1.0 - e2 )))**0.5
      AA = a * B * kc * (1.0 - e2 )**0.5 / ( 1.0 - e2 * (sin(latc))**2)
      t0 = tan(pi/4 - latc/2) / ((1.0 - e*sin(latc)) /                       &
     &     (1.0 + e*sin(latc)))**(e/2)
      D = B * (1 - e2)**0.5  / (cos(latc) * ( 1.0 -                          &
     &    e2*(sin(latc))**2)**0.5)

      D2 = D**2
      if (D<1.0) then
         D2 = 1.0
      endif

      if (latc>=0) then
         FF = D + (D2 - 1.0)**0.5
      else
         FF = -D - (D2 - 1.0)**0.5
      endif

      H = FF*t0**B
      G = (FF - 1/FF) / 2
      gamma0 = asin(sin(alphac) / D)
      lon0 = lonc - (asin(G*tan(gamma0))) / B
      vc = 0.0

      if (latc>=0) then
         uc = (AA / B) * atan((D2 - 1.0)**0.5 / cos (alphac) )
      else
         uc = -(AA / B) * atan((D2 - 1.0)**0.5 / cos (alphac) )
      endif
      
      if (alphac==pi/2) then
         uc = AA*(lonc - lon0)
      endif

      do i=1,n1
      
         if (iopt==1) then
c           geo2xy

            lon = x1(i)
            lat = y1(i)

            t = tan(pi/4 - lat/2) / ((1.0 - e * sin(lat)) /                  &
     &          (1 + e * sin (lat)))**(e/2)
            Q = H / t**B
            S = (Q - 1/Q) / 2
            TT = (Q + 1/Q) / 2
            VV = sin(B * (lon - lon0))
            UU = (- VV * cos(gamma0) + S * sin(gamma0)) / TT
            v = AA * log((1 - UU) / (1 + UU)) / (2 * B)
            u = (AA * atan((S * cos(gamma0) + VV * sin(gamma0)) /             &
     &          cos(B * (lon - lon0 ))) / B) - sign(abs(uc),latc)

            x2(i) = v *cos(gammac) + u *sin(gammac) + ec
            y2(i) = u *cos(gammac) - v *sin(gammac) + nc

         else
c           xy2geo
            east=x1(i)
            north=y1(i)

            v = (east - ec) * cos(gammac) - (north - nc)*sin(gammac)
            u = (north - nc)*cos(gammac) + (east - ec)*sin(gammac) +         & 
     &          sign(abs(uc),latc)

            Q = ee **(- (B * v / AA))
            S = (Q - 1 / Q) / 2
            TT = (Q + 1 / Q) / 2
            VV = sin (B* u / AA)
            UU = (VV * cos(gammac) + S * sin(gammac)) / TT
            t = (H / ((1 + UU) / (1 - UU))**0.5)**(1 / B)

            chi = pi / 2 - 2 * atan(t)

            lat = chi + sin(2*chi)*( e2 / 2 + 5*e4 / 24 + e6 / 12 +          &
     &            13*e8/360) +  sin(4*chi)*( 7*e4 /48 + 29*e6 / 240 +        &
     &            811*e8 / 11520) +  sin(6*chi)*( 7*e6 / 120 + 81*e8 /       &
     &            1120) + sin(8*chi)*(4279*e8 / 161280)
            lon = lon0  - atan ((S* cos(gamma0) - VV* sin(gamma0)) /         &
     &            cos(B*u / AA)) / B

            x2(i) = lon
            y2(i) = lat
         endif
      enddo

      end

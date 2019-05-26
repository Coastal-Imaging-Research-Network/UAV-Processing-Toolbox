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
 
      integer x_pr
      integer y_pr
      integer z_pr
      integer lon_pr
      integer lat_pr
      integer h_pr
      integer a_pr
      integer e2_pr
 
      integer m1,n1,np,iopt1

      real*8, dimension(:),   allocatable ::  lon
      real*8, dimension(:),   allocatable ::  lat
      real*8, dimension(:),   allocatable ::  h
      real*8, dimension(:),   allocatable ::  x
      real*8, dimension(:),   allocatable ::  y
      real*8, dimension(:),   allocatable ::  z
      
      real*8 a
      real*8 e2

      m1 = mxGetM(prhs(1))
      n1 = mxGetN(prhs(1))
      
      np=n1*m1

      allocate(lon(1:np))
      allocate(lat(1:np))
      allocate(h(1:np))
      allocate(x(1:np))
      allocate(y(1:np))
      allocate(z(1:np))
      
C     Create matrix for the return argument.
      plhs(1) = mxCreateDoubleMatrix(m1,n1,0)
      plhs(2) = mxCreateDoubleMatrix(m1,n1,0)
      plhs(3) = mxCreateDoubleMatrix(m1,n1,0)

      x_pr    = mxGetPr(prhs(1))
      y_pr    = mxGetPr(prhs(2))
      z_pr    = mxGetPr(prhs(3))
      a_pr    = mxGetPr(prhs(4))
      e2_pr   = mxGetPr(prhs(5))

      lat_pr  = mxGetPr(plhs(1))
      lon_pr  = mxGetPr(plhs(2))
      h_pr    = mxGetPr(plhs(3))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(x_pr,x,np)
      call mxCopyPtrToReal8(y_pr,y,np)
      call mxCopyPtrToReal8(z_pr,z,np)
      call mxCopyPtrToReal8(a_pr,a,1)
      call mxCopyPtrToReal8(e2_pr,e2,1)

      iopt1=int(iopt)
      
C     Call the computational subroutine
      call x2e(x,y,z,lat,lon,h,a,e2,np)
      
C     Load the output into a MATLAB array.
      call mxCopyReal8ToPtr(lat,lat_pr,np)
      call mxCopyReal8ToPtr(lon,lon_pr,np)
      call mxCopyReal8ToPtr(h,h_pr,np)

      deallocate(x)
      deallocate(y)
      deallocate(z)
      
      return
      end


      subroutine x2e(x,y,z,lat,lon,h,a,e2,n1)
      
      integer i
      integer n1
 
      real*8 lat(n1)
      real*8 lon(n1)
      real*8 h(n1)
      real*8 x(n1)
      real*8 y(n1)
      real*8 z(n1)
      real*8 a
      real*8 e2
      real*8 v
      real*8 elat
      real*8 eht
      real*8 p
      real*8 dh
      real*8 dlat
      real*8 lat0
      real*8 h0
      
      elat = 1.e-7
      eht  = 1.0e-4
     
      do i = 1,n1

         p = sqrt(x(i)**2+y(i)**2)
         lat(i) = atan2(z(i),p/(1.0 - e2))
         h(i) = 0.0
         dh   = 1.0
         dlat = 1.0

c         while sum(dlat>elat) | sum(dh>eht)

100      lat0 = lat(i)
         h0 = h(i)
         v = a/sqrt(1.0 - e2*sin(lat(i))*sin(lat(i)))
         h(i) = p/cos(lat(i))-v
         lat(i) = atan2(z(i), p*(1.0 - e2*v/(v+h(i))))
         dlat = abs(lat(i)-lat0)
         dh = abs(h(i)-h0)

         if (dlat>elat .or. dh>eht) goto 100

         lon(i) = atan2(y(i),x(i))

      enddo

      end

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
C     $Revision: 1.12.2.1 $
      
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

      lat_pr  = mxGetPr(prhs(1))
      lon_pr  = mxGetPr(prhs(2))
      h_pr    = mxGetPr(prhs(3))
      a_pr    = mxGetPr(prhs(4))
      e2_pr   = mxGetPr(prhs(5))

      x_pr    = mxGetPr(plhs(1))
      y_pr    = mxGetPr(plhs(2))
      z_pr    = mxGetPr(plhs(3))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(lat_pr,lat,np)
      call mxCopyPtrToReal8(lon_pr,lon,np)
      call mxCopyPtrToReal8(h_pr,h,np)
      call mxCopyPtrToReal8(a_pr,a,1)
      call mxCopyPtrToReal8(e2_pr,e2,1)

      iopt1=int(iopt)
      
C     Call the computational subroutine
      call e2x(lat,lon,h,x,y,z,a,e2,np)
      
C     Load the output into a MATLAB array.
      call mxCopyReal8ToPtr(x,x_pr,np)
      call mxCopyReal8ToPtr(y,y_pr,np)
      call mxCopyReal8ToPtr(z,z_pr,np)
      
      deallocate(lon)
      deallocate(lat)
      deallocate(h)
      
      return
      end


      subroutine e2x(lat,lon,h,x,y,z,a,e2,n1)
      
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
      
      do i=1,n1
          v=a/sqrt(1.0 - e2*sin(lat(i))*sin(lat(i)))
          x(i)=(v+h(i))*cos(lat(i))*cos(lon(i))
          y(i)=(v+h(i))*cos(lat(i))*sin(lon(i))
          z(i)=(v*(1.0 - e2)+h(i))*sin(lat(i))
      enddo

      end

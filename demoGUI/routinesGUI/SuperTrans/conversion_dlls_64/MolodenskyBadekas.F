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
 
      integer*8 x0_pr
      integer*8 y0_pr
      integer*8 z0_pr
      integer*8 x1_pr
      integer*8 y1_pr
      integer*8 z1_pr
      integer*8 dx_pr
      integer*8 dy_pr
      integer*8 dz_pr
      integer*8 rx_pr
      integer*8 ry_pr
      integer*8 rz_pr
      integer*8 xp_pr
      integer*8 yp_pr
      integer*8 zp_pr
      integer*8 ds_pr
 
      integer m1,n1,np,iopt1

      real*8, dimension(:),   allocatable ::  x0
      real*8, dimension(:),   allocatable ::  y0
      real*8, dimension(:),   allocatable ::  z0
      real*8, dimension(:),   allocatable ::  x1
      real*8, dimension(:),   allocatable ::  y1
      real*8, dimension(:),   allocatable ::  z1
      
      real*8 dx
      real*8 dy
      real*8 dz
      real*8 rx
      real*8 ry
      real*8 rz
      real*8 xp
      real*8 yp
      real*8 zp  
      real*8 ds

      m1 = mxGetM(prhs(1))
      n1 = mxGetN(prhs(1))
      
      np=n1*m1

      allocate(x0(1:np))
      allocate(y0(1:np))
      allocate(z0(1:np))
      allocate(x1(1:np))
      allocate(y1(1:np))
      allocate(z1(1:np))
      
C     Create matrix for the return argument.
      plhs(1) = mxCreateDoubleMatrix(m1,n1,0)
      plhs(2) = mxCreateDoubleMatrix(m1,n1,0)
      plhs(3) = mxCreateDoubleMatrix(m1,n1,0)

      x0_pr = mxGetPr(prhs(1))
      y0_pr = mxGetPr(prhs(2))
      z0_pr = mxGetPr(prhs(3))
      dx_pr = mxGetPr(prhs(4))
      dy_pr = mxGetPr(prhs(5))
      dz_pr = mxGetPr(prhs(6))
      rx_pr = mxGetPr(prhs(7))
      ry_pr = mxGetPr(prhs(8))
      rz_pr = mxGetPr(prhs(9))
      xp_pr = mxGetPr(prhs(10))
      yp_pr = mxGetPr(prhs(11))
      zp_pr = mxGetPr(prhs(12))
      ds_pr = mxGetPr(prhs(13))

      x1_pr  = mxGetPr(plhs(1))
      y1_pr  = mxGetPr(plhs(2))
      z1_pr  = mxGetPr(plhs(3))

C     Load the data into Fortran arrays.
      call mxCopyPtrToReal8(x0_pr,x0,np)
      call mxCopyPtrToReal8(y0_pr,y0,np)
      call mxCopyPtrToReal8(z0_pr,z0,np)
      call mxCopyPtrToReal8(dx_pr,dx,1)
      call mxCopyPtrToReal8(dy_pr,dy,1)
      call mxCopyPtrToReal8(dz_pr,dz,1)
      call mxCopyPtrToReal8(rx_pr,rx,1)
      call mxCopyPtrToReal8(ry_pr,ry,1)
      call mxCopyPtrToReal8(rz_pr,rz,1)
      call mxCopyPtrToReal8(xp_pr,xp,1)
      call mxCopyPtrToReal8(yp_pr,yp,1)
      call mxCopyPtrToReal8(zp_pr,zp,1)
      call mxCopyPtrToReal8(ds_pr,ds,1)
      
C     Call the computational subroutine
      call MB(x0,y0,z0,x1,y1,z1,dx,dy,dz,rx,ry,rz,xp,yp,zp,ds,np)

C     Load the output into a MATLAB array.
      call mxCopyReal8ToPtr(x1,x1_pr,np)
      call mxCopyReal8ToPtr(y1,y1_pr,np)
      call mxCopyReal8ToPtr(z1,z1_pr,np)

      deallocate(x0)
      deallocate(y0)
      deallocate(z0)
      
      return
      end


      subroutine MB(x0,y0,z0,x1,y1,z1,dx,dy,dz,rx,ry,rz,xp,yp,zp,ds,n1)
      
      integer i
      integer n1

      real*8 x0(n1)
      real*8 y0(n1)
      real*8 z0(n1)
      real*8 x1(n1)
      real*8 y1(n1)
      real*8 z1(n1)
      real*8 dx
      real*8 dy
      real*8 dz
      real*8 rx
      real*8 ry
      real*8 rz
      real*8 xp
      real*8 yp
      real*8 zp
      real*8 ds
      real*8 m      
      real*8 pi
      
      pi = 3.141592654
      
      m = 1.0 + ds*0.000001
      
      do i=1,n1
      
       x1(i) = m*(    (x0(i)-xp) + rz*(y0(i)-yp)- ry*(z0(i)-zp)) +xp+dx
       y1(i) = m*(-rz*(x0(i)-xp) +    (y0(i)-yp)+ rx*(z0(i)-zp)) +yp+dy
       z1(i) = m*( ry*(x0(i)-xp) - rx*(y0(i)-yp)+    (z0(i)-zp)) +zp+dz
      
      enddo

      end

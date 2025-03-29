c***********************************************************************
c* calstr.for - calculate strain rate using method of                  *
c*              Shen et al. (1998)                                     *
c*                                       by Kuo-En Ching    2005.01.27 *
c*                                                Update    2016.06.07 *
c***********************************************************************

      program calstr

      implicit none
      integer,parameter::nmax=2000
      character filename*30,list*30
      character fmt*100,nn*2
      character,allocatable::sta(:)*5
      real*8 pi,londt,latdt,x,y,olat,olon,incx,incy,radii,radi
      real*8 px(nmax*3),py(nmax*3)
      real*8 d(nmax*2),g(nmax*2,6),m(6),sg(6)
      real*8 w(nmax*2),diagw(nmax*2,nmax*2),azi(nmax),a
      real*8 len(nmax),maxazi,wd
      double precision,allocatable::lon(:),lat(:),ve(:),vn(:),se(:),
     +sn(:),vcl(:,:),nazi(:),chkazi(:),nvn(:),nve(:),eps1(:),eps2(:),
     +az(:),dila(:),sdila(:),rot(:),srot(:),shear(:),psi(:),seps1(:),
     +seps2(:),saz(:),she(:),shn(:),sshear(:),spsi(:),sr(:),shel(:),
     +shnl(:),bx(:),by(:)
      double precision angle,xa,xb,xc,ya,yb,yc,chkang
      integer i,j,k,stat,num,strn,ierror,ty,nsta(nmax),nv,insde
      integer ind(nmax),ntri,tnbr(3,nmax*2),stack(nmax),ns
      integer nx,ny,nsite(nmax),ntes,tytri(nmax*2),nntri
      integer,allocatable::ntil(:,:),til(:,:),nc(:,:)
      data latdt /111.325/
      pi=4.d0*datan(1.d0)
      
      print*,'             PROGRAM CALSTR version: 5.1'
      print*,'                               by Kuo-En Ching 2005.01.27'
      print*,'                                        Update 2014.05.25'
      print*,''
      print*,''
      print*,'Input filename "sta,lon(deg),lat(deg),ve(mm),vn(mm),se(mm)
     +,sn(mm)":'
      print*,''
      read(*,'(a\)')filename
      print*,'Strain rate estimated in Delaunay Triangles, in Subnetwork
     + or in Grid?'
      print*,'Delaunay Triangles -- 1'
      print*,'Subnetwork ---------- 2'
      print*,'Grid ---------------- 3'
      print*,'(1, 2 or 3): '
      read(*,*)ty
      if(ty==2.or.ty==3) then
        print*,'Input station list filename:'
        print*,''
        read(*,'(a)')list
      end if

      open(1,file=filename,status='old')
      num=0
      stat=0
      do while (stat==0)
        read(1,*,iostat=stat)
        if(stat/=0)exit
        num=num+1
      end do
      rewind(1)
      allocate(sta(num),lon(num),lat(num),ve(num),vn(num),se(num),
     +sn(num),vcl(2,num),ntil(3,num*2))
      do i=1,num
        read(1,*)sta(i),lon(i),lat(i),ve(i),vn(i),se(i),sn(i)
      end do
      close(1)
      olon=999.
      olat=999.
      do i=1,num
        if(lon(i)<olon) olon=lon(i)
        if(lat(i)<olat) olat=lat(i)
      end do
      do i=1,num
        londt=cos(((lat(i)+olat)/2)*pi/180.)*latdt
        vcl(1,i)=(lon(i)-olon)*londt
        vcl(2,i)=(lat(i)-olat)*latdt
        ind(i)=i
      end do

      if(ty==1) then
        call dtris2 (num,num,vcl,ind,nntri,ntil,tnbr,stack,ierror)
        do i=1,nntri
          tytri(i)=0
        end do
        do i=1,nntri
          xa=vcl(1,ntil(3,i))
          ya=vcl(2,ntil(3,i))
          xb=vcl(1,ntil(1,i))
          yb=vcl(2,ntil(1,i))
          xc=vcl(1,ntil(2,i))
          yc=vcl(2,ntil(2,i))
          chkang=angle(xa,ya,xb,yb,xc,yc)*180./pi
          if(chkang>179.9) tytri(i)=1
          xa=vcl(1,ntil(1,i))
          ya=vcl(2,ntil(1,i))
          xb=vcl(1,ntil(2,i))
          yb=vcl(2,ntil(2,i))
          xc=vcl(1,ntil(3,i))
          yc=vcl(2,ntil(3,i))
          chkang=angle(xa,ya,xb,yb,xc,yc)*180./pi
          if(chkang>179.9) tytri(i)=1
          xa=vcl(1,ntil(2,i))
          ya=vcl(2,ntil(2,i))
          xb=vcl(1,ntil(3,i))
          yb=vcl(2,ntil(3,i))
          xc=vcl(1,ntil(1,i))
          yc=vcl(2,ntil(1,i))
          chkang=angle(xa,ya,xb,yb,xc,yc)*180./pi
          if(chkang>179.9) tytri(i)=1
        end do
        ntri=0
        do i=1,nntri
          if(tytri(i)==1) exit
          ntri=ntri+1
        end do
        allocate(til(3,ntri),nc(nmax,ntri))
        ntri=0
        do i=1,nntri
          if(tytri(i)==1) exit
          ntri=ntri+1
          til(1,ntri)=ntil(1,i)
          til(2,ntri)=ntil(2,i)
          til(3,ntri)=ntil(3,i)
        end do
        do j=1,ntri
          nsta(j)=3
          do i=1,nsta(j)
            nc(i,j)=til(i,j)
          end do
        end do
        if(ierror.ne.0) then
          write(*,'(/," Error on generating Delaunay triangulations!")')
        end if
c       call delaunay_print (num,vcl,ntri,til,tnbr )
      end if

      if(ty==2) then
        open(1,file=list,status='old')
        ntri=0
        stat=0
        do while (stat==0)
          read(1,*,iostat=stat)nv
          if(stat/=0)exit
          ntri=ntri+1
          do i=1,nv
            read(1,*)
          end do
        end do
        rewind(1)
        allocate(nc(nmax,ntri))
        stat=0
        ntri=0
        do while (stat==0)
          read(1,*,iostat=stat)nv
          if(stat/=0)exit
          ntri=ntri+1
          allocate(bx(nv),by(nv))
          do i=1,nv
            read(1,*)bx(i),by(i)
          end do
          ns=0
          do i=1,num
            call inside(lon(i),lat(i),bx,by,nv,insde)
            if(insde==1.or.insde==-1) then
              ns=ns+1
              nc(ns,ntri)=i
            end if
          end do
          nsta(ntri)=ns
          deallocate(bx,by)
        end do
        close(1)
      end if

      if(ty==3) then
        allocate(nc(nmax,nmax*10))
        open(1,file=list,status='old')
	read(1,*) olon,olat,nx,ny,incx,incy,radi
        ntri=0
	do i=1,ny+1
	  do j=1,nx+1
	    ntri=ntri+1
	    px(ntri)=olon+incx*(j-1)
	    py(ntri)=olat+incy*(i-1)
	    nsta(ntri)=0
	    do k=1,num
c	      londt=cos(((lat(k)+py(ntri))/2)*pi/180.)*latdt
	      x=(lon(k)-px(ntri))
	      y=(lat(k)-py(ntri))
	      call azimuth(x,y,a)
	      len(k)=sqrt(x**2+y**2)
	      azi(k)=a
	      nsite(k)=k
	    end do
	    call bubble_sort(len,azi,nsite,num)
	    do k=1,num
	      if(len(k)>radi) exit
	      nsta(ntri)=k
	    end do
	    if(nsta(ntri)<4) then
	      ntri=ntri-1
	      cycle
	    end if
	    ntes=3
	    do while (.true.)
	      if(ntes==nsta(ntri))exit
	      ntes=ntes+1
	      allocate(nazi(ntes))
	      allocate(chkazi(ntes))
	      do k=1,ntes
	        nazi(k)=azi(k)
	      end do
	      call bubble_sort2(nazi,ntes)
	      do k=1,ntes
	        if(k/=ntes) chkazi(k)=nazi(k+1)-nazi(k)
	        if(k==ntes) chkazi(k)=360.-(nazi(k)-nazi(1))
	      end do
	      maxazi=maxval(chkazi)
	      deallocate(nazi)
	      deallocate(chkazi)
	      if(maxazi>180.) cycle
	      if(maxazi<=180.) exit
	    end do
	    if(maxazi>180.) then
	      ntri=ntri-1
	      cycle
	    end if
	    radii=len(4)
	    do k=1,nsta(ntri)
	      nc(k,ntri)=nsite(k)
	    end do
	  end do
	end do
	close(1)
	open(1,file='coord')
	do i=1,ntri
	  write(1,*)px(i),py(i)
	end do
	close(1)
      end if

      if(ty==1) print'("  Number of Triangles: ",i4)',ntri
      if(ty==2) print'("  Number of Subnets: ",i4)',ntri
      if(ty==3) print'("  Number of Grids: ",i4)',ntri
      print*,''

      allocate(nvn(ntri),nve(ntri),eps1(ntri),eps2(ntri),az(ntri),
     +dila(ntri),sdila(ntri),rot(ntri),srot(ntri),shear(ntri),psi(ntri),
     +seps1(ntri),seps2(ntri),saz(ntri),she(ntri*2),shn(ntri*2),
     +sshear(ntri),spsi(ntri),sr(ntri),shel(ntri*2),shnl(ntri*2))
      ! start to calculate strain rate
      do i=1,ntri
        do j=1,nmax*2
          d(j)=0.
          w(j)=0.
          do k=1,6
            g(j,k)=0.
          end do
        end do

        if(ty==1.or.ty==2) then
          px(i)=0
          py(i)=0
          do j=1,nsta(i)
            px(i)=px(i)+lon(nc(j,i))
            py(i)=py(i)+lat(nc(j,i))
          end do
          px(i)=px(i)/nsta(i)
          py(i)=py(i)/nsta(i)
        end if

        strn=0
        do j=1,nsta(i)
c          londt=cos(((lat(nc(j,i))+py(i))/2)*pi/180.)*latdt  ! calculate original length
	  x=(lon(nc(j,i))-px(i))
	  y=(lat(nc(j,i))-py(i))
	  strn=j*2
          g(strn-1,1)=1
          g(strn-1,2)=0
          g(strn-1,3)=x
          g(strn-1,4)=y
          g(strn-1,5)=0
          g(strn-1,6)=y
          g(strn,1)=0
          g(strn,2)=1
          g(strn,3)=0
          g(strn,4)=x
          g(strn,5)=y
          g(strn,6)=-x
          d(strn-1)=ve(nc(j,i))/1e6
          d(strn)=vn(nc(j,i))/1e6
          w(strn-1)=1.
          w(strn)=1.
          if(se(nc(j,i))/=0.) w(strn-1)=1./se(nc(j,i))
          if(sn(nc(j,i))/=0.) w(strn)=1./sn(nc(j,i))
          if(ty==3)then
            wd=exp((-(x**2+y**2)/radii**2))
            w(strn-1)=wd
            w(strn)=wd
            if(se(nc(j,i))/=0.) w(strn-1)=(1./se(nc(j,i)))*wd
            if(sn(nc(j,i))/=0.) w(strn)=(1./sn(nc(j,i)))*wd
          end if
        end do
        call diagm(nmax*2,strn,w,diagw)
        call lsqr(nmax*2,strn,g,d,diagw,m,sg)
        nve(i)=m(1)*1.e6
        nvn(i)=m(2)*1.e6
        eps1(i)=(m(3)+m(5))/2.+sqrt(m(4)**2+(((m(3)-m(5))**2)/4.))
        eps2(i)=(m(3)+m(5))/2.-sqrt(m(4)**2+(((m(3)-m(5))**2)/4.))
        az(i)=((datan2((2*m(4)),(m(5)-m(3))))/2.)*180./pi
        seps1(i)=(0.5+((m(3)-m(5))/4.)*((((m(3)-m(5))**2)/4.)+(m(4)**2))
     +  **(-0.5))**2*sg(3)**2
        seps1(i)=(0.5-((m(3)-m(5))/4.)*((((m(3)-m(5))**2)/4.)+(m(4)**2))
     +  **(-0.5))**2*sg(5)**2+seps1(i)
        seps1(i)=sqrt((m(4)*((((m(3)-m(5))**2)/4.)+(m(4)**2))**
     +  (-0.5))**2*sg(4)**2+seps1(i))
        seps2(i)=(0.5-((m(3)-m(5))/4.)*((((m(3)-m(5))**2)/4.)+(m(4)**2))
     +  **(-0.5))**2*sg(3)**2
        seps2(i)=(0.5+((m(3)-m(5))/4.)*((((m(3)-m(5))**2)/4.)+(m(4)**2))
     +  **(-0.5))**2*sg(5)**2+seps2(i)
        seps2(i)=sqrt(((-1.)*m(4)*((((m(3)-m(5))**2)/4.)+(m(4)**2))**
     +  (-0.5))**2*sg(4)**2+seps2(i))
        saz(i)=(m(4)*(m(5)-m(3))**(-2.)*(1./(1.+(2*m(4)/(m(5)-m(3)))**2)
     +  ))**2*sg(3)**2
        saz(i)=(-1.*m(4)*(m(5)-m(3))**(-2.)*(1./(1.+(2.*m(4)/(m(5)-m(3))
     +  )**2)))**2*sg(5)**2+saz(i)
        saz(i)=sqrt(((m(5)-m(3))**(-1.)*(1./(1.+(2.*m(4)/(m(5)-m(3)))**2
     +  )))**2*sg(4)**2+saz(i))*180./pi
        dila(i)=m(3)+m(5)
        sdila(i)=sqrt(sg(3)**2+sg(5)**2)
        rot(i)=m(6)
        srot(i)=sg(6)
        shear(i)=sqrt((m(3)-m(5))**2+(2.*m(4))**2)
        sshear(i)=((m(3)-m(5))*((m(3)-m(5))**2+(2.*m(4))**2)**(-0.5))**2
     +  *sg(3)**2
        sshear(i)=((-1.)*(m(3)-m(5))*((m(3)-m(5))**2+(2.*m(4))**2)**
     +  (-0.5))**2*sg(5)**2+sshear(i)
        sshear(i)=sqrt((2.*m(4)*((m(3)-m(5))**2+(2.*m(4))**2)**(-0.5))
     +  **2*sg(4)**2+sshear(i))
c       psi(i)=((datan2((m(5)-m(3)),(2*m(4))))/2.)*180./pi
        psi(i)=az(i)+45.
        spsi(i)=((-0.25)*(1./(1.+((m(5)-m(3))/(2.*m(4)))**2))*(m(4))**
     +  (-1.))**2*sg(3)**2
        spsi(i)=((0.25)*(1./(1.+((m(5)-m(3))/(2.*m(4)))**2))*(m(4))**
     +  (-1.))**2*sg(5)**2+spsi(i)
        spsi(i)=sqrt(((-0.25)*(1./(1.+((m(5)-m(3))/(2.*m(4)))**2))*(m(4)
     +  )**(-2.)*(m(3)-m(5)))**2*sg(4)**2+spsi(i))*180./pi
        she(i*2-1)=shear(i)*sin(psi(i)*pi/180.)*1e6
        shn(i*2-1)=shear(i)*cos(psi(i)*pi/180.)*1e6
        she(i*2)=shear(i)*sin((psi(i)+180.)*pi/180.)*1e6
        shn(i*2)=shear(i)*cos((psi(i)+180.)*pi/180.)*1e6
        shel(i*2-1)=shear(i)*sin((psi(i)+90.)*pi/180.)*1e6
        shnl(i*2-1)=shear(i)*cos((psi(i)+90.)*pi/180.)*1e6
        shel(i*2)=shear(i)*sin((psi(i)+270.)*pi/180.)*1e6
        shnl(i*2)=shear(i)*cos((psi(i)+270.)*pi/180.)*1e6
        sr(i)=sqrt((m(3)*m(3))+(m(5)*m(5))+(2.d0*(m(4)*m(4))))
        if(nsta(i)==3) then
          seps1(i)=0.
          seps2(i)=0.
          saz(i)=0.
          srot(i)=0.
          sdila(i)=0.
          sshear(i)=0.
          spsi(i)=0.
        end if
        if(ty==1) print'("  Triangle: ",i4)',i
        if(ty==2) print'("  Subnet: ",i4)',i
        if(ty==3) print'("  Grid: ",i4)',i
      end do

      ! write the output file
      open(1,file='net.gmt')
      open(2,file='strain.out')
      open(3,file='strain.gmt')
      open(4,file='rot.gmt')
      open(5,file='shear_dex.gmt')
      open(6,file='sr.gmt')
      open(7,file='shear_sin.gmt')
      open(8,file='dila.gmt')
      open(9,file='shear.gmt')
      if(ty==1) write(2,*)'     lon       lat      ve     vn      eps1
     +    eps1(sig)     eps2      eps2(sig)     theta   theta(sig)  rota
     +tion     rot(sig)  dilatation   dila(sig)     gamma    gamma(sig)
     +     psi     psi(sig)  triangle coners'
      if(ty==2) write(2,*)'     lon       lat      ve     vn      eps1
     +    eps1(sig)     eps2      eps2(sig)     theta   theta(sig)  rota
     +tion     rot(sig)  dilatation   dila(sig)     gamma    gamma(sig)
     +     psi     psi(sig)  subnet coners'
      if(ty==3) write(2,*)'     lon       lat      ve     vn      eps1
     +    eps1(sig)     eps2      eps2(sig)     theta   theta(sig)  rota
     +tion     rot(sig)  dilatation   dila(sig)     gamma    gamma(sig)
     +     psi     psi(sig)  stations'
      do i=1,ntri
        call int2char(nsta(i)-1,nn)
        fmt='("X  ", 2(a4,1x),a4)'
        fmt(8:9)=nn(1:2)
        write(1,fmt)(sta(nc(j,i)),j=1,nsta(i))
        do j=1,nsta(i)
          write(1,'(2f8.4)')lon(nc(j,i)),lat(nc(j,i))
        end do
        fmt='(2f10.4,2f7.2,4e12.3,2f11.4,6e12.3,2f11.4,2x, 2(a4,"-"),a4)
     +'
        fmt(46:47)=nn(1:2)
        if(ty==3) fmt(53:53)=' '
        write(2,fmt)px(i),py(i),nve(i),nvn(i),eps1(i),seps1(i),eps2(i)
     +  ,seps2(i),az(i),saz(i),rot(i),srot(i),dila(i),sdila(i),shear(i),
     +  sshear(i),psi(i),spsi(i),(sta(nc(j,i)),j=1,nsta(i))
        write(3,'(2(f9.4),2f12.6,f10.4)')px(i),py(i),eps1(i)*1e6,
     +  eps2(i)*1e6,az(i)+90
        write(4,'(2f9.4,e12.3)')px(i),py(i),rot(i)
        write(5,'(2f9.4,2f9.3)')px(i),py(i),she(i*2-1),shn(i*2-1)
        write(5,'(2f9.4,2f9.3)')px(i),py(i),she(i*2),shn(i*2)
        write(6,'(2f9.4,f9.3)')px(i),py(i),sr(i)*1e6 
        write(7,'(2f9.4,2f9.3)')px(i),py(i),shel(i*2-1),shnl(i*2-1)
        write(7,'(2f9.4,2f9.3)')px(i),py(i),shel(i*2),shnl(i*2)
        write(8,'(2f9.4,f9.3)')px(i),py(i),dila(i)*1e6
        write(9,'(2f9.4,f9.3)')px(i),py(i),shear(i)*1e6
      end do
      close(1)
      close(2)
      close(3)
      close(4)
      close(5)
      close(6)
      close(7)
      close(8)
      close(9)
      if(ty==3) call system('del net.gmt')

      write(*,'(/,"  Normal terminal!")')
      deallocate(sta,lon,lat,ve,vn,se,sn,nc)
      deallocate(nvn,nve,eps1,eps2,az,dila,rot,srot,shear,psi,she,shn,
     +sdila,sshear,spsi,sr,shel,shnl)
      if(ty==1) deallocate(vcl,ntil,til)

      stop
      end

c***********************************************************************
       subroutine dtris2 (npt,maxst,vcl,ind,ntri,til,tnbr,stack,ierror)
!
!*******************************************************************************
!
!! DTRIS2 constructs a Delaunay triangulation of 2D vertices.
!
!
!  Discussion:
!
!    The routine constructs the Delaunay triangulation of a set of 2-D vertices
!    using an incremental approach and diagonal edge swaps.  Vertices are
!    first sorted in lexicographically increasing (X,Y) order, and
!    then are inserted one at a time from outside the convex hull.
!
!    On abnormal return, IERROR is set to 8, 224, or 225.
!
!  Modified:
!
!    19 February 2001
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, integer NPT, the number of vertices.
!
!    Input, integer MAXST, the maximum size available for the STACK array;
!    should be about NPT to be safe, but MAX(10,2*LOG2(NPT)) is usually enough.
!
!    Input, double precision VCL(2,NPT), the coordinates of the vertices.
!
!    Input/output, integer IND(NPT), the indices in VCL of the vertices
!    to be triangulated.  On output, IND has been permuted by the sort.
!
!    Output, integer NTRI, the number of triangles in the triangulation;
!    NTRI is equal to 2*NPT - NB - 2, where NB is the number of boundary
!    vertices.
!
!    Output, integer TIL(3,NTRI), the nodes that make up each triangle.
!    The elements are indices of VCL.  The vertices of the triangles are
!    in counter clockwise order.
!
!    Output, integer TNBR(3,NTRI), the triangle neighbor list.
!    Positive elements are indices of TIL; negative elements are used for links
!    of a counter clockwise linked list of boundary edges; LINK = -(3*I + J-1)
!    where I, J = triangle, edge index; TNBR(J,I) refers to
!    the neighbor along edge from vertex J to J+1 (mod 3).
!
!    Workspace, integer STACK(MAXST), used for a stack of triangles for which
!    circumcircle test must be made.
!
!    Output, integer IERROR, an error flag, nonzero if an error occurred.
!
      integer maxst
      integer npt
!
      double precision cmax
      integer e
      integer i
      integer ierror
      integer ind(npt)
      integer j
      integer k
      integer l
      integer ledg
      integer lr
      integer lrline
      integer ltri
      integer m
      integer m1
      integer m2
      integer, parameter :: msglvl = 0
      integer n
      integer ntri
      integer redg
      integer rtri
      integer stack(maxst)
      integer t
      integer til(3,npt*2)
      integer tnbr(3,npt*2)
      double precision tol
      integer top
      double precision vcl(2,npt)
!
      ierror = 0
      tol = 100.0D+00 * epsilon ( tol )

      ierror = 0
!
!  Sort the vertices.
!
      call dhpsrt ( 2, npt, 2, vcl, ind )
!
!  Ensure that no two consecutive points are too close.
!
      m1 = ind(1)

      do i = 2, npt

        m = m1
        m1 = ind(i)

        k = 0
        do j = 1, 2

          cmax = max ( abs ( vcl(j,m) ), abs ( vcl(j,m1) ) )

          if(abs(vcl(j,m)-vcl(j,m1))>tol*cmax.and.cmax>tol) then
            k = j
            exit
          end if

        end do

        if ( k == 0 ) then
          ierror = 224
          return
        end if

      end do
!
!  Take the first two points, M1 and M2, and find a suitable non-collinear
!  third, M.  All points between M2 and M are very close to collinear
!  with M1 and M2.
!
      m1 = ind(1)
      m2 = ind(2)
      j = 3

      do

        if ( j > npt ) then
          ierror = 225
          return
        end if

        m = ind(j)
        lr = lrline(vcl(1,m),vcl(2,m),vcl(1,m1),vcl(2,m1),vcl(1,m2),
     +    vcl(2,m2), 0.0D+00 )

        if ( lr /= 0 ) then
          exit
        end if

        j = j + 1

      end do

      ntri = j - 2
!
!  Depending on the orientation of M1, M2, and M, set up the initial
!  triangle data.
!
      if ( lr == -1 ) then

        til(1,1) = m1
        til(2,1) = m2
        til(3,1) = m
        tnbr(3,1) = -3

        do i = 2, ntri

          m1 = m2
          m2 = ind(i+1)
          til(1,i) = m1
          til(2,i) = m2
          til(3,i) = m
          tnbr(1,i-1) = -3 * i
          tnbr(2,i-1) = i
          tnbr(3,i) = i - 1

        end do

        tnbr(1,ntri) = -3 * ntri - 1
        tnbr(2,ntri) = -5
        ledg = 2
        ltri = ntri

      else

        til(1,1) = m2
        til(2,1) = m1
        til(3,1) = m
        tnbr(1,1) = -4

        do i = 2, ntri
          m1 = m2
          m2 = ind(i+1)
          til(1,i) = m2
          til(2,i) = m1
          til(3,i) = m
          tnbr(3,i-1) = i
          tnbr(1,i) = -3 * i - 3
          tnbr(2,i) = i - 1
        end do

        tnbr(3,ntri) = -3 * ntri
        tnbr(2,1) = -3 * ntri - 2
        ledg = 2
        ltri = 1

      end if

      if ( msglvl == 4 ) then

        m2 = ind(1)
        write ( *, 600 ) 1,vcl(1,m2),vcl(2,m2),vcl(1,m),vcl(2,m)

        do i = 2, j-1
          m1 = m2
          m2 = ind(i)
          write ( *,600) 1,vcl(1,m1),vcl(2,m1),vcl(1,m2),vcl(2,m2)
          write ( *,600) 1,vcl(1,m2),vcl(2,m2),vcl(1,m),vcl(2,m)
        end do

      end if
!
!  Insert vertices one at a time from outside the convex hull, determine
!  the visible boundary edges, and apply diagonal edge swaps until
!  the Delaunay triangulation of the vertices (so far) is obtained.
!
      top = 0

      do i = j+1, npt

        if ( msglvl == 4 ) then
          write ( *, '(a)' ) ' '
          write ( *, 600 ) i
        end if

        m = ind(i)
        m1 = til(ledg,ltri)

        if ( ledg <= 2 ) then
          m2 = til(ledg+1,ltri)
        else
          m2 = til(1,ltri)
        end if

        lr = lrline(vcl(1,m),vcl(2,m),vcl(1,m1),vcl(2,m1),vcl(1,m2),
     +    vcl(2,m2), 0.0D+00 )

        if ( lr > 0 ) then
          rtri = ltri
          redg = ledg
          ltri = 0
        else
          l = -tnbr(ledg,ltri)
          rtri = l / 3
          redg = mod ( l, 3 ) + 1
        end if

        call vbedg(vcl(1,m),vcl(2,m),vcl,til,tnbr,ltri,ledg,rtri,redg)

        n = ntri + 1
        l = -tnbr(ledg,ltri)

        do

          t = l / 3
          e = mod ( l, 3 ) + 1
          l = -tnbr(e,t)
          m2 = til(e,t)

          if ( e <= 2 ) then
            m1 = til(e+1,t)
          else
            m1 = til(1,t)
          end if

          ntri = ntri + 1
          tnbr(e,t) = ntri
          til(1,ntri) = m1
          til(2,ntri) = m2
          til(3,ntri) = m
          tnbr(1,ntri) = t
          tnbr(2,ntri) = ntri - 1
          tnbr(3,ntri) = ntri + 1
          top = top + 1

          if ( top > maxst ) then
            ierror = 8
            return
          end if

          stack(top) = ntri

          if ( msglvl == 4 ) then
            write ( *,600) 1,vcl(1,m),vcl(2,m),vcl(1,m2),vcl(2,m2)
          end if

          if ( t == rtri .and. e == redg ) then
            exit
          end if

        end do

        if ( msglvl == 4 ) then
          write ( *,600) 1,vcl(1,m),vcl(2,m),vcl(1,m1),vcl(2,m1)
        end if

        tnbr(ledg,ltri) = -3 * n - 1
        tnbr(2,n) = -3 * ntri - 2
        tnbr(3,ntri) = -l
        ltri = n
        ledg = 2

        call swapec(m,top,maxst,ltri,ledg,vcl,til,tnbr,stack,ierror)

        if ( ierror /= 0 ) then
          return
        end if

      end do

      if ( msglvl == 4 ) then
        write ( *, '(i7)' ) npt + 1
      end if

  600 format (1x,i7,4f15.7)

      return
      end

      function angle ( xa, ya, xb, yb, xc, yc )
!
!*******************************************************************************
!
!! ANGLE computes the interior angle at a vertex defined by 3 points.
!
!
!  Discussion:
!
!    ANGLE computes the interior angle, in radians, at vertex
!    (XB,YB) of the chain formed by the directed edges from
!    (XA,YA) to (XB,YB) to (XC,YC).  The interior is to the
!    left of the two directed edges.
!
!  Modified:
!
!    17 July 1999
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, double precision XA, YA, XB, YB, XC, YC, the coordinates of the
!    vertices.
!
!    Output, double precision ANGLE, the interior angle formed by
!    the vertex, in radians, between 0 and 2*PI.
!
      double precision angle
      double precision d_pi
      double precision t
      double precision x1
      double precision x2
      double precision xa
      double precision xb
      double precision xc
      double precision y1
      double precision y2
      double precision ya
      double precision yb
      double precision yc
!
      x1 = xa - xb
      y1 = ya - yb
      x2 = xc - xb
      y2 = yc - yb

      t = sqrt ( ( x1 * x1 + y1 * y1 ) * ( x2 * x2 + y2 * y2 ) )

      if ( t == 0.0D+00 ) then
        angle = d_pi ( )
        return
      end if

      t = ( x1 * x2 + y1 * y2 ) / t

      if ( t < -1.0D+00 ) then
        t = -1.0D+00
      else if ( t > 1.0D+00 ) then
        t = 1.0D+00
      end if

      angle = acos ( t )

      if ( x2 * y1 - y2 * x1 < 0.0D+00 ) then
        angle = 2.0D+00 * d_pi ( ) - angle
      end if

      return
      end

      function d_pi ( )
!
!*******************************************************************************
!
!! D_PI returns the value of pi.
!
!
!  Modified:
!
!    04 December 1998
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Output, double precision D_PI, the value of pi.
!
      double precision d_pi
!
      d_pi = 3.14159265358979323846264338327950288419716939937510D+00

      return
      end

      subroutine dhpsrt ( k, n, lda, a, map )
!
!*******************************************************************************
!
!! DHPSRT sorts points into lexicographic order using heap sort
!
!
!  Discussion:
!
!    This routine uses heapsort to obtain the permutation of N K-dimensional
!    points so that the points are in lexicographic increasing order.
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Modified:
!
!    19 February 2001
!
!  Parameters:
!
!    Input, integer K, the dimension of the points (for instance, 2
!    for points in the plane).
!
!    Input, integer N, the number of points.
!
!    Input, integer LDA, the leading dimension of array A in the calling
!    routine; LDA should be at least K.
!
!    Input, double precision A(LDA,N); A(I,J) contains the I-th coordinate
!    of point J.
!
!    Input/output, integer MAP(N).
!    On input, the points of A with indices MAP(1), MAP(2), ...,
!    MAP(N) are to be sorted.
!
!    On output, MAP contains a permutation of its input values, with the
!    property that, lexicographically,
!      A(*,MAP(1)) <= A(*,MAP(2)) <= ... <= A(*,MAP(N)).
!
      integer lda
      integer n
!
      double precision a(lda,*)
      integer i
      integer k
      integer map(n)
!
      do i = n/2, 1, -1
        call dsftdw ( i, n, k, lda, a, map )
      end do

      do i = n, 2, -1
        call i_swap ( map(1), map(i) )
        call dsftdw ( 1, i-1, k, lda, a, map )
      end do

      return
      end

      function lrline ( xu, yu, xv1, yv1, xv2, yv2, dv )
!
!*******************************************************************************
!
!! LRLINE determines if a point is left of, right or, or on a directed line.
!
!
!  Discussion:
!
!    The directed line is paralled to, and at a signed distance DV from
!    a directed base line from (XV1,YV1) to (XV2,YV2).
!
!  Modified:
!
!    14 July 2001
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, double precision XU, YU, the coordinates of the point whose
!    position relative to the directed line is to be determined.
!
!    Input, double precision XV1, YV1, XV2, YV2, the coordinates of two points
!    that determine the directed base line.
!
!    Input, double precision DV, the signed distance of the directed line
!    from the directed base line through the points (XV1,YV1) and (XV2,YV2).
!    DV is positive for a line to the left of the base line.
!
!    Output, integer LRLINE, the result:
!    +1, the point is to the right of the directed line;
!     0, the point is on the directed line;
!    -1, the point is to the left of the directed line.
!
      double precision dv
      double precision dx
      double precision dxu
      double precision dy
      double precision dyu
      integer lrline
      double precision t
      double precision tol
      double precision tolabs
      double precision xu
      double precision xv1
      double precision xv2
      double precision yu
      double precision yv1
      double precision yv2
!
      tol = 100.0D+00 * epsilon ( tol )

      dx = xv2 - xv1
      dy = yv2 - yv1
      dxu = xu - xv1
      dyu = yu - yv1

      tolabs = tol * max ( abs ( dx ), abs ( dy ), abs ( dxu ),
     +  abs ( dyu ), abs ( dv ) )

      t = dy * dxu - dx * dyu + dv * sqrt ( dx * dx + dy * dy )

      if ( tolabs < t ) then
        lrline = 1
      else if ( -tolabs <= t ) then
        lrline = 0
      else
        lrline = -1
      end if

      return
      end

      subroutine vbedg ( x, y, vcl, til, tnbr, ltri, ledg, rtri, redg )
!
!*******************************************************************************
!
!! VBEDG determines visible boundary edges of a 2D triangulation.
!
!
!  Purpose:
!
!    Determine boundary edges of 2-D triangulation which are
!    visible from point (X,Y) outside convex hull.
!
!  Modified:
!
!    14 July 2001
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, double precision X, Y, the coordinates of a 2-D point outside
!    the convex hull.
!
!    Input, double precision VCL(1:2,1:*), the coordinates of 2-D vertices.
!
!    Input, integer TIL(1:3,1:*), the triangle incidence list.
!
!    Input, integer TNBR(1:3,1:*), the triangle neighbor list; negative
!    values are used for links of counter clockwise linked list of boundary
!    edges; LINK = -(3*I + J-1) where I, J = triangle, edge index.
!
!    Input/output, integer LTRI, LEDG.  On input, if LTRI /= 0 then they
!    are assumed to be as defined below and are not changed, else they are
!    updated.  On output, LTRI is the index of the boundary triangle to the
!    left of leftmost boundary triangle visible from (X,Y), and LEDG is the
!    boundary edge of triangle LTRI to left of leftmost
!    boundary edge visible from (X,Y).  1 <= LEDG <= 3.
!
!    Input/output, integer RTRI, on input, the index of boundary triangle
!    to begin search at.  On output, the index of rightmost boundary triangle
!    visible from (X,Y).
!
!    Input/output, integer REDG.  On input, the edge of triangle RTRI that
!    is visible from (X,Y).  On output, REDG has been updated so that this
!    is still true. 1 <= REDG <= 3.
!
      integer a
      integer b
      integer e
      integer i_wrap
      integer l
      logical ldone
      integer ledg
      integer lr
      integer lrline
      integer ltri
      integer redg
      integer rtri
      integer t
      integer til(3,*)
      integer tnbr(3,*)
      double precision vcl(2,*)
      double precision x
      double precision y
!
!  Find rightmost visible boundary edge using links, then possibly
!  leftmost visible boundary edge using triangle neighbor information.
!
      if ( ltri == 0 ) then
        ldone = .false.
        ltri = rtri
        ledg = redg
      else
        ldone = .true.
      end if

10    continue

      l = -tnbr(redg,rtri)
      t = l / 3
      e = mod ( l, 3 ) + 1
      a = til(e,t)

      if ( e <= 2 ) then
        b = til(e+1,t)
      else
        b = til(1,t)
      end if

      lr = lrline(x,y,vcl(1,a),vcl(2,a),vcl(1,b),vcl(2,b),0.0D+00)

      if ( lr > 0 ) then
        rtri = t
        redg = e
        go to 10
      end if

      if ( ldone ) then
        return
      end if

      t = ltri
      e = ledg

      do

        b = til(e,t)
        e = i_wrap ( e-1, 1, 3 )

        do while ( tnbr(e,t) > 0 )

          t = tnbr(e,t)

          if ( til(1,t) == b ) then
            e = 3
          else if ( til(2,t) == b ) then
            e = 1
          else
            e = 2
          end if

        end do

        a = til(e,t)
        lr = lrline(x,y,vcl(1,a),vcl(2,a),vcl(1,b),vcl(2,b),0.0D+00)

        if ( lr <= 0 ) then
          exit
        end if

      end do

      ltri = t
      ledg = e

      return
      end

      subroutine swapec(i,top,maxst,btri,bedg,vcl,til,tnbr,stack,ierror)
!
!*******************************************************************************
!
!! SWAPEC swaps diagonal edges until all triangles are Delaunay.
!
!
!  Discussion:
!
!    The routine swaps diagonal edges in a 2-D triangulation, based on
!    the empty circumcircle criterion, until all triangles are Delaunay,
!    given that I is the index of the new vertex added to triangulation.
!
!  Modified:
!
!    19 February 2001
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, integer I, the index in VCL of the new vertex.
!
!    Input/output, integer TOP, the index of the top of the stack.
!    On output, TOP is zero.
!
!    Input, integer MAXST, the maximum size available for the STACK array.
!
!    Input/output, integer BTRI, BEDG; on input, if positive, are the
!    triangle and edge indices of a boundary edge whose updated indices
!    must be recorded.  On output, these may be updated because of swaps.
!
!    Input, double precision VCL(2,*), the coordinates of the vertices.
!
!    Input/output, integer TIL(3,*), the triangle incidence list.  May be updated
!    on output because of swaps.
!
!    Input/output, integer TNBR(3,*), the triangle neighbor list; negative
!    values are used for links of the counter-clockwise linked list of boundary
!    edges; May be updated on output because of swaps.
!
!      LINK = -(3*I + J-1) where I, J = triangle, edge index.
!
!    Workspace, integer STACK(1:MAXST); on input, entries 1 through TOP
!    contain the indices of initial triangles (involving vertex I)
!    put in stack; the edges opposite I should be in interior;  entries
!    TOP+1 through MAXST are used as a stack.
!
!    Output, integer IERROR is set to 8 for abnormal return.
!
      integer maxst
!
      integer a
      integer b
      integer bedg
      integer btri
      integer c
      integer diaedg
      integer e
      integer ee
      integer em1
      integer ep1
      integer f
      integer fm1
      integer fp1
      integer i
      integer ierror
      integer l
      integer r
      integer s
      integer stack(maxst)
      integer swap
      integer t
      integer til(3,*)
      integer tnbr(3,*)
      integer top
      integer tt
      integer u
      double precision vcl(2,*)
      double precision x
      double precision y
!
!  Determine whether triangles in stack are Delaunay, and swap
!  diagonal edge of convex quadrilateral if not.
!
      ierror = 0
      x = vcl(1,i)
      y = vcl(2,i)

      do

        if ( top <= 0 ) then
          exit
        end if

        t = stack(top)
        top = top - 1

        if ( til(1,t) == i ) then
          e = 2
          b = til(3,t)
        else if ( til(2,t) == i ) then
          e = 3
          b = til(1,t)
        else
          e = 1
          b = til(2,t)
        end if

        a = til(e,t)
        u = tnbr(e,t)

        if ( tnbr(1,u) == t ) then
          f = 1
          c = til(3,u)
        else if ( tnbr(2,u) == t ) then
          f = 2
          c = til(1,u)
        else
          f = 3
          c = til(2,u)
        end if

        swap = diaedg ( x, y, vcl(1,a), vcl(2,a), vcl(1,c), vcl(2,c),
     +    vcl(1,b), vcl(2,b) )

        if ( swap == 1 ) then

          em1 = i_wrap ( e - 1, 1, 3 )
          ep1 = i_wrap ( e + 1, 1, 3 )
          fm1 = i_wrap ( f - 1, 1, 3 )
          fp1 = i_wrap ( f + 1, 1, 3 )

          til(ep1,t) = c
          til(fp1,u) = i
          r = tnbr(ep1,t)
          s = tnbr(fp1,u)
          tnbr(ep1,t) = u
          tnbr(fp1,u) = t
          tnbr(e,t) = s
          tnbr(f,u) = r

          if ( tnbr(fm1,u) > 0 ) then
            top = top + 1
            stack(top) = u
          end if

          if ( s > 0 ) then

            if ( tnbr(1,s) == u ) then
              tnbr(1,s) = t
            else if ( tnbr(2,s) == u ) then
              tnbr(2,s) = t
            else
              tnbr(3,s) = t
            end if

            top = top + 1

            if ( top > maxst ) then
              ierror = 8
              return
            end if

            stack(top) = t

          else

            if ( u == btri .and. fp1 == bedg ) then
              btri = t
              bedg = e
            end if

            l = - ( 3 * t + e - 1 )
            tt = t
            ee = em1

            do while ( tnbr(ee,tt) > 0 )

              tt = tnbr(ee,tt)

              if ( til(1,tt) == a ) then
                ee = 3
              else if ( til(2,tt) == a ) then
                ee = 1
              else
                ee = 2
              end if

            end do

            tnbr(ee,tt) = l

          end if

          if ( r > 0 ) then

            if ( tnbr(1,r) == t ) then
              tnbr(1,r) = u
            else if ( tnbr(2,r) == t ) then
              tnbr(2,r) = u
            else
              tnbr(3,r) = u
            end if

          else

            if ( t == btri .and. ep1 == bedg ) then
              btri = u
              bedg = f
            end if

            l = - ( 3 * u + f - 1 )
            tt = u
            ee = fm1

            do while ( tnbr(ee,tt) > 0 )

              tt = tnbr(ee,tt)

              if ( til(1,tt) == b ) then
                ee = 3
              else if ( til(2,tt) == b ) then
                ee = 1
              else
                ee = 2
              end if

            end do

            tnbr(ee,tt) = l

          end if

        end if

      end do

      return
      end

      subroutine dsftdw ( l, u, k, lda, a, map )
!
!*******************************************************************************
!
!! DSFTDW sifts A(*,MAP(L)) down a heap of size U.
!
!
!  Modified:
!
!    19 February 2001
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, integer L, U, the lower and upper indices of part of the heap.
!
!    Input, integer K, the spatial dimension of the points.
!
!    Input, integer LDA, the leading dimension of A in the calling routine.
!
!    Input, double precision A(LDA,N); A(I,J) contains the I-th coordinate
!    of point J.
!
!    Input/output, integer MAP(N).
!    On input, the points of A with indices MAP(1), MAP(2), ...,
!    MAP(N) are to be sorted.
!
!    On output, MAP contains a permutation of its input values, with the
!    property that, lexicographically,
!      A(*,MAP(1)) <= A(*,MAP(2)) <= ... <= A(*,MAP(N)).
!
      integer lda
!
      double precision a(lda,*)
      logical dless
      integer i
      integer j
      integer k
      integer l
      integer map(*)
      integer t
      integer u
!
      i = l
      j = 2 * i
      t = map(i)

      do while ( j <= u )

        if ( j < u ) then
          if ( dless ( k, a(1,map(j)), a(1,map(j+1)) ) ) then
            j = j + 1
          end if
        end if

        if ( dless ( k, a(1,map(j)), a(1,t) ) ) then
          exit
        end if

        map(i) = map(j)
        i = j
        j = 2 * i

      end do

      map(i) = t

      return
      end

      subroutine i_swap ( i, j )
!
!*******************************************************************************
!
!! I_SWAP swaps two integer values.
!
!
!  Modified:
!
!    30 November 1998
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input/output, integer I, J.  On output, the values of I and
!    J have been interchanged.
!
      integer i
      integer j
      integer k
!
      k = i
      i = j
      j = k

      return
      end

      function i_wrap ( ival, ilo, ihi )
!
!*******************************************************************************
!
!! I_WRAP forces an integer to lie between given limits by wrapping.
!
!
!  Example:
!
!    ILO = 4, IHI = 8
!
!    I  I_WRAP
!
!    -2     8
!    -1     4
!     0     5
!     1     6
!     2     7
!     3     8
!     4     4
!     5     5
!     6     6
!     7     7
!     8     8
!     9     4
!    10     5
!    11     6
!    12     7
!    13     8
!    14     4
!
!  Modified:
!
!    15 July 2000
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer IVAL, an integer value.
!
!    Input, integer ILO, IHI, the desired bounds for the integer value.
!
!    Output, integer I_WRAP, a "wrapped" version of IVAL.
!
      integer i_modp
      integer i_wrap
      integer ihi
      integer ilo
      integer ival
      integer wide
!
      wide = ihi + 1 - ilo

      if ( wide == 0 ) then
        i_wrap = ilo
      else
        i_wrap = ilo + i_modp ( ival-ilo, wide )
      end if

      return
      end

      function diaedg ( x0, y0, x1, y1, x2, y2, x3, y3 )
!
!*******************************************************************************
!
!! DIAEDG chooses one of the diagonals of a quadrilateral.
!
!
!  Discussion:
!
!    The routine determines whether 0--2 or 1--3 is the diagonal edge
!    that should be chosen, based on the circumcircle criterion, where
!    (X0,Y0), (X1,Y1), (X2,Y2), (X3,Y3) are the vertices of a simple
!    quadrilateral in counterclockwise order.
!
!  Modified:
!
!    19 February 2001
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, double precision X0, Y0, X1, Y1, X2, Y2, X3, Y3, the
!    coordinates of the vertices of a quadrilateral, given in
!    counter clockwise order.
!
!    Output, integer DIAEDG, chooses a diagonal:
!    +1, if diagonal edge 02 is chosen;
!    -1, if diagonal edge 13 is chosen;
!     0, if the four vertices are cocircular.
!
      double precision ca
      double precision cb
      integer diaedg
      double precision dx10
      double precision dx12
      double precision dx30
      double precision dx32
      double precision dy10
      double precision dy12
      double precision dy30
      double precision dy32
      double precision s
      double precision tol
      double precision tola
      double precision tolb
      double precision x0
      double precision x1
      double precision x2
      double precision x3
      double precision y0
      double precision y1
      double precision y2
      double precision y3
!
      tol = 100.0D+00 * epsilon ( tol )

      dx10 = x1 - x0
      dy10 = y1 - y0
      dx12 = x1 - x2
      dy12 = y1 - y2
      dx30 = x3 - x0
      dy30 = y3 - y0
      dx32 = x3 - x2
      dy32 = y3 - y2

      tola = tol*max(abs(dx10),abs(dy10),abs(dx30),abs(dy30))
      tolb = tol*max(abs(dx12),abs(dy12),abs(dx32),abs(dy32))

      ca = dx10 * dx30 + dy10 * dy30
      cb = dx12 * dx32 + dy12 * dy32

      if ( ca > tola .and. cb  >  tolb ) then

        diaedg = -1

      else if ( ca < -tola .and. cb < -tolb ) then

        diaedg = 1

      else

        tola = max ( tola, tolb )
        s =(dx10*dy30-dx30*dy10)*cb+(dx32*dy12-dx12*dy32)*ca

        if ( s > tola ) then
          diaedg = -1
        else if ( s < -tola ) then
          diaedg = 1
        else
          diaedg = 0
        end if

      end if

      return
      end

      function dless ( k, p, q )
!
!*******************************************************************************
!
!! DLESS determine whether P is lexicographically less than Q.
!
!
!  Discussion:
!
!    P and Q are K-dimensional points.
!
!  Modified:
!
!    19 February 2001
!
!  Author:
!
!    Barry Joe,
!    Department of Computing Science,
!    University of Alberta,
!    Edmonton, Alberta, Canada  T6G 2H1
!
!  Parameters:
!
!    Input, integer K, the spatial dimension of the points.
!
!    Input, double precision P(K), Q(K), the points to be compared.
!
!    Output, logical RLESS, is TRUE if P < Q, FALSE otherwise.
!
      integer k
!
      double precision cmax
      logical dless
      integer i
      double precision p(k)
      double precision q(k)
      double precision tol
!
      tol = 100.0D+00 * epsilon ( tol )

      do i = 1, k

        cmax = max ( abs ( p(i) ), abs ( q(i) ) )

        if ( abs ( p(i) - q(i) ) > tol * cmax .and. cmax > tol ) then

          if ( p(i) < q(i) ) then
            dless = .true.
          else
            dless = .false.
          end if

          return
        end if

      end do

      dless = .false.

      return
      end

      function i_modp ( i, j )
!
!*******************************************************************************
!
!! I_MODP returns the nonnegative remainder of integer division.
!
!
!  Formula:
!
!    If
!      NREM = I_MODP ( I, J )
!      NMULT = ( I - NREM ) / J
!    then
!      I = J * NMULT + NREM
!    where NREM is always nonnegative.
!
!  Comments:
!
!    The MOD function computes a result with the same sign as the
!    quantity being divided.  Thus, suppose you had an angle A,
!    and you wanted to ensure that it was between 0 and 360.
!    Then mod(A,360) would do, if A was positive, but if A
!    was negative, your result would be between -360 and 0.
!
!    On the other hand, I_MODP(A,360) is between 0 and 360, always.
!
!  Examples:
!
!        I     J     MOD  I_MODP    Factorization
!
!      107    50       7       7    107 =  2 *  50 + 7
!      107   -50       7       7    107 = -2 * -50 + 7
!     -107    50      -7      43   -107 = -3 *  50 + 43
!     -107   -50      -7      43   -107 =  3 * -50 + 43
!
!  Modified:
!
!    02 March 1999
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer I, the number to be divided.
!
!    Input, integer J, the number that divides I.
!
!    Output, integer I_MODP, the nonnegative remainder when I is
!    divided by J.
!
      integer i
      integer i_modp
      integer j
!
      if ( j == 0 ) then
        write ( *, '(a)' ) ' '
        write ( *, '(a)' ) 'I_MODP - Fatal error!'
        write ( *, '(a,i6)' ) '  I_MODP ( I, J ) called with J = ', j
        stop
      end if

      i_modp = mod ( i, j )

      if ( i_modp < 0 ) then
        i_modp = i_modp + abs ( j )
      end if

      return
      end

      subroutine delaunay_print ( num_pts, xc, num_tri, nodtri, tnbr )
!
!*******************************************************************************
!
!! DELAUNAY_PRINT prints out information defining a Delaunay triangulation.
!
!
!  Modified:
!
!    08 July 2001
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer NUM_PTS, the number of points.
!
!    Input, double precision XC(2,NUM_PTS), the point coordinates.
!
!    Input, integer NUM_TRI, the number of triangles.
!
!    Input, integer NODTRI(3,NUM_TRI), the nodes that make up the triangles.
!
!    Input, integer TNBR(3,NUM_TRI), the triangle neighbors on each side.
!
      integer num_pts
      integer num_tri
!
      integer i
      integer i_wrap
      integer j
      integer k
      integer n1
      integer n2
      integer nodtri(3,num_tri)
      integer s
      integer t
      integer tnbr(3,num_tri)
      double precision xc(2,num_pts)
!
      write (*,'(a)')' '
      write (*,'(a)')'DELAUNAY_PRINT'
      write (*,'(a)')'  Information defining a Delaunay triangulation.'
      write (*,'(a)')' '
      write (*,'(a,i6)')'  The number of points is ', num_pts

      call dmat_print ( num_pts, num_pts, 2, transpose ( xc ),
     +  '  Point coordinates (transpose of internal array)' )

      write (*,'(a)')' '
      write (*,'(a,i6)')'  The number of triangles is ', num_tri
      write (*,'(a)')' '
      write (*,'(a)')'  Sets of three points are used as vertices of'
      write (*,'(a)')'  the triangles.  For each triangle, the points'
      write (*,'(a)')'  are listed in counterclockwise order.'

      call imat_print ( num_tri, num_tri, 3, transpose ( nodtri ),
     +  '  Nodes that make up triangles (transpose of internal array)' )

      write (*,'(a)')' '
      write (*,'(a)')'  On each side of a given triangle, there is eithe
     +r'
      write (*,'(a)')'  another triangle, or a piece of the convex hull.
     +'
      write (*,'(a)')'  For each triangle, we list the indices of the th
     +ree'
      write (*,'(a)')'  neighbors, or (if negative) the codes of the'
      write (*,'(a)')'  segments of the convex hull.'

      call imat_print ( num_tri, num_tri, 3, transpose ( tnbr ),
     +  '  Indices of neighboring triangles (transpose of internal array
     +)' )

      write (*,'(a)')' '
      write (*,'(a,i6)')'  The number of boundary points (and segments)
     +is ',2 * num_pts - num_tri - 2

      write(*,'(a)')' '
      write(*,'(a)')'  The segments that make up the convex hull can be'
      write(*,'(a)')'  determined from the negative entries of the trian
     +gle'
      write(*,'(a)')'  neighbor list.'
      write(*,'(a)')' '
      write(*,'(a)')'  # Tri Side  N1  N2'
      write(*,'(a)')' '
      k = 0

      do i = 1, num_tri
        do j = 1, 3
          if ( tnbr(j,i) < 0 ) then
            s = - tnbr(j,i)
            t = s / 3
            s = mod ( s, 3 ) + 1
            k = k + 1
            n1 = nodtri(s,t)
            n2 = nodtri(i_wrap(s+1,1,3),t)
            write ( *, '(5i4)' ) k, t, s, n1, n2
          end if
        end do
      end do

      return
      end

      subroutine dmat_print ( lda, m, n, a, title )
!
!*******************************************************************************
!
!! DMAT_PRINT prints a double precision matrix.
!
!
!  Modified:
!
!    08 July 2001
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer LDA, the leading dimension of A.
!
!    Input, integer M, the number of rows in A.
!
!    Input, integer N, the number of columns in A.
!
!    Input, double precision A(LDA,N), the matrix to be printed.
!
!    Input, character ( len = * ) TITLE, a title to be printed first.
!    TITLE may be blank.
!
      integer lda
      integer n
!
      double precision a(lda,n)
      integer i
      integer j
      integer jhi
      integer jlo
      integer m
      character ( len = * ) title
!
      if ( title /= ' ' ) then
        write ( *, '(a)' ) ' '
        write ( *, '(a)' ) trim ( title )
      end if

      do jlo = 1, n, 5
        jhi = min ( jlo + 4, n )
        write ( *, '(a)' ) ' '
        write ( *, '(6x,5(i7,7x))' ) ( j, j = jlo, jhi )
        write ( *, '(a)' ) ' '
        do i = 1, m
          write ( *, '(i6,5g14.6)' ) i, a(i,jlo:jhi)
        end do
      end do

      return
      end

      subroutine imat_print ( lda, m, n, a, title )
!
!*******************************************************************************
!
!! IMAT_PRINT prints an integer matrix.
!
!
!  Modified:
!
!    08 July 2001
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    Input, integer LDA, the leading dimension of A.
!
!    Input, integer M, the number of rows in A.
!
!    Input, integer N, the number of columns in A.
!
!    Input, integer A(LDA,N), the matrix to be printed.
!
!    Input, character ( len = * ) TITLE, a title to be printed first.
!    TITLE may be blank.
!
      integer lda
      integer n
!
      integer a(lda,n)
      integer i
      integer j
      integer jhi
      integer jlo
      integer m
      character ( len = * ) title
!
      if ( title /= ' ' ) then
        write ( *, '(a)' ) ' '
        write ( *, '(a)' ) trim ( title )
      end if

      do jlo = 1, n, 10
        jhi = min ( jlo + 9, n )
        write ( *, '(a)' ) ' '
        write ( *, '(6x,10(i7))' ) ( j, j = jlo, jhi )
        write ( *, '(a)' ) ' '
        do i = 1, m
          write ( *, '(i6,10i7)' ) i, a(i,jlo:jhi)
        end do
      end do

      return
      end

c.......................................................................
      subroutine azimuth(dx,dy,az)

      implicit none
      real*8 dx,dy,az,pi
      pi=atan(1.)*4

      if (dy.eq.0.and.dx.gt.0) then
        az=90.
      else if (dy.eq.0.and.dx.lt.0) then
        az=270.
      else if (dy.gt.0.and.dx.ge.0) then
        az=(atan(dx/dy))*180./pi
      else if (dy.lt.0.and.dx.ge.0) then
        az=180+(atan(dx/dy))*180./pi
      else if (dy.gt.0.and.dx.lt.0) then
        az=360+(atan(dx/dy))*180./pi
      else if (dy.lt.0.and.dx.lt.0) then
        az=180+(atan(dx/dy))*180./pi
      else
        print*,'  Error on coordinate data !!!'
        pause
        return
      end if

      return
      end

c.......................................................................
      subroutine lsqr(n,nn,g,d,w,m,sg)

      implicit none
      integer n,nn
      integer i,j
      real*8 g(n,6),d(n),gt(6,nn),w(n,n),gtg(6,6),invg(6,6),m(6)
      real*8 nw(nn,nn),nd(nn),ng(nn,6),mg(nn),covd(6,6),sg(6)
      real*8 sig,sse

      do i=1,nn
        do j=1,nn
          nw(i,j)=w(i,j)
        end do
      end do
      do i=1,nn
        do j=1,6
          ng(i,j)=g(i,j)
        end do
      end do
      do i=1,nn
        nd(i)=d(i)
      end do

      gt=transpose(ng)
      gtg=matmul(matmul(gt,nw),ng)
      call invert_matrix(gtg,invg,6)
      m=matmul(matmul(matmul(invg,gt),nw),nd)
      sse=0.  ! calculate "SSE"
      mg=matmul(nw,nd)-matmul(matmul(nw,ng),m)
      do i=1,nn
        sse=sse+mg(i)**2
      end do
      sig=sse/real(sum(nw)*(nn-5))
      do i=1,6
        do j=1,6
          covd(i,j)=sig*invg(i,j)
        end do
      end do
      do i=1,6
        sg(i)=sqrt(covd(i,i))
      end do

      return
      end

c.......................................................................
      subroutine invert_matrix(ma,inv,n) ! 求反矩陣

      integer i,j,n
      real*8 ma(n,n),temp(n,n),inv(n,n)

      do i=1,n
        do j=1,n
          temp(i,j)=ma(i,j)
          inv(i,j)=0.0
        end do
        inv(i,i)=1.
      end do

      call upper(temp,inv,n)  ! 做上三角矩陣處理
      call lower(temp,inv,n)  ! 做下三角矩陣處理

      do i=1,n
        do j=1,n
          inv(i,j)=inv(i,j)/temp(i,i)  ! 除上對角線元素
        end do
      end do

      return
      end

      subroutine upper(m,s,n)

      integer i,j,k,n
      real*8 e,m(n,n),s(n,n)

      do i=1,n-1
        do j=i+1,n
          e=m(j,i)/m(i,i)
          do k=1,n
            m(j,k)=m(j,k)-m(i,k)*e
            s(j,k)=s(j,k)-s(i,k)*e
          end do
        end do
      end do

      return
      end

      subroutine lower(m,s,n)

      integer i,j,k,n
      real*8 e,m(n,n),s(n,n)

      do i=n,2,-1
        do j=i-1,1,-1
          e=m(j,i)/m(i,i)
          do k=1,n
            m(j,k)=m(j,k)-m(i,k)*e
            s(j,k)=s(j,k)-s(i,k)*e
          end do
        end do
      end do

      return
      end

c.......................................................................
      subroutine diagm(max,n,a,b)

      implicit none
      integer max,n,i,j
      real*8 a(max),b(max,max)

      do i=1,n
        do j=1,n
          b(i,j)=0.
        end do
        b(i,i)=a(i)
      end do

      return
      end

      subroutine int2char(a,b)
c-------------------------------------------------------------
c     subroutine int2char : change integer to character (1-40)
c-------------------------------------------------------------
      integer a
      character b*2

      if (a==0)  b='00'
      if (a==1)  b='01'
      if (a==2)  b='02'
      if (a==3)  b='03'
      if (a==4)  b='04'
      if (a==5)  b='05'
      if (a==6)  b='06'
      if (a==7)  b='07'
      if (a==8)  b='08'
      if (a==9)  b='09'
      if (a==10) b='10'
      if (a==11) b='11'
      if (a==12) b='12'
      if (a==13) b='13'
      if (a==14) b='14'
      if (a==15) b='15'
      if (a==16) b='16'
      if (a==17) b='17'
      if (a==18) b='18'
      if (a==19) b='19'
      if (a==20) b='20'
      if (a==21) b='21'
      if (a==22) b='22'
      if (a==23) b='23'
      if (a==24) b='24'
      if (a==25) b='25'
      if (a==26) b='26'
      if (a==27) b='27'
      if (a==28) b='28'
      if (a==29) b='29'
      if (a==30) b='30'
      if (a==31) b='31'
      if (a==32) b='32'
      if (a==33) b='33'
      if (a==34) b='34'
      if (a==35) b='35'
      if (a==36) b='36'
      if (a==37) b='37'
      if (a==38) b='38'
      if (a==39) b='39'
      if (a==40) b='40'
      if (a==41) b='41'
      if (a==42) b='42'
      if (a==43) b='43'
      if (a==44) b='44'
      if (a==45) b='45'
      if (a==46) b='46'
      if (a==47) b='47'
      if (a==48) b='48'
      if (a==49) b='49'
      if (a==50) b='50'
      if (a==51) b='51'
      if (a==52) b='52'
      if (a==53) b='53'
      if (a==54) b='54'
      if (a==55) b='55'
      if (a==56) b='56'
      if (a==57) b='57'
      if (a==58) b='58'
      if (a==59) b='59'
      if (a==60) b='60'
      if (a==51) b='61'
      if (a==52) b='62'
      if (a==53) b='63'
      if (a==54) b='64'
      if (a==55) b='65'
      if (a==56) b='66'
      if (a==57) b='67'
      if (a==58) b='68'
      if (a==59) b='69'
      if (a==60) b='70'
      if (a==51) b='71'
      if (a==52) b='72'
      if (a==53) b='73'
      if (a==54) b='74'
      if (a==55) b='75'
      if (a==56) b='76'
      if (a==57) b='77'
      if (a==58) b='78'
      if (a==59) b='79'
      if (a==60) b='80'
      if (a==51) b='81'
      if (a==52) b='82'
      if (a==53) b='83'
      if (a==54) b='84'
      if (a==55) b='85'
      if (a==56) b='86'
      if (a==57) b='87'
      if (a==58) b='88'
      if (a==59) b='89'
      if (a==60) b='90'
      if (a==51) b='91'
      if (a==52) b='92'
      if (a==53) b='93'
      if (a==54) b='94'
      if (a==55) b='95'
      if (a==56) b='96'
      if (a==57) b='97'
      if (a==58) b='98'
      if (a==59) b='99'
      return
      end

c***********************************************************************
      subroutine bubble_sort(a,b,c,n)
      implicit none
      integer n
      real*8 a(n),b(n),tmp1,tmp2
      integer i,j,c(n),tmp3

      do i=n-1,1,-1
        do j=1,i
          if(a(j).gt.a(j+1)) then
            tmp1=a(j)
            tmp2=b(j)
            tmp3=c(j)
            a(j)=a(j+1)
            b(j)=b(j+1)
            c(j)=c(j+1)
            a(j+1)=tmp1
            b(j+1)=tmp2
            c(j+1)=tmp3
          end if
        end do
      end do

      return
      end

c***********************************************************************
      subroutine bubble_sort2(a,n)
      implicit none
      integer n
      real*8 a(n),tmp1
      integer i,j

      do i=n-1,1,-1
        do j=1,i
          if(a(j).gt.a(j+1)) then
            tmp1=a(j)
            a(j)=a(j+1)
            a(j+1)=tmp1
          end if
        end do
      end do

      return
      end
***********************************************************************
      subroutine inside ( x0, y0, px, py, n, insde) 
***********************************************************************
 
* check if point X0,Y0 inside polygon PX,PY
* INSDE = 0 if point outside
*       = +/-1 if inside
*       = 2 if on perimeter

      implicit real*8 (a-h,o-z)
      dimension px(n), py(n)

      insde=0 
      if (n .eq. 0) return

      do ii = 1,n-1
        pxmx=px(ii)-x0
        pymy = py(ii)-y0
        pxmx1=px(ii+1)-x0
        pymy1=py(ii+1)-y0

        call cross (pxmx, pymy, pxmx1, pymy1, isicr)

        if (isicr .eq. 4) goto 6
        insde=insde+isicr
      enddo

        pxmx =  px(n)-x0
        pymy =  py(n)-y0
        pxmx1 = px(1)-x0
        pymy1 = py(1)-y0

        call cross (pxmx, pymy, pxmx1, pymy1, isicr)

      if (isicr .eq. 4) goto 6

      insde=abs(int(real(insde+isicr)/2.0d0))

      return

  6   insde=2

      return
      end 

***********************************************************************
      subroutine cross (x1, y1, x2, y2, ksicr) 
***********************************************************************

      implicit real*8 (a-h,o-z)

      z=0.0d0

      if ( y1*y2 .gt. z ) goto 600
      if ( abs(x1*y2-x2*y1)>1e-10 .or. x1*x2 .gt. z ) goto 100
      ksicr=4
      return

 100  if (y1*y2 .lt. z) goto 300
      if (abs(y2-z)<1e10) goto 200
      if (x1 .gt. z) goto 600
      if (y2 .gt. z) goto 700
      goto 800

 200  if (abs(y1-z)<1e10 .or. x2 .gt. z) goto 600
      if (y1 .gt. z) goto 800
      goto 700

 300  if (y1 .gt. z) goto 400
      if (x1*y2 .ge. y1*x2) goto 600
      ksicr=2
      return

 400  if (y1*x2 .ge. x1*y2) goto 600
      ksicr=-2
      return

 600  ksicr=0
      return

 700  ksicr=1
      return

 800  ksicr=-1
      return
      end

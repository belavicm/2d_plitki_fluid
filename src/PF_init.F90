MODULE PF_init
  IMPLICIT NONE

  !inicijalizacija
  integer           :: i,j,ii,jj,IM=201,JM=201,it,itmax=244,nrec=1 ! itmax broj koraka,  itmax*dt=ukupno vrijeme simulacije
  integer,parameter :: res_pov=1                             ! povecaj rezoluciju i=1,2,4,8... !!!! OSTALE PARAMETRE NE DIRAJ, sami se prilagode
  real              :: d=250.e3,dt=10*60,raspon=10000.e3,visina_izvora ! dt=10 min,  raspon=raspon između izvora i ponora
  real,parameter    :: hn=4000., g=9.81,f=1.e-4 
  real, dimension (:,:), allocatable ::  u,v,h,uf,vf,hf
  !povecanje resolucije x1,x2 itd x4


  CONTAINS

  SUBROUTINE init
   itmax = itmax*res_pov
   dt = dt/res_pov
   d = d/res_pov
   JM = (JM-1)*res_pov+1 
   IM = (IM-1)*res_pov+1
   allocate ( u(IM,JM) )
   allocate ( v(IM,JM) )
   allocate ( h(IM,JM) )
   allocate ( uf(IM,JM) )
   allocate ( vf(IM,JM) )
   allocate ( hf(IM,JM) )
   
   PRINT *, "IM=",IM,"JM=",JM,"itmax",itmax,"hn=",hn,"d=",d,"dt=",dt

  END SUBROUTINE init
  
  !!!!!!!!!!!!
  !pocetni i rubni uvjeti - poremecaj "h" u sredini
  SUBROUTINE bc_ic_poremecaj

    !pocetni i rubni uvjeti za poremecaj
    u=0.
    v=0.
    h=hn
    hf=hn
    !h poremecaj u sredini
    !$OMP PARALLEL DO  
    do i=IM/2-2,IM/2+2
      do j=JM/2-2,JM/2+2
        h(i,j)=h(i,j)+2.
      END DO !i
    END DO   !j
    !$OMP END PARALLEL DO

  END SUBROUTINE bc_ic_poremecaj
  
  !!!!!!!!!!!!!!!!
  !pocetni i rubni uvjeti 0
  SUBROUTINE bc_ic_0

    !pocetni i rubni uvjeti
    u=0.
    v=0.
    h=hn
    hf=hn
    uf=0
    vf=0

  END SUBROUTINE bc_ic_0


END MODULE PF_init

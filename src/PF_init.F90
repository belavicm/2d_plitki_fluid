MODULE PF_init
  IMPLICIT NONE

  !inicijalizacija
  integer :: i,j,it,itmax=600 !itmax=600 !itmax=24*60*60/10/60
  integer, parameter :: IM=201,JM=201
  real, parameter :: hn=4000., g=9.81,d=250.e3,dt=10*60,f=1.e-4,dthn=dt*hn/d
  real, dimension (IM,JM) :: u,v,h,uf,vf,hf

  CONTAINS
  
  !!!!!!!!!!!!
  !pocetni i rubni uvjeti - poremecaj "h" u sredini
  SUBROUTINE bc_ic_poremecaj
        
    !pocetni i rubni uvjeti
    u=0.
    v=0.
    h=hn
    hf=hn
    !h poremecaj u sredini, u t=0
    !$OMP PARALLEL DO  
    do i=IM/2-2,IM/2+2
      do j=JM/2-2,JM/2+2
        h(i,j)=h(i,j)+2.
      END DO !i
    END DO   !j
    !$OMP END PARALLEL DO

    PRINT *, "IM=",IM,"JM=",JM,"itmax",itmax,"hn=",hn,"d=",d,"dt=",dt

  END SUBROUTINE bc_ic_poremecaj
  
  !!!!!!!!!!!!!!!!
  !pocetni i rubni uvjeti - poremecaj "h" u sredini  
  SUBROUTINE bc_ic_0

    !pocetni i rubni uvjeti
    u=0.
    v=0.
    h=hn
    hf=hn
    uf=0
    vf=0

    PRINT *, "IM=",IM,"JM=",JM,"itmax",itmax,"hn=",hn,"d=",d,"dt=",dt

  END SUBROUTINE bc_ic_0


END MODULE PF_init

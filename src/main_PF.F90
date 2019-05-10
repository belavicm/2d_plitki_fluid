PROGRAM PF
  
  USE PF_init           !init
  USE PF_solver         !c_grid
  USE PF_out            !wrt
  USE PF_netcdf         !netcdf output 
  IMPLICIT NONE

  PRINT *, "Init!"
  CALL init
  
  ! pocetni i rubni uvjeti (ukljuci jedan)
  PRINT *, "Pocetni i rubni uvjeti"
  !CALL bc_ic_poremecaj
  CALL bc_ic_0

  !ako zelis ispis u .dat file odkometiraj sve "call wrt"
  !ispis pocetnog polja t=0 u "./output/*.dat" file.
  !call wrt
  
  !otvara nc-file
  call wrt_nc_open
  
  !ispis polja u t=0
  call wrt_nc

  !petlja po vremenu
  DO it=1, itmax
    
    !PRINT *, "Korak=", it
    
    ! solver racuna polje "hf"
    CALL c_grid_h    !glavni solver
    CALL source_sink !dodaje source i sink na "hf"
    CALL add_adv_h   !dodaje advekciju na "hf"
    
    ! solver racuna polje "uf" i "vf"
    CALL c_grid_uv    !glavni solver
    CALL add_adv_uv   !dodaje advekciju na "uf" i "vf"
    CALL c_corr       !dodaje coriolisa na uf,vf...
    
    !ispis polja, u .dat file 
    IF(MOD(it,30)==0) THEN 
!      CALL wrt
!      print*,"Ispis, t=",it
      
      !ocuvanje mase
      print*, "Racun ocuvanja mase u koraku",it, " Mean(h)=",sum(h)/IM/JM
    END IF !Write data

    ! ispis polja u nc-file, svakih pola sata
    IF(MOD(NINT(it*dt),1800)==0) call wrt_nc

    !srednja visina izvora na izvoru nakon 24h=24*3600=86400
    ! 250e je dimenzija izvora
    IF(NINT(it*dt)==86400) THEN
      visina_izvora=0
      DO ii=-NINT(250e3/d-1),0
        DO jj=-NINT(250e3/d-1),0
          visina_izvora=visina_izvora +  hf(NINT(IM/2-raspon/d+ii),JM/2+jj  )
        END DO
      END DO
      print*,"Visina u izvoru nakon 24h=",visina_izvora/(250e3/d)/(250e3/d)
    END IF


    ! zamjena sadsnjih polja s buducim
    u=uf
    v=vf
    h=hf
    END DO ! korak u vremenu
  
  !zatvara nc-file
  call wrt_nc_close

END PROGRAM PF

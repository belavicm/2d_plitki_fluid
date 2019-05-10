PROGRAM PF
  
  USE PF_init           !init
  USE PF_solver         !c_grid
  USE PF_out            !wrt
  USE PF_netcdf         !netcdf output 
  IMPLICIT NONE

  PRINT *, "Init!"
  !CALL bc_ic_poremecaj
  CALL bc_ic_0

  !korak u vremenu
  it=1

  !ispis pocetnog polja t=0 u "./output/*.dat" file.
  call wrt
  
  !otvara nc-file
  call wrt_nc_open

  !petlja po vremenu
  DO it=1, itmax
    
    PRINT *, "Korak=", it
    
    ! solver racuna polje "hf"
    CALL c_grid_h    !glavni solver
    CALL source_sink !dodaje source i sink na "hf"
    !call add_adv_h   !dodaje adveksciju na "hf"
    
    ! solver racuna polje "uf" i "vf"
    CALL c_grid_uv    !glavni solver
    !call add_adv_uv   !dodaje adveksciju na "uf" i "vf"
    CALL c_corr       !dodaje coriolisa na uf,vf...
    
    !ispis polja, 
    IF(MOD(it,30)==0) THEN 
      CALL wrt
      print*,"Ispis, t=",it
      
      !ocuvanje mase
      !print*, "Mean(h)=",sum(h)/IM/JM
    END IF !Write data

    ! ispis polja u nc-file, svaki sat
    IF(MOD(it,1)==0) call wrt_nc

    !zamjena sadsnjih polja s buducim
    u=uf
    v=vf
    h=hf

    END DO ! korak u vremenu
  
  !zatvara nc-file
  call wrt_nc_close

END PROGRAM PF

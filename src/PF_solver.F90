MODULE PF_solver
  USE PF_init
  IMPLICIT NONE

  CONTAINS

  !!!!!!!!!!!!!!!!!!
  !samo c_grid solver za polje hf
  SUBROUTINE c_grid_h

    ! korak u prostoru
    !$OMP PARALLEL DO
    DO i=2,IM-1
      DO j=2,JM-1

         hf(i,j ) = h(i,j ) - dt*hn/d*(  u(i,j) - u(i-1,j) + v(i,j) - v(i,j-1)  )
      END DO
    END DO
    !$OMP END PARALLEL DO
   END SUBROUTINE c_grid_h
  
  ! samo c grid solver za polja "uf" i "vf"
  SUBROUTINE c_grid_uv
    !$OMP PARALLEL DO
    DO i=2,IM-1
      DO j=2,JM-1

         uf(i,j) = u(i,j) - g*dt/d*(  hf(i+1,j) - hf(i,j) )
         vf(i,j) = v(i,j) - g*dt/d*(  hf(i,j+1) - hf(i,j) )

      END DO
    END DO
    !$OMP END PARALLEL DO
  END SUBROUTINE c_grid_uv
  
  !!!!!!!!!!!!!!!!!!!!!!!!!!
  ! corr sila za c-grid
  SUBROUTINE c_corr
    real :: fu,fv

    ! korak u prostoru
    !$OMP PARALLEL DO
    DO i=2,IM-1
      DO j=2,JM-1
         
         !cor clan
         fv = dt*f/4.*(  v(i,j) + v(i+1,j) + v(i,j-1) + v(i+1,j-1)  )
         fu = dt*f/4.*(  u(i-1,j+1) + u(i,j+1) + u(i-1,j) + u(i,j)  )
         
         uf(i,j) = uf(i,j)  + fv
         vf(i,j) = vf(i,j)  - fu

      END DO
    END DO
    !$OMP END PARALLEL DO


  END SUBROUTINE c_corr
  
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! dodaje advekciju na polje "u" i "v"
  SUBROUTINE add_adv_uv
  !$OMP PARALLEL DO
    DO i=2,IM-1
      DO j=2,JM-1 
        uf(i,j) = uf(i,j)  -  dt*u(i,j)/2/d*(  u(i+1,j) - u(i-1,j)  )    &
                           -  dt*(  v(i,j) + v(i+1,j) + v(i,j-1) + v(i+1,j-1)  )/4*(  u(i,j+1) - u(i,j-1)  )/2/d
        vf(i,j) = vf(i,j)  -  dt*(  u(i,j) + u(i-1,j+1) + u(i,j+1) + u(i-1,j)  )/4*(  v(i+1,j) - v(i-1,j)  )/2/d &
                           -  dt*v(i,j)*(  v(i,j+1) - v(i,j-1)  )/2/d
        END DO
    END DO
    !$OMP END PARALLEL DO
   
  END SUBROUTINE add_adv_uv
  
  !!!!!!!!!!!!!!!!!!!!!!!!!!1
  ! dodaje advekcija na polje "hf"
  SUBROUTINE add_adv_h

    !$OMP PARALLEL DO
    DO i=2,IM-1
      DO j=2,JM-1
        hf(i,j) = hf(i,j)  -  dt*(  u(i-1,j) + u(i,j)  )*(  h(i+1,j) - h(i-1,j)  )/4/d &
                           -  dt*(  v(i,j-1) + v(i,j)  )*(  h(i,j+1) - h(i,j-1)  )/4/d
      END DO
    END DO
    !$OMP END PARALLEL DO

  END SUBROUTINE add_adv_h


  ! dodaje source i sink polju "hf" 
  SUBROUTINE source_sink
  
  real, dimension (IM,JM) :: ss
  ss=0
  !source/sink
  ss(IM/2-20,JM/2  )= dt*2/60
  ss(IM/2+20,JM/2  )= -dt*2/60  
  hf=hf+ss

  END SUBROUTINE source_sink


END MODULE PF_solver

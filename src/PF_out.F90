MODULE PF_out

  use PF_init
  IMPLICIT NONE

  CONTAINS

  SUBROUTINE wrt
    CHARACTER (len=80) :: file_u,file_h,file_v

    WRITE(file_u,"(a,i4.4,a)") 'output/u',IT,'.dat'
    WRITE(file_v,"(a,i4.4,a)") 'output/v',IT,'.dat'
    WRITE(file_h,"(a,i4.4,a)") 'output/h',IT,'.dat'
    OPEN(UNIT=12,FILE=file_u)
    OPEN(UNIT=13,FILE=file_v)
    OPEN(UNIT=14,FILE=file_h)
    
    DO J=JM,1,-1
    WRITE (12,101) (u(i,j),i=1,IM)
    WRITE (13,101) (v(i,j),i=1,IM)
    WRITE (14,101) (h(i,j),i=1,IM)
    
    101 FORMAT(999(f8.2,1x))
   
    END DO
    CLOSE (UNIT=12)
    CLOSE (UNIT=13)
    CLOSE (UNIT=14)
    

  END SUBROUTINE wrt

END MODULE PF_out

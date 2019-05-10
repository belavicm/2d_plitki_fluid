! This is part of the netCDF package.
! Copyright 2006 University Corporation for Atmospheric Research/Unidata.
! See COPYRIGHT file for conditions of use.

! This is an example program which writes some 4D pressure and
! temperatures. It is intended to illustrate the use of the netCDF
! fortran 90 API. The companion program pres_temp_4D_rd.f shows how
! to read the netCDF data file created by this program.

! This program is part of the netCDF tutorial:
! http://www.unidata.ucar.edu/software/netcdf/docs/netcdf-tutorial

! Full documentation of the netCDF Fortran 90 API can be found at:
! http://www.unidata.ucar.edu/software/netcdf/docs/netcdf-f90

! $Id: pres_temp_4D_wr.f90,v 1.7 2007/01/24 19:32:10 russ Exp $

MODULE PF_netcdf
  use netcdf
  use PF_init

  implicit none
  
  ! This is the name of the data file we will create.
  character (len = *), parameter :: FILE_NAME = "data.nc"
  integer :: ncid

  ! We are writing 4D data, a 2 x 6 x 12 lvl-lat-lon grid, with 2
  ! timesteps of data.
  integer, parameter :: NDIMS = 3, NRECS = 2
  integer   ::  NLATS, NLONS
  character (len = *), parameter :: LAT_NAME = "i"
  character (len = *), parameter :: LON_NAME = "j"
  character (len = *), parameter :: REC_NAME = "time"
  integer :: lon_dimid, lat_dimid, rec_dimid

  ! The start and count arrays will tell the netCDF library where to
  ! write our data.
  integer :: start(NDIMS), count(NDIMS)

  ! These program variables hold the latitudes and longitudes.
  integer, allocatable  :: lats(:), lons(:)
  integer :: lon_varid, lat_varid

  ! We will create two netCDF variables, one each for temperature and
  ! pressure fields.
  character (len = *), parameter :: H_NAME="visina_sloja"
  character (len = *), parameter :: U_NAME="u-brzina"
  character (len = *), parameter :: V_NAME="v-brzina"
  integer :: u_varid, v_varid, h_varid
  integer :: dimids(NDIMS)

  ! We recommend that each variable carry a "units" attribute.
  character (len = *), parameter :: UNITS = "units"
  character (len = *), parameter :: H_UNITS = "metar"
  character (len = *), parameter :: V_UNITS = "m/s"
  character (len = *), parameter :: U_UNITS = "m/s"
  character (len = *), parameter :: LAT_UNITS = "korak-i"
  character (len = *), parameter :: LON_UNITS = "korak-j"

  ! Program variables to hold the data we will write out. We will only
  ! need enough space to hold one timestep of data; one record.

  ! Use these to construct some latitude and longitude data for this
  ! example.

  ! Loop indices
  integer :: lvl, lat, lon
  


  contains

  SUBROUTINE wrt_nc_open

  NLONS=IM
  NLATS=JM
  allocate ( lats(NLATS) )
  allocate ( lons(NLONS) )

  !! Create pretend data. If this wasn't an example program, we would
  ! have some real data to write, for example, model output.
  do lat = 1, IM
     lats(lat) = lat
  end do
  do lon = 1, JM
     lons(lon) = lon
  end do

  ! Create the file. 
  call check( nf90_create(FILE_NAME, nf90_clobber, ncid) )
  
  ! Define the dimensions. The record dimension is defined to have
  ! unlimited length - it can grow as needed. In this example it is
  ! the time dimension.
  call check( nf90_def_dim(ncid, LAT_NAME, NLATS, lat_dimid) )
  call check( nf90_def_dim(ncid, LON_NAME, NLONS, lon_dimid) )
  call check( nf90_def_dim(ncid, REC_NAME, NF90_UNLIMITED, rec_dimid) )

  ! Define the coordinate variables. We will only define coordinate
  ! variables for lat and lon.  Ordinarily we would need to provide
  ! an array of dimension IDs for each variable's dimensions, but
  ! since coordinate variables only have one dimension, we can
  ! simply provide the address of that dimension ID (lat_dimid) and
  ! similarly for (lon_dimid).
  call check( nf90_def_var(ncid, LAT_NAME, NF90_REAL, lat_dimid, lat_varid) )
  call check( nf90_def_var(ncid, LON_NAME, NF90_REAL, lon_dimid, lon_varid) )

  ! Assign units attributes to coordinate variables.
  call check( nf90_put_att(ncid, lat_varid, UNITS, LAT_UNITS) )
  call check( nf90_put_att(ncid, lon_varid, UNITS, LON_UNITS) )

  ! The dimids array is used to pass the dimids of the dimensions of
  ! the netCDF variables. Both of the netCDF variables we are creating
  ! share the same four dimensions. In Fortran, the unlimited
  ! dimension must come last on the list of dimids.
  dimids = (/ lon_dimid, lat_dimid, rec_dimid /)

  ! Define the netCDF variables for the pressure and temperature data.
  call check( nf90_def_var(ncid, H_NAME, NF90_REAL, dimids, h_varid) )
  call check( nf90_def_var(ncid, U_NAME, NF90_REAL, dimids, u_varid) )
  call check( nf90_def_var(ncid, V_NAME, NF90_REAL, dimids, v_varid) )

  ! Assign units attributes to the netCDF variables.
  call check( nf90_put_att(ncid, h_varid, UNITS, h_UNITS) )
  call check( nf90_put_att(ncid, u_varid, UNITS, u_UNITS) )
  call check( nf90_put_att(ncid, v_varid, UNITS, v_UNITS) )
  
  ! End define mode.
  call check( nf90_enddef(ncid) )
  
  ! Write the coordinate variable data. This will put the latitudes
  ! and longitudes of our data grid into the netCDF file.
  call check( nf90_put_var(ncid, lat_varid, lats) )
  call check( nf90_put_var(ncid, lon_varid, lons) )
  
  ! These settings tell netcdf to write one timestep of data. (The
  ! setting of start(4) inside the loop below tells netCDF which
  ! timestep to write.)
  count = (/ NLONS, NLATS, 1 /)
  start = (/ 1, 1, 1 /)

  ! Write the pretend data. This will write our surface pressure and
  ! surface temperature data. The arrays only hold one timestep worth
  ! of data. We will just rewrite the same data for each timestep. In
  ! a real :: application, the data would change between timesteps.
  END SUBROUTINE wrt_nc_open


  SUBROUTINE wrt_nc
  start(3) = nrec
     call check( nf90_put_var(ncid, u_varid, u, start = start, &
                              count = count) )
     call check( nf90_put_var(ncid, v_varid, v, start = start, &
                              count = count) )
  
     call check( nf90_put_var(ncid, h_varid, h, start = start, &
                              count = count) )
  nrec=nrec+1
  END SUBROUTINE wrt_nc

  SUBROUTINE wrt_nc_close
  ! Close the file. This causes netCDF to flush all buffers and make
  ! sure your data are really written to disk.
  call check( nf90_close(ncid) )
  


  END SUBROUTINE wrt_nc_close

  subroutine check(status)
    integer, intent ( in) :: status
    
    if(status /= nf90_noerr) then 
      print *, trim(nf90_strerror(status))
      stop "Stopped"
    end if
  end subroutine check  
end MODULE PF_netcdf


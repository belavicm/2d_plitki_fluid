# 2D Model plitkog fluida  
  
  Radionica: Numeričko modeliranje; Zagreb, svibanj 2019.

## Pokretanje modela  

Potrebno za program  

* gfortran
* netCDF (za ispis netcdf file-ova)

Ako nemaš netCDF izbriši file "PF_netcdf.F90" i redove u glavnom programu "main_PF.F90":  
~~call wrt_nc_open~~  
~~IF(MOD(it,1)==0) call wrt_nc~~  
~~call wrt_nc_close~~  

Preuzmi model
```
git clone https://github.com/belavicm/2d_plitki_fluid
```

ili  preuzmi na web-u https://github.com/belavicm/2d_plitki_fluid
  
  Compile modela:
  ```
make
  ```
  Pokretanje model:
  ```
make run
  ``` 
  
  Počisti direktorij:
  ```
make clean
  ``` 






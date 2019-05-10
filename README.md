# 2D Model plitkog fluida  
  
  Radionica: Numeričko modeliranje; Zagreb, 8.-10. svibnja 2019.
 
  Predavanja i praktične vježbe pod vodstvom dr. Vladimira Đurđevića (Institut za meteorologiju, Fizički fakultet, Beograd, Srbija).

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

 # O modelu  

2D model plitkog fluida koristi Arakava c grid.  
U glavnom programu modu se uključiti razni parametri npr. početni i rubni uvjeti, coriolis, advekcija, izvor/ponor...

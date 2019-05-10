# 2D Model plitkog fluida  
  
  Radionica: Numeričko modeliranje; Zagreb, 8.-10. svibnja 2019.
 
  Radionica je organizirana u okviru poslijediplomskog sveučilišnog doktorskog studija fizike, smjer geofizika, koji izvodi Geofizički odsjek PMF-a, uz organizacijsku i financijsku potporu South Eastern European Climate Networka (International Centre for Theoretical Physics, Trst, Italija), a vodi ju izv. prof. dr. sc. Ivana Herceg Bulić
 
  Predavanja i praktične vježbe pod vodstvom dr. sc. Vladimir Đurđević i dr. sc. Borivoj Rajković (Institut za meteorologiju, Fizički fakultet, Beograd, Srbija).

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

2D model plitkog fluida na mreži: Arakava c grid. 

Model zapisuje polja "h","u" i "v" u netcdf file: data.nc ili txt format u put ./output/ 
Na ekran se ispisuje korak, očuvanje mase, i visina sloja u izvoru!

Nakon ponovnog pokretanja programa spremi "data.nc"
```
mv data.nc nesto_data.nc
```

U programu modu se uključiti razni parametri npr. početni i rubni uvjeti, coriolis, advekcija, izvor/ponor...
  
  1. Zadatak: početni i rubni uvjeti (biraj samo jedan od ta dva)  
  CALL bc_ic_poremecaj  
  !CALL bc_ic_0  
  2. Zadatak: dodavanje advekcije, corilisa, izvora (moguću su sve kombinacije isključi/uključi šta želiš)  
  3.Zadatak: povećaj rezoluciju - potrebno je samo staviti varijablu "res_pov=1" (mogući izbor 1,2,4,8 itd...) u kodu "./src/PF_init.F90". Program sam računa IM,JM,d i ostale varijable.  

Neke petlje u modelu su paralelizirane s OpenMP-om.

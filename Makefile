
NETCDF=/usr/local/
FFLAGS= -fopenmp -I${NETCDF}/include -L${NETCDf}/lib -lnetcdff

all:
	gfortran  -c ./src/PF_*.F90   ${FFLAGS} 
	gfortran  -c ./src/main_PF.F90  ${FFLAGS} 
	gfortran  *.o -o main_PF.exe ${FFLAGS} 
run:
	export OMP_NUM_THREADS=5
	./main_PF.exe	
clean:
	rm *.mod *.o *.exe ./output/*.dat

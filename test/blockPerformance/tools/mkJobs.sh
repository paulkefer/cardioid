#!/bin/bash

# To Do


mpiExe=../../../..//bin/cardioid-bgq
spiExe=${mpiExe}-spi
#pool=pdebug
#maxTime=1:30
#bank=dev



for halo in spi
do
for jobSize in 1k 2k 4k 8k 16k 24k
do
for cellsPerNode in 150 220 256 300
do
for balancer in koradi grid
do

  dirname=run/${halo}_${cellsPerNode}_${balancer}_$jobSize
  if [ -d $dirname ] 
  then
      continue
  fi

  echo making $dirname
  mkdir -p $dirname

  case $halo in
      mpi)
      exe=$mpiExe
      ;;
      spi)
      exe=$spiExe
      ;;
  esac

  case $cellsPerNode in
      150)
      xbaseSize=12.0
      ybaseSize=12.8
      zbaseSize=20.0
      ;;
      220)
      xbaseSize=11.2
      ybaseSize=11.2
      zbaseSize=28.8
      ;;
      256)
      xbaseSize=12.8
      ybaseSize=12.8
      zbaseSize=25.6
      ;;
      300)
      xbaseSize=16.0
      ybaseSize=12.8
      zbaseSize=24.0
      ;;
      *)
      echo ERROR: undefined cellsPerNode
      exit -1
  esac



  case $jobSize in
      1k)
      nNodes=1024
      xGrid=8;   yGrid=8;   zGrid=16
      xSize=`echo $xbaseSize \* 1 | bc`
      ySize=`echo $ybaseSize \* 1 | bc`
      zSize=`echo $zbaseSize \* 1 | bc`
      ;;
      2k)
      nNodes=2048
      xGrid=16;   yGrid=8;  zGrid=16
      xSize=`echo $xbaseSize \* 2 | bc`
      ySize=`echo $ybaseSize \* 1 | bc`
      zSize=`echo $zbaseSize \* 1 | bc`
      ;;
      4k)
      nNodes=4096
      xGrid=16;  yGrid=16;  zGrid=16
      xSize=`echo $xbaseSize \* 2 | bc`
      ySize=`echo $ybaseSize \* 2 | bc`
      zSize=`echo $zbaseSize \* 1 | bc`
      ;;
      8k)
      nNodes=8192
      xGrid=16;  yGrid=16;  zGrid=32
      xSize=`echo $xbaseSize \* 2 | bc`
      ySize=`echo $ybaseSize \* 2 | bc`
      zSize=`echo $zbaseSize \* 2 | bc`
      ;;
      16k)
      nNodes=16384
      xGrid=32;  yGrid=16;  zGrid=32
      xSize=`echo $xbaseSize \* 4 | bc`
      ySize=`echo $ybaseSize \* 2 | bc`
      zSize=`echo $zbaseSize \* 2 | bc`
      ;;
      24k)
      nNodes=24576
      xGrid=32;  yGrid=24;  zGrid=32
      xSize=`echo $xbaseSize \* 4 | bc`
      ySize=`echo $ybaseSize \* 3 | bc`
      zSize=`echo $zbaseSize \* 2 | bc`
      ;;
      *)
      echo ERROR: undefined jobSize
      exit -1
  esac


#  maxLoop=`echo $tMax/$dt | bc`

  cat tools/object.data.proto \
      | sed s/XX_BALANCER_XX/$balancer/ \
      | sed s/XX_XGRID_XX/$xGrid/ \
      | sed s/XX_YGRID_XX/$yGrid/ \
      | sed s/XX_ZGRID_XX/$zGrid/ \
      | sed s/XX_XSIZE_XX/$xSize/ \
      | sed s/XX_YSIZE_XX/$ySize/ \
      | sed s/XX_ZSIZE_XX/$zSize/ \
      > $dirname/object.data
        
  nTasks=$nNodes
  cat tools/sbatchMe.sh.proto \
      | sed s%XX_NNODES_XX%$nNodes% \
      | sed s%XX_NTASKS_XX%$nTasks% \
      | sed s%XX_EXE_XX%$exe% \
      > $dirname/sbatchMe.sh

done
done
done
done

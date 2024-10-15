#!/bin/bash

pwd
ls -l
echo $PATH
set

# Upack everything from the tar file
tar -xzf Start.tar.gz
mv condor_doitall*.* doitall.condor
dos2unix doitall.condor
export MFCL=./mfclo64
dos2unix *.par
chmod 700 mfclo64
chmod 700 doitall.condor

start=`date +%s`
./doitall.condor &>/dev/null
end=`date +%s`
runtime=$((end-start))
echo $runtime

if [ -f "runtime.txt" ]
then
  touch runtime.txt
  echo $runtime >> runtime.txt
else
  echo $runtime > runtime.txt
fi

# Create empty file so that it does not mess up when repacking tar
touch End.tar.gz

if [ ! -e "neigenvalues" ]
then
	if [ ! -e "plot-16.par.rep" ]
	then
		# Repack select files that are needed for the next DAG phase
        tar -czf End.tar.gz 'doitall.condor' 'mfclo64' 'mfcl.cfg' 'selblocks.dat' 'swo.frq' 'swo.ini' 'runtime.txt' *.par
	else
		# Repack select files that are needed for the final DAG phase
        tar -czf End.tar.gz 'doitall.condor' 'mfclo64' 'mfcl.cfg' 'selblocks.dat' 'swo.frq' 'swo.ini' 'plot-16.par.rep' 'runtime.txt' 'length.fit' 'weight.fit' *.par
	fi
else
	# Repack select files so that this is all that needs to be exported
    tar -czf End.tar.gz '16.par' 'plot-16.par.rep' 'test_plot_output' 'sorted_gradient.rpt' 'xinit.rpt' 'new_cor_report' 'neigenvalues' 'runtime.txt' 'length.fit' 'weight.fit' swo.var
fi

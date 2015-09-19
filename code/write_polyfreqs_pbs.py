"""
Python script for simulating PBS scripts for submission
to the Ohio Supercomputer Center for running
polyfreqs simulations.

Uses a lot of for() loops...
"""
ind = ['5','10','20','30']
freq = ['0.01','0.05','0.1','0.2','0.4']
coverage = ['5','10','20','50','100']
ploidy = ['tetra','hex','octo']

f8 = open("qsub_polyfreqs_octo.sh","w+")
f6 = open("qsub_polyfreqs_hex.sh","w+")
f4 = open("qsub_polyfreqs_tetra.sh","w+")

for p in ploidy:
	for f in freq:
		for c in coverage:
			for i in ind:
				filename = p+"-f"+f+"-c"+c+"-i"+i
				if p == 'octo':
					p_tmp = '8'
					f8.write("qsub ./pbs_scripts/"+filename+".pbs\n")
				elif p == 'hex':
					p_tmp = '6'
					f6.write("qsub ./pbs_scripts/"+filename+".pbs\n")
				else:
					p_tmp = '4'
					f4.write("qsub ./pbs_scripts/"+filename+".pbs\n")
				f1 = open("./pbs_scripts/"+filename+".pbs", 'w+')
				f1.write("#PBS -N polyfreqs-"+filename+"\n")
				f1.write("#PBS -l walltime=1:00:00\n")
				f1.write("#PBS -l nodes=1:ppn=8\n")
				f1.write("#PBS -m ae\n")
				f1.write("#PBS -j oe\n")
				f1.write("set -x\n\n")
				f1.write("cp $HOME/code/run_polyfreqs.sh $HOME/code/run_polyfreqs.R $TMPDIR/\n")
				f1.write("cd $TMPDIR/ \n\n")
				f1.write("module load R\n\n")
				f1.write("bash run_polyfreqs.sh -i "+i+" -c "+c+" -f "+f+" -m "+filename+"-mcmc.out -p "+p_tmp+"\n\n")
				f1.write("mv "+filename+"-mcmc.out $HOME/code/sim_data/\n")
				f1.write("mv tot-* $HOME/code/raw_data/\n")
				f1.write("mv ref-* $HOME/code/raw_data/\n")
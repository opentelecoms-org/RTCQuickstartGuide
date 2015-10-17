set terminal svg size 300,400 dynamic enhanced fname 'arial'  fsize 10 butt solid
set output 'metcalfe_quadratic.svg'
set key inside left top vertical Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
set samples 200
set xlabel "number of users"
set ylabel "value of network"
f(n) = n**2
plot [n=0:100] f(n)

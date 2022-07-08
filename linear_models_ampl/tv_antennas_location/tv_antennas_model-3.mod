param n,integer,>0; #nombre de ville
param dc,integer,>0; #distance de couverture du relais
param Nom {i in 1..n}, symbolic;  #nom des villes en caractère
param Cap {i in 1..n}, symbolic;
param Pop {i in 1..n},>=0;
param X {i in 1..n},>=0;  #coordonnée X
param Y {i in 1..n},>=0; #coordonnée Y 
param dist {i in 1..n,j in 1..n} := sqrt((X[i]-X[j])^2+(Y[i]-Y[j])^2); #calcul de la matrice distance
param A {i in 1..n, j in 1..n}, binary :=
if dist [i,j] <= dc then 1 else 0;

var y {j in 1..n}, binary; #variable d'ouverture du relais dans la ville i

minimize z : sum {j in 1..n}y[j]; #fonction objectif pour ouvrir le moins de relais possible


couverture {i in 1..n}: sum{j in 1..n} A[i,j]*y[j]>=2; #chaque ville couverte par minimum 2 relais


solve;


printf"\n";

for {i in 1..n,j in 1..n : dist[i,j]<=3 and dist[i,j]!=0}
printf "Distance entre %d et %d : %f\n",i,j,dist[i,j];



printf"\n";

data;

param n:= 25;
param dc:=5;
param : Nom	Cap	Pop	X	Y :=
		1	Brunil	Oui	183	0	10
		2	Orsted	Non	44	10	6
		3	Valenga	Non	32	14	10
		4	Fouilloux	Non	81	4	1
		5	Morloc	Non	57	13	4
		6	Klagstad	Oui	103	4	6
		7	Ulmeroni	Non	39	1	3
		8	Pontica	Non	64	2	4
		9	Stirlung	Oui	205	2	3
		10	Brolville	Non	76	6	9
		11	Hazencourt	Non	28	11	10
		12	Coltanza	Oui	237	1	6
		13	Marcinto	Non	90	0	8
		14	Mirapolis	Non	306	6.5	4
		15	Warbeck	Non	49	10.5	0
		16	Fort-Brigg	Oui	141	5	10
		17	Kubakta	Non	70	7.5	6.5
		18	Bliquetuit	Oui	183	9.5	9.5
		19	Stirendam	Oui	98	14	1
		20	Arpangel	Oui	166	10	3
		21	Jabertot	Oui	87	12	7.5
		22	Bragero	Non	24	0	0
		23	Zengistu	Non	81	5.5	5.5
		24	Ligerville	Non	69	12	2.5
		25	Trichester	Non	77	8	1;


end;

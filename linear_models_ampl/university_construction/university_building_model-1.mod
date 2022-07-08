param n,integer,>0; #nombre de ville
param p, integer,>0; #nombre d'université à ouvrir
param Nom {i in 1..n}, symbolic;  #nom des villes en caractère
param Cap {i in 1..n}, symbolic;
param Pop {i in 1..n},>=0;
param t {i in 1..n,j in 1..n}; #matrice du temps de trajet entre chaque ville
param q {i in 1..n}:= Pop[i]*20; #calcul du nombre d'étudiant par ville


var x {j in 1..n: Cap[j]="Oui"},binary; #variable d'ouverture de l'université j
var y {i in 1..n,j in 1..n}, binary; #variable d'affectation du client i au site j

minimize z : (1/n)*sum {i in 1..n,j in 1..n} q[i]*t[i,j]*y[i,j]; #minimisation distance moyenne pondérée par le nombre d'étudiant

nb_univ : sum {j in 1..n: Cap[j]="Oui"} x[j]=p; #contrainte d'ouverture du nombre d'université
site {i in 1..n,j in 1..n: Cap[j]="Oui"}: y[i,j]<=x[j]; #pas de ville affectée à une université fermée
affectation {i in 1..n}: sum{j in 1..n : Cap[j]="Oui"} y[i,j]=1; #chaque ville affectée à 1 université


solve;

printf"\n\n";
printf"Temps maximum d'une ville à une université : %d minutes",max {i in 1..n,j in 1..n} (t[i,j]*y[i,j]);
printf"\n\n\n";
for {j in 1..n : Cap[j]="Oui" and x[j] = 1}{ 
	printf " Ouverture d'une université dans la ville %s avec %d étudiants \n", Nom[j],sum {i in 1..n : y[i,j]=1} q[i]; #affichage de l'ouverture de l'université avec le nom de la ville
	printf"Y étudieront les étudiants des villes de :\n";
	for {i in 1..n: y[i,j]=1}
	printf " -%s \n",  Nom [i]; #affichage des villes affectées à chaque université
printf"\n\n";}


data;

param n:= 25;
param p:= 4;
param : Nom	Cap	Pop :=
1	Brunil	Oui	183
2	Orsted	Non	44
3	Valenga	Non	32
4	Fouilloux	Non	81
5	Morloc	Non	57
6	Klagstad	Oui	103
7	Ulmeroni	Non	39
8	Pontica	Non	64
9	Stirlung	Oui	205
10	Brolville	Non	76
11	Hazencourt	Non	28
12	Coltanza	Oui	237
13	Marcinto	Non	90
14	Mirapolis	Non	306
15	Warbeck	Non	49
16	Fort-Brigg	Oui	141
17	Kubakta	Non	70
18	Bliquetuit	Oui	183
19	Stirendam	Oui	98
20	Arpangel	Oui	166
21	Jabertot	Oui	87
22	Bragero	Non	24
23	Zengistu	Non	81
24	Ligerville	Non	69
25	Trichester	Non	77;




param t : 	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25 :=
1	0	750	1061	686	1085	395	505	399	474	452	836	231	109	579	909	375	611	717	1108	852	887	709	481	1007	762
2	750	0	311	499	335	393	711	605	680	298	338	557	679	286	453	375	139	265	507	225	136	724	307	380	379
3	1061	311	0	810	373	704	1022	916	991	609	225	868	990	597	744	686	450	344	546	536	175	1035	618	508	690
4	686	499	810	0	691	398	287	287	212	519	837	455	577	213	447	596	360	764	645	454	635	225	311	609	300
5	1085	335	373	691	0	695	954	848	904	633	400	858	980	510	371	710	474	519	172	237	199	916	609	135	391
6	395	393	704	398	695	0	318	212	287	302	686	164	286	185	514	225	254	567	713	458	529	555	86	612	368
7	505	711	1022	287	954	318	0	106	75	620	1004	274	396	444	734	543	572	885	933	717	848	237	404	871	587
8	399	605	916	287	848	212	106	0	75	514	898	168	290	338	667	437	466	779	866	611	742	343	298	765	520
9	474	680	991	212	904	287	75	75	0	589	973	243	365	412	659	512	541	854	858	666	817	312	373	821	512
10	452	298	609	519	633	302	620	514	589	0	384	466	561	306	636	77	159	265	805	523	434	744	327	678	489
11	836	338	225	837	400	686	1004	898	973	384	0	849	945	624	772	461	477	119	573	563	202	1062	645	536	718
12	231	557	868	455	858	164	274	168	243	466	849	0	122	348	678	389	418	731	877	621	693	511	250	776	531
13	109	679	990	577	980	286	396	290	365	561	945	122	0	470	800	484	540	826	999	743	815	600	372	898	653
14	579	286	597	213	510	185	444	338	412	306	624	348	470	0	330	383	147	551	528	273	422	438	98	428	183
15	909	453	744	447	371	514	734	667	659	636	772	678	800	330	0	713	477	718	199	228	570	672	428	383	147
16	375	375	686	596	710	225	543	437	512	77	461	389	484	383	713	0	236	342	883	600	512	780	311	755	566
17	611	139	450	360	474	254	572	466	541	159	477	418	540	147	477	236	0	404	646	364	275	585	168	519	330
18	717	265	344	764	519	567	885	779	854	265	119	731	826	551	718	342	404	0	692	490	321	989	572	645	644
19	1108	507	546	645	172	713	933	866	858	805	573	877	999	528	199	883	646	692	0	342	371	870	627	188	345
20	852	225	536	454	237	458	717	611	666	523	563	621	743	273	228	600	364	490	342	0	361	679	371	155	154
21	887	136	175	635	199	529	848	742	817	434	202	693	815	422	570	512	275	321	371	361	0	860	443	334	516
22	709	724	1035	225	916	555	237	343	312	744	1062	511	600	438	672	780	585	989	870	679	860	0	536	834	525
23	481	307	618	311	609	86	404	298	373	327	645	250	372	98	428	311	168	572	627	371	443	536	0	526	281
24	1007	380	508	609	135	612	871	765	821	678	536	776	898	428	383	755	519	645	188	155	334	834	526	0	309
25	762	379	690	300	391	368	587	520	512	489	718	531	653	183	147	566	330	644	345	154	516	525	281	309	0;


end;

# Exercice 7

#'Question 1'

param Depot integer;		#Numero du Depot

set CLIENTS := {1,2,6,9,12,14,16,18,19,20,21};			#Ensemble des clients
set DEPOT := {25};			#<Depot
set ALLNODES := CLIENTS union DEPOT;

param Nom {ALLNODES} symbolic;
param d {i in ALLNODES, j in ALLNODES};      					#Distanciers excels
param t {i in ALLNODES, j in ALLNODES};               #Distanciers temps excels

var X {ALLNODES,ALLNODES} binary;     					  #Variable d affectation du trajet du clients i au clients j a la tournee k

minimize Consommation: sum{i in CLIENTS}((-1)*(1-(X[i,Depot] + X[Depot,i])))*(17*d[Depot,i]+7*d[i,Depot]) + sum{i in CLIENTS,j in CLIENTS} (X[i,j]*(27*d[Depot,i]+17*d[i,j]+7*d[j,Depot]));           														#Fonction objectif : Minimiser le nombre de km total des tournées


Anti_auto_visite {i in ALLNODES} : X[i,i] = 0;

Sequence {i in CLIENTS,j in CLIENTS} : X[i,j] <= X[Depot,i];

Truck_entrance {j in CLIENTS} : sum{i in ALLNODES} (X[i,j] - X[j,j]) = 1;   #1 seule camion visite le client

Truck_departure {i in CLIENTS} : sum{j in ALLNODES} (X[i,j] - X[i,i]) = 1; 	#1 seule camion quitte le client

Sous_tours {i in CLIENTS} : X[i,Depot] + X[Depot,i] >= 1;

solve;

printf {1..60} "-";printf "\n";
printf "\nLa solution optimale de VRP trouvee est de %d KM \n",sum{i in ALLNODES,j in ALLNODES} X[i,j]*d[i,j];
printf "Soit une consommation égale à  %d\n",Consommation;
printf "Cette solution necessite de realiser %d tournees differentes \n\n",sum{j in CLIENTS} X[Depot,j];
printf {1..20} "-";printf " PLANS DES TOURNEES "; printf {1..20} "-"; printf "\n";

for {i in CLIENTS,j in CLIENTS : X[i,j] = 1 and i <> Depot and j <> Depot} 														    #Si la tournee visite deux clients
{
printf "\n\nLa tournee consiste a livrer les clients dans l'ordre suivant : \n";
printf "%s (Depart Depot)",Nom[Depot];
printf "=> %s (Ville numero %d)",Nom[i],i;
printf "=> %s (Ville numero %d)",Nom[j],j;
printf "=> %s (Retour Depot)\n",Nom[Depot];
printf "Tournee d'une distance totale de %dKm et une duree totale minimum de %d minutes \n", X[Depot,i]*d[Depot,i]+X[i,j]*d[i,j]+X[j,Depot]*d[j,Depot],X[Depot,i]*t[Depot,i]+X[i,j]*t[i,j]+X[j,Depot]*t[j,Depot];
printf "(Attention : les PCC en temps et en distance ne sont pas forcément les mêmes)\n";
}

for {i in CLIENTS :X[i,Depot] + X[Depot,i] = 2 }  														    #Si la tournee visite un clients
{
printf "\n\nLa tournee consiste a livrer les clients dans l'ordre suivant :\n";
printf "%s (Depart Depot)",Nom[Depot];
printf "=> %s (Ville numero %d)",Nom[i],i;
printf "=> %s (Retour Depot)\n",Nom[Depot];
printf "Tournee d'une distance totale de %dKm et une duree totale minimum de %d minutes \n",X[Depot,i]*d[Depot,i]+X[i,Depot]*d[i,Depot],X[Depot,i]*t[Depot,i]+X[i,Depot]*t[i,Depot];
printf "(Attention : les PCC en temps et en distance ne sont pas forcément les mêmes)\n";
}

data;

param Depot := 25;      #Position du depot sur le distancier

param d: 1 2 6 9 12 14 16 18 19 20 21 25 :=
1	0	1188	724	747	424	1062	500	995	1882	1426	1422	1397
2	1188	0	637	1020	937	524	688	354	756	300	250	583
6	724	637	0	383	300	338	412	907	1159	702	887	674
9	747	1020	383	0	324	550	795	1290	1316	914	1270	683
12	424	937	300	324	0	638	566	1061	1459	1002	1187	974
14	1062	524	338	550	638	0	702	878	820	364	774	335
16	500	688	412	795	566	702	0	495	1444	988	922	1038
18	995	354	907	1290	1061	878	495	0	1108	654	427	936
19	1882	756	1159	1316	1459	820	1444	1108	0	456	680	633
20	1426	300	702	914	1002	364	988	654	456	0	550	283
21	1422	250	887	1270	1187	774	922	427	680	550	0	833
25	1397	583	674	683	974	335	1038	936	633	283	833	0
;

param t: 1 2 6 9 12 14 16 18 19 20 21 25 :=
1 0	750	395 474	231	579	375	717	1108	852	887	762
2 750	0	393	680	557	286	375	265	507	225	136	379
6 395	393	0	287	164	185	225	567	713	458	529	368
9 474	680	287	0	243	412	512	854	858	666	817	512
12  231	557	164	243	0	348	389	731	877	621	693	531
14  579	286	185	412	348	0	383	551	528	273	422	183
16  375	375	225	512	389	383	0	342	883	600	512	566
18  717	265	567	854	731	551	342	0	692	490	321	644
19  1108	507	713	858	877	528	883	692	0	342	371	345
20  852	225	458	666	621	273	600	490	342	0	361	154
21  887	136	529	817	693	422	512	321	371	361	0	516
25  762	379	368	512	531	183	566	644	345	154	516	0
;

#Liste des CLIENTS
param : Nom:=
1	Brunil
2	Orsted
6	Klagstad
9	Stirlung
12	Coltanza
14	Mirapolis
16	Fort-Brigg
18	Bliquetuit
19	Stirendam
20	Arpangel
21	Jabertot
25	Trichester;

end;

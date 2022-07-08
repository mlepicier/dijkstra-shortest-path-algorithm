param source integer;
param destination integer;

set SOURCE := {1};
set DESTINATION := {25};
set OTHER := {2,6,9,12,14,16,18,19,20,21};
set ALLNODES := SOURCE union DESTINATION union OTHER;

param d {i in ALLNODES, j in ALLNODES}; #Distance matrix

var X {ALLNODES,ALLNODES} binary; #Binary variable of affectation of the route from node i to node j

minimize Distance : sum{i in ALLNODES, j in ALLNODES} X[i,j]*d[i,j];

Anti_auto_visite {i in ALLNODES} : X[i,i] = 0; #No looping arcs

Truck_entrance {j in OTHER} : sum{i in ALLNODES} (X[i,j] - X[j,j]) = 1; #Kirchhoff entrance

Truck_departure {i in OTHER} : sum{j in ALLNODES} (X[i,j] - X[i,i]) = 1; #Kirchhoff exit

Departure : sum{j in ALLNODES} (X[source,j] - X[source,source]) = 1; #Kirchhoff source exit

Arrival : sum{i in ALLNODES} (X[i,destination] - X[destination,destination]) = 1; #Kirchhoff source entrance

solve;

printf {1..60} "-";printf "\n";
printf "\nLa solution optimale de PCC trouvee est de %d KM \n",sum{i in ALLNODES,j in ALLNODES} X[i,j]*d[i,j];

data;

param source := 25;      #Position de la source sur le distancier
param destination := 25;      #Position de la destination sur le distancier

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

end;
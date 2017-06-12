
charbench -c swingconfig-5mins.xml -cs //10.0.1.41:1521/odapdb1.aeg -dt thin -co //odanode1/CoordinatorServer

./charbench -g group1 -c swingconfig-5mins.xml -cs //odanode1/odapdb1.aeg -r cluster-results-odanode1.xml -co localhost
./charbench -g group1 -c swingconfig-5mins.xml -cs //odanode2/odapdb1.aeg -r cluster-results-odanode2.xml -co localhost

./charbench -g group1 -c swingconfig-90mins.xml -uc 40 -cs //odanode1/odapdb1.aeg -r cluster-results-odanode1.xml -co localhost
./charbench -g group1 -c swingconfig-90mins.xml -uc 40 -cs //odanode2/odapdb1.aeg -r cluster-results-odanode2.xml -co localhost



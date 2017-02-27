
Measuring Network Capacity using oratcptest (Doc ID 2064368.1)

db1nvme
java -jar oratcptest.jar -server 10.0.1.22 -port=1521

db2nvme
java -jar oratcptest.jar 10.0.1.22 -mode=sync -length=0 -duration=1s -interval=1s -port=1521


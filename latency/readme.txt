
Measuring Network Capacity using oratcptest (Doc ID 2064368.1)

db1nvme
java -jar oratcptest.jar -server 10.0.1.22 -port=1521

db2nvme
java -jar oratcptest.jar 10.0.1.22 -mode=sync -length=0 -duration=1s -interval=1s -port=1521



AD1 : 10.10.0.13
AD2 : 10.10.1.3
AD3 : 10.10.2.3

/bin/systemctl stop firewalld

java -jar oratcptest.jar -server 10.10.0.13 -port=1521
java -jar oratcptest.jar -server vmad1.ricktestsn.rickdnslabel.oraclevcn.com -port=1521
java -jar oratcptest.jar -server -port=5555
java -jar oratcptest.jar vmad1.ricktestsn.rickdnslabel.oraclevcn.com -mode=sync -length=0 -duration=1s -interval=1s -port=5555

java -jar oratcptest.jar -server 10.10.1.3 -port=1521
java -jar oratcptest.jar 10.10.1.3 -mode=sync -length=0 -duration=1s -interval=1s -port=1521

java -jar oratcptest.jar -server 10.10.2.3 -port=1521
java -jar oratcptest.jar 10.10.2.3 -mode=sync -length=0 -duration=1s -interval=1s -port=1521

# #########
# Phoenix
# #########

SERVER	CLIENT	AVG Throughput	AVG Latency
======  ======  ==============	==========
AD1	AD2 	0.014 Mbytes/s	0.798 ms
		0.015 Mbytes/s	0.784 ms
		0.015 Mbytes/s	0.751 ms
AD1	AD3 	0.070 Mbytes/s	0.163 ms
		0.073 Mbytes/s	0.156 ms
		0.076 Mbytes/s	0.150 ms

AD2	AD1	0.015 Mbytes/s	0.775 ms
		0.015 Mbytes/s	0.767 ms
		0.015 Mbytes/s	0.787 ms
AD2	AD3	0.016 Mbytes/s	0.734 ms
		0.016 Mbytes/s	0.718 ms
		0.015 Mbytes/s	0.745 ms

AD3	AD1	0.073 Mbytes/s	0.158 ms
		0.073 Mbytes/s	0.157 ms
		0.075 Mbytes/s	0.153 ms
AD3	AD2	0.016 Mbytes/s	0.726 ms
		0.016 Mbytes/s	0.725 ms
		0.016 Mbytes/s	0.714 ms

# #########
# Ashburn
# #########
AD1 : 129.213.63.117
AD2 : 129.213.21.231
AD3 : 129.213.45.65

java -jar oratcptest.jar -server 10.0.0.2 -port=1521
java -jar oratcptest.jar 10.0.0.2 -mode=sync -length=0 -duration=1s -interval=1s -port=1521

java -jar oratcptest.jar -server 10.0.1.2 -port=1521
java -jar oratcptest.jar 10.0.1.2 -mode=sync -length=0 -duration=1s -interval=1s -port=1521

java -jar oratcptest.jar -server 10.0.2.2 -port=1521
java -jar oratcptest.jar 10.0.2.2 -mode=sync -length=0 -duration=1s -interval=1s -port=1521

SERVER	CLIENT	AVG Throughput	AVG Latency
======  ======  ==============	==========
AD1	AD2 	0.036 Mbytes/s	0.315 ms
		0.035 Mbytes/s	0.323 ms
		0.038 Mbytes/s	0.302 ms
AD1	AD3 	0.043 Mbytes/s	0.267 ms
		0.044 Mbytes/s	0.261 ms
		0.044 Mbytes/s	0.259 ms

AD2	AD1	0.038 Mbytes/s	0.304 ms
		0.039 Mbytes/s	0.294 ms
		0.035 Mbytes/s	0.324 ms
AD2	AD3	0.048 Mbytes/s	0.236 ms
		0.048 Mbytes/s	0.239 ms
		0.052 Mbytes/s	0.218 ms

AD3	AD1	0.044 Mbytes/s	0.259 ms
		0.045 Mbytes/s	0.252 ms
		0.046 Mbytes/s	0.250 ms
AD3	AD2	0.051 Mbytes/s	0.222 ms
		0.046 Mbytes/s	0.249 ms
		0.051 Mbytes/s	0.226 ms



[opc@ricksn1 ~]$ java -jar oratcptest.jar 10.0.2.2 -mode=sync -length=0 -duration=1s -interval=1s -port=1521
[Requesting a test]
	Message payload        = 0 bytes
	Payload content type   = RANDOM
	Delay between messages = NO
	Number of connections  = 1
	Socket send buffer     = (system default)
	Transport mode         = SYNC
	Disk write             = NO
	Statistics interval    = 1 second
	Test duration          = 1 second
	Test frequency         = NO
	Network Timeout        = NO
	(1 Mbyte = 1024x1024 bytes)

(12:07:43) The server is ready.
                        Throughput                 Latency
(12:07:44)          0.046 Mbytes/s                0.250 ms
(12:07:44) Test finished.
	       Socket send buffer = 166400 bytes
	          Avg. throughput = 0.046 Mbytes/s
	             Avg. latency = 0.250 ms


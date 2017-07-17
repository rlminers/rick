
Measuring Network Capacity using oratcptest (Doc ID 2064368.1)

AD1 : 10.0.0.2 129.146.28.86
AD2 : 10.0.1.2 129.146.23.12
AD3 : 10.0.2.2 129.146.25.16

/bin/systemctl stop firewalld


# #########
# Phoenix
# #########

java -jar oratcptest.jar -server 10.0.0.2 -port=1521
java -jar oratcptest.jar 10.0.0.2 -mode=async -duration=10s -interval=2s -port=1521

java -jar oratcptest.jar -server 10.0.1.2 -port=1521
java -jar oratcptest.jar 10.0.1.2 -mode=async -duration=10s -interval=2s -port=1521

java -jar oratcptest.jar -server 10.0.2.2 -port=1521
java -jar oratcptest.jar 10.0.2.2 -mode=async -duration=10s -interval=2s -port=1521

SERVER	CLIENT	AVG Throughput
======  ======  ==============
AD1	AD2 	149.274 Mbytes/s
		149.218 Mbytes/s
		149.273 Mbytes/s
AD1	AD3 	149.299 Mbytes/s
		149.268 Mbytes/s
		149.260 Mbytes/s

AD2	AD1	149.206 Mbytes/s
		146.802 Mbytes/s
		149.197 Mbytes/s
AD2	AD3	149.257 Mbytes/s
		136.749 Mbytes/s
		149.263 Mbytes/s

AD3	AD1	149.297 Mbytes/s
		149.292 Mbytes/s
		149.284 Mbytes/s
AD3	AD2	149.099 Mbytes/s
		149.259 Mbytes/s
		149.253 Mbytes/s

# #########
# Ashburn
# #########
AD1 : 129.213.51.117
AD2 : 129.213.24.215
AD3 : 129.213.47.247

java -jar oratcptest.jar -server 10.0.0.2 -port=1521
java -jar oratcptest.jar 10.0.0.2 -mode=async -duration=10s -interval=2s -port=1521

java -jar oratcptest.jar -server 10.0.1.2 -port=1521
java -jar oratcptest.jar 10.0.1.2 -mode=async -duration=10s -interval=2s -port=1521

java -jar oratcptest.jar -server 10.0.2.2 -port=1521
java -jar oratcptest.jar 10.0.2.2 -mode=async -duration=10s -interval=2s -port=1521

SERVER	CLIENT	AVG Throughput
======  ======  ==============
AD1	AD2 	149.288 Mbytes/s
		149.287 Mbytes/s
		149.210 Mbytes/s
AD1	AD3 	149.208 Mbytes/s
		149.297 Mbytes/s
		149.293 Mbytes/s

AD2	AD1	149.266 Mbytes/s
		149.258 Mbytes/s
		149.289 Mbytes/s
AD2	AD3	149.301 Mbytes/s
		149.298 Mbytes/s
		149.298 Mbytes/s

AD3	AD1	149.265 Mbytes/s
		149.296 Mbytes/s
		149.286 Mbytes/s
AD3	AD2	149.295 Mbytes/s
		149.299 Mbytes/s
		149.299 Mbytes/s



[opc@ricksn1 ~]$ java -jar oratcptest.jar 10.0.2.2 -mode=async -duration=10s -interval=2s -port=1521
[Requesting a test]
	Message payload        = 1 Mbyte
	Payload content type   = RANDOM
	Delay between messages = NO
	Number of connections  = 1
	Socket send buffer     = (system default)
	Transport mode         = ASYNC
	Disk write             = NO
	Statistics interval    = 2 seconds
	Test duration          = 10 seconds
	Test frequency         = NO
	Network Timeout        = NO
	(1 Mbyte = 1024x1024 bytes)

(18:08:20) The server is ready.
                        Throughput
(18:08:22)        151.234 Mbytes/s
(18:08:24)        151.423 Mbytes/s
(18:08:26)        151.387 Mbytes/s
(18:08:28)        150.368 Mbytes/s
(18:08:30)        142.243 Mbytes/s
(18:08:30) Test finished.
	       Socket send buffer = 898560 bytes
	          Avg. throughput = 149.284 Mbytes/s


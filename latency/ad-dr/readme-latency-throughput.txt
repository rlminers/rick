
# ExaCS node 1 : 10.10.10.6
# ExaCS node 2 : 10.10.10.7
# ExaCS node 3 : 10.10.10.8
# ExaCS node 4 : 10.10.10.9
# ExaCS SCAN : exacsnode-jw00z-scan.exacsmainsn.dnsvcnaeg.oraclevcn.com

# BMC Dense IO : 10.10.12.2


# ########
# latency
# ########
java -jar oratcptest.jar -server 10.10.10.6 -port=5565
java -jar oratcptest.jar 10.10.10.6 -mode=sync -length=0 -duration=1s -interval=1s -port=5565


# ########
# throughput
# ########
java -jar oratcptest.jar -server 10.10.10.6 -port=5565
java -jar oratcptest.jar 10.10.10.6 -mode=async -duration=10s -interval=2s -port=5565


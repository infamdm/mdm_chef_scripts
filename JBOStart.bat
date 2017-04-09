@echo off
echo 1) Cleaning....
echo zookeeper
rm -rdf C:\infamdm\hub\zookeeper\version-2

echo solr folder 
rm -rdf C:\infamdm\hub\cleanse\solr

echo server temp
rm -rdf C:\infamdm\hub\server\temp

echo server tmp
rm -rdf C:\infamdm\hub\server\tmp

echo server logs
rm -rdf C:\infamdm\hub\server\logs

echo cleanse tmp 
rm -rdf  C:\infamdm\hub\cleanse\tmp

echo cleanse logs
rm -rdf  C:\infamdm\hub\cleanse\logs

echo completed cleaning.

rem wait for 3 seconds
timeout 3 > NUL

echo 2) Re-Creating folders... 
echo  server logs
md C:\infamdm\hub\server\logs

echo  cleanse logs
md C:\infamdm\hub\cleanse\logs

echo  cleanse tmp
md C:\infamdm\hub\cleanse\tmp

echo server temp
md C:\infamdm\hub\server\temp

echo starting jboss server ....
timeout 3 > NUL

cd C:\SREDDY\tools\EAP-6.4.0\bin
standalone.bat --debug 9797 -c standalone-full.xml -b 0.0.0.0
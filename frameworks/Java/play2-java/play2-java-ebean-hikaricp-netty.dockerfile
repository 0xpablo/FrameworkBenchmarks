FROM hseeberger/scala-sbt:8u181_2.12.8_1.2.8
WORKDIR /play2
COPY play2-java-ebean-hikaricp .

RUN sed -i 's/.enablePlugins(PlayMinimalJava, PlayEbean, PlayNettyServer)/.enablePlugins(PlayMinimalJava, PlayEbean, PlayNettyServer).disablePlugins(PlayAkkaHttpServer)/g' build.sbt

RUN sbt stage
CMD target/universal/stage/bin/play2-java-ebean-hikaricp -Dplay.server.provider=play.core.server.NettyServerProvider -J-server -J-Xms1g -J-Xmx1g -J-XX:NewSize=512m -J-XX:+UseG1GC -J-XX:MaxGCPauseMillis=30 -J-XX:-UseBiasedLocking -J-XX:+AlwaysPreTouch -Dthread_count=$(nproc) -Dphysical_cpu_count=$(grep ^cpu\\scores /proc/cpuinfo | uniq | awk '{print $4}') -Ddb_pool_size=$(( $(( $(grep ^cpu\\scores /proc/cpuinfo | uniq | awk '{print $4}') * 2 )) + 1 ))

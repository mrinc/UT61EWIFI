CWD="$(pwd)";
RELD="$CWD/Clients/build/release";
VERF="$CWD/Clients/build/version.js";
VERFNR="$CWD/Clients/build/version.node-red.js";

mkdir $RELD;

bash "$CWD/Clients/build/build.sh";
cd $CWD;


echo "Versioning simple web";
cd ./Clients/SimpleWeb/web;
SWV="$(node $VERF)";
echo "Release simple web";
cd ./dist;
echo "$SWV" > ./version.txt;
cp ../../../../License/* ./;
tar -czvf "$RELD/SimpleWeb-WebUI-$SWV.tar.gz" ./*.*;

cd $CWD;

echo "Versioning node red";
cd ./Clients/Node-RED/dist;
NRV="$(node $VERFNR)";
echo "Release node red";
echo "$NRV" > ./version.txt;
cp ../../../License/* ./;
tar -czvf "$RELD/SimpleWeb-NodeRED-$NRV.tar.gz" ./*.*;

cd $CWD;

echo "Release desktop app";
cd ./Clients/Desktop;
DAV="$(node $VERF)";
npx electron-forge make;
ls ./out
ls ./out/make
if [[ -d "./out/make/deb/" ]]
then
  cp ../../License/* ./out/make/deb/x64/;
  echo "$DAV" > ./out/make/deb/x64/version.txt;
  tar -czvf "$RELD/SimpleWeb-Desktop-deb-x64-$DAV.tar.gz" ./out/make/deb/x64/*.*;
  cp ../../License/* ./out/make/rpm/x64/;
  echo "$DAV" > ./out/make/rpm/x64/version.txt;
  tar -czvf "$RELD/SimpleWeb-Desktop-rpm-x64-$DAV.tar.gz" ./out/make/rpm/x64/*.*;
fi
if [[ -d "./out/make/darwin/" ]]
then
  cp ../../License/* ./out/make/darwin/x64/;
  echo "$DAV" > ./out/make/darwin/x64/version.txt;
  tar -czvf "$RELD/SimpleWeb-Desktop-darwin-x64-$DAV.tar.gz" ./out/make/darwin/x64/*.*;
fi

cd $CWD;
cd ./Clients/build;
RELVERSION="$(node cli-version.js)";
echo "RELVERSION=$RELVERSION";
echo "::set-output name=RELVERSION::$RELVERSION";
cd $CWD;
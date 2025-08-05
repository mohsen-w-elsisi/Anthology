rm -rf build

mkdir build
mkdir build/server

mkdir build/server/main
dart compile exe anthology_server/bin/server.dart -o ./build/server/main/server
cp anthology_server/public build/server/main/public -r

mkdir build/server/briefing
cp anthology_briefing_server build/server -r
cd build/server/briefing
npm run build
rm -rf src
rm tsconfig.json
cd ../..

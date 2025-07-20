mkdir build
mkdir build/server

dart compile exe anthology_server/bin/server.dart -o ./build/server/server

cp anthology_server/public build/server/public -r

NAME=`grep -i 'project_name' .env | cut -f2- -d=`
GEM_VERS=`grep -i 'gemset_vers' .env | cut -f2- -d=`
NM_VERS=`grep -i 'node_modules_vers' .env | cut -f2- -d=`

BUNDLE=${NAME}_${GEM_VERS}_bundle
NODE_MODULES=${NAME}_${NM_VERS}_node_modules

output=$({ `docker volume inspect $BUNDLE`; } 2>&1)
if [[ "$output" == *"No such volume"* ]]; then
    docker volume create $BUNDLE
fi

output=$({ `docker volume inspect $NODE_MODULES`; } 2>&1)
if [[ "$output" == *"No such volume"* ]]; then
    docker volume create $NODE_MODULES
fi

docker-compose build

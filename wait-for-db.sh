# Definir argumentos para pasar al script
HOST=$1
PORT=$2

# Eliminación de los primeros 2 argumentos (host y puerto)
# /wait-for-db.sh mysql 3306 java -jar app.jar
shift 2
# Guardar el resto de comandos para el proceso final
CMD=$@

until nc -z $HOST $PORT; do
    echo "Waiting for database..."
    sleep 2
done

echo "Database is up!"
# Da pie a la ejecución del comando final de tu app: java -jar app.jar
exec $CMD
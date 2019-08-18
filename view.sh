pass="secret"

# VncViewer jars are found here: https://code.google.com/archive/p/vncthumbnailviewer/downloads
viewer_jar="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/vncthumbnailviewer/VncThumbnailViewer%201.4.2.jar"
if [ ! -f ./viewer.jar ]; then
    echo "Viewer.jar not found - downloading!"
    curl $viewer_jar -o viewer.jar
fi

# prompt for host ip if not provided as a 1st parameter
if [ -z "${1}" ]; then
    printf 'Enter host ip: '
    read -r host
else
    host=${1}
fi

# set default port range
startPort=9001
endPort=9020

# set port range using 2nd param if available, param is colon delimited, ex 1:20
if [ ! -z "${2}" ]; then
    IFS=':' read -ra portRange <<< "${2}"
    startPort=${portRange[0]}
    if [ ${#portRange[*]} != 2 ]; then
        endPort=${portRange[0]}
    else
        endPort=${portRange[1]}
    fi
fi

for port in `seq ${startPort} ${endPort}`;
do
    params="$params HOST $host PORT $port PASSWORD $pass"
done

java -jar viewer.jar $params

package main

import (
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
)

/*
 * This is a minimal HTTP/HTTPS server that can only serve the /nbp file path.
 * In HTTPS mode you need cert.pem and key.pem . You can generate a passwordless
 * self-signed certificate with the following command:
 *
 * openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
 *
 * To build the server just run `go build`. Run it with `sudo ./server`. Sudo is
 * only necessary if you are using privileged ports. You can specify an
 * unprivileged port (and then skip `sudo`) with `-p` .
 */

var (
	flagUseHTTPS = flag.Bool("s", false, "Use HTTPS instead of HTTP. Requires cert.pem and key.pem")
	flagPort     = flag.Int("p", 0, "Port to listen on. If 0 or unspecified, it will use either 80 or 443 depending on whether HTTPS is enabled")
)

// NBPHandler it is.
func NBPHandler(w http.ResponseWriter, req *http.Request) {
	log.Printf("Handling NBP %+v", req)
	data, err := ioutil.ReadFile("nbp")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Header().Set("Content-Type", "text/plain")
		io.WriteString(w, fmt.Sprintf("error: %v", err))
		return
	}
	w.Header().Set("Content-Type", "application/octet-stream")
	w.Write(data)
}

func getListenAddr(port int, isHTTPS bool) string {
	if port == 0 {
		if isHTTPS {
			return ":443"
		}
		return ":80"
	}
	return ":" + strconv.Itoa(port)
}

func main() {
	flag.Parse()

	http.HandleFunc("/nbp", NBPHandler)
	var err error
	addr := getListenAddr(*flagPort, *flagUseHTTPS)
	log.Printf("Starting server on %s", addr)
	if *flagUseHTTPS {
		// you have to generate your own self-signed certificates to use HTTPS
		err = http.ListenAndServeTLS(addr, "cert.pem", "key.pem", nil)
	} else {
		err = http.ListenAndServe(addr, nil)
	}
	if err != nil {
		log.Fatal("Error when listening or serving: ", err)
	}
}

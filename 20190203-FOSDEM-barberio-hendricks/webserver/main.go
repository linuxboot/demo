package main

import (
    "os"
    "io"
    "net/http"
    "log"
)


func netbootServer(w http.ResponseWriter, req *http.Request) {
    w.Header().Set("Content-Type", "application/octet-stream")
    nbp, err := os.Open("linux-4.19.6/vmlinux")
    if err != nil {
	    log.Fatal("Couldn't open linux-4.19.6/vmlinux")
    }
    buf := make([]byte, 10240)
    for {
        n, err := nbp.Read(buf)
        if err != nil && err != io.EOF {
            panic(err)
        }
        if n == 0 {
            break
        }
        if _, err := w.Write(buf[:n]); err != nil {
            panic(err)
        }
    }
}

func main() {
    http.HandleFunc("/nbp", netbootServer)
    err := http.ListenAndServeTLS("[2001:db8:1::1]:443", "2001:db8:1::1.crt", "2001:db8:1::1.key", nil)
    if err != nil {
        log.Fatal("ListenAndServeTLS: ", err)
    }
}

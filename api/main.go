package main

import (
	"github.com/sinlov/qqwry-golang/qqwry"
	"log"
	"net/http"
	"fmt"
	"github.com/sinlov/qqwry-golang/api/control"
)

const (
	qqwryDatFilePath = "../dat/qqwry_2018-11-15.dat"
	httpPort         = 13456
)

func main() {
	qqwry.DatData.FilePath = qqwryDatFilePath
	init := qqwry.DatData.InitDatFile()
	if v, ok := init.(error); ok {
		log.Fatalf("init InitDatFile error %s", v)
		return
	}
	log.Printf("IP dat load success, use time %.1fms, total count %d", qqwry.DatData.LoadTimeMs, qqwry.DatData.IPCount)

	http.HandleFunc("/ip", control.SearchIP)
	// IP code
	if err := http.ListenAndServe(fmt.Sprintf(":%s", httpPort), nil); err != nil {
		log.Println(err)
	}
}

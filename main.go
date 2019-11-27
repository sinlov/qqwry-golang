package main

import (
	"fmt"
	"github.com/sinlov/qqwry-golang/qqwry"
	"os"
)

func main() {
	var datPath = "./dat/qqwry_2018-11-15.dat"
	var ipCZ88 = "60.12.235.73"

	qqwry.DatData.FilePath = datPath
	init := qqwry.DatData.InitDatFile()
	if v, ok := init.(error); ok {
		if v != nil {
			fmt.Printf("init InitDatFile error %s", v)
			os.Exit(1)
		}
	}

	res := qqwry.NewQQwry().SearchByIPv4(ipCZ88)
	fmt.Printf("search by IP:%s => Country:%s,Area:%s,Err:%v", res.IP, res.Country, res.Area, res.Err)
}

package qqwry

import (
	"github.com/smartystreets/goconvey/convey"
	"testing"
)

var datPath = "../dat/qqwry_2018-11-15.dat"
var ipCZ88 = "60.12.235.73"

func TestFileData_InitDat(t *testing.T) {
	convey.Convey("mock TestFileData_InitDat", t, func() {
		// mock
		DatData.FilePath = datPath
		init := DatData.InitDatFile()
		convey.Convey("do TestFileData_InitDat", func() {
			// do
			if v, ok := init.(error); ok {
				t.Fatalf("init InitDatFile error %s", v)
			}
			t.Logf("init success at path %s", datPath)
			convey.Convey("verify TestFileData_InitDat", func() {
				// verify
				t.Logf("IP dat load success, use time %.1fms, total count %d", DatData.LoadTimeMs, DatData.IPCount)
				convey.So(DatData.IPCount, convey.ShouldEqual, 470454)
			})
		})
	})
}

func TestQQwry_SearchByIPv4(t *testing.T) {
	convey.Convey("mock TestQQwry_SearchByIPv4", t, func() {
		// mock

		DatData.FilePath = datPath
		init := DatData.InitDatFile()
		convey.Convey("do TestQQwry_SearchByIPv4", func() {
			// do
			if v, ok := init.(error); ok {
				t.Fatalf("init InitDatFile error %s", v)
			}
			t.Logf("IP dat load success, use time %.1fms, total count %d", DatData.LoadTimeMs, DatData.IPCount)
			convey.Convey("verify TestQQwry_SearchByIPv4", func() {
				// verify
				qqwry := NewQQwry()
				res := qqwry.SearchByIPv4(ipCZ88)
				t.Logf("search by IP:%s => Country:%s,Area:%s", res.IP, res.Country, res.Area)
				convey.So(res.IP, convey.ShouldEqual, ipCZ88)
				convey.So(res.Country, convey.ShouldEqual, "浙江省杭州市")
				convey.So(res.Area, convey.ShouldEqual, "联通IDC机房")
			})
		})
	})
}

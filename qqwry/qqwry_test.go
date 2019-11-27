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
				if v != nil {
					t.Fatalf("init InitDatFile error %s", v)
				}
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

func TestFileData_InitDatFileErr(t *testing.T) {
	convey.Convey("TestFileData_InitDatFileErr", t, func() {
		// mock
		var errPath = "../dat/qqwry_2018-11-00.dat"
		// do
		DatData.FilePath = errPath
		init := DatData.InitDatFile()
		v, _ := init.(error)
		t.Logf("init InitDatFile err: %v", v)
		// verify
		convey.So(v.Error(), convey.ShouldNotBeNil)
	})
}

func TestQQwry_SearchByIPv4(t *testing.T) {
	convey.Convey("mock TestQQwry_SearchByIPv4", t, func() {
		// mock
		type args struct {
			ip string
		}
		type wants struct {
			resQQwry ResQQwry
		}
		tests := []struct {
			name  string
			args  args
			wants wants
		}{
			{
				name: "ip CZ88",
				args: args{ip: ipCZ88},
				wants: wants{
					resQQwry: ResQQwry{
						IP:      ipCZ88,
						Country: "浙江省杭州市",
						Area:    "联通IDC机房",
						Err:     "",
					},
				},
			},
		}
		DatData.FilePath = datPath
		init := DatData.InitDatFile()
		if v, ok := init.(error); ok {
			if v != nil {
				t.Fatalf("init InitDatFile error %s", v)
			}
		}
		t.Logf("IP dat load success, use time %.1fms, total count %d", DatData.LoadTimeMs, DatData.IPCount)
		convey.Convey("do TestQQwry_SearchByIPv4", func() {
			for _, test := range tests {
				// do
				qqwry := NewQQwry()
				res := qqwry.SearchByIPv4(test.args.ip)
				convey.Convey("verify TestQQwry_SearchByIPv4"+test.name, func() {
					// verify
					t.Logf("search by IP:%s => Country:%s,Area:%s,Err:%v", res.IP, res.Country, res.Area, res.Err)
					want := test.wants.resQQwry
					convey.So(res.IP, convey.ShouldEqual, want.IP)
					convey.So(res.Country, convey.ShouldEqual, want.Country)
					convey.So(res.Area, convey.ShouldEqual, want.Area)
					convey.So(res.Err, convey.ShouldEqual, want.Err)
				})
			}
		})
	})
}

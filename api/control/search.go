package control

import (
	"net/http"
)

func SearchIP(w http.ResponseWriter, r *http.Request) {
	res := NewResponse(w, r)

	ip := r.Form.Get("ip")

	if ip == "" {
		res.ReturnError(http.StatusBadRequest, 200001, "please input ip address")
		return
	}

	//ips := strings.Split(ip, ",")

	//qqWry := NewQQwry()
	//
	//rs := map[string]ResultQQwry{}
	//if len(ips) > 0 {
	//	for _, v := range ips {
	//		rs[v] = qqWry.Find(v)
	//	}
	//}
	//
	//res.ReturnSuccess(rs)
}

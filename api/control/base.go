package control

import (
	"net/http"
	"fmt"
)

// Response
type Response struct {
	r *http.Request
	w http.ResponseWriter
}

func (r *Response) IsJSONP() string {
	if r.r.Form.Get("callback") != "" {
		return r.r.Form.Get("callback")
	}
	return ""
}

func (r *Response) Return(data interface{}, code int) {
	jsonp := r.IsJSONP()

	rs, err := ffjson.Marshal(data)
	if err != nil {
		code = 500
		rs = []byte(fmt.Sprintf(`{"errcode":500, "errmsg":"%s"}`, err.Error()))
	}

	r.w.WriteHeader(code)
	if jsonp == "" {
		r.w.Header().Add("Content-Type", "application/json")
		r.w.Write(rs)
	} else {
		r.w.Header().Add("Content-Type", "application/javascript")
		r.w.Write([]byte(fmt.Sprintf(`%s(%s)`, jsonp, rs)))
	}
}

func NewResponse(w http.ResponseWriter, r *http.Request) Response {
	r.ParseForm()
	return Response{
		w: w,
		r: r,
	}
}

func (r *Response) ReturnError(statuscode, code int, errMsg string) {
	r.Return(map[string]interface{}{"errcode": code, "errmsg": errMsg}, statuscode)
}

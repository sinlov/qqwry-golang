package qqwry

import (
	"os"
)

const (
	// length of index
	INDEX_LEN = 7
	// qqwry direct mode 1
	REDIRECT_MODE_1 = 0x01
	// qqwry direct mode 2
	REDIRECT_MODE_2 = 0x02

	// error info define
	ERROR_STR_DAT_FILE_NOT_EXIST    = "qqwry.dat file not exist at => %s"
	ERROR_SEARCH_STR_NOT_IP_V4      = "your search string not IPv4"
	ERROR_CAN_NOT_FIND_IP_V4_OFFSET = "search IPv4 not found offset"
)

// qqwrt.dat data struct
type fileData struct {
	Data       []byte
	FilePath   string
	Path       *os.File
	IPCount    int64
	LoadTimeMs float64
}

type QQwry struct {
	Data   *fileData
	Offset int64
}

// result of QQwry json
type ResQQwry struct {
	IP      string `json:"ip"`
	Country string `json:"country,omitempty"`
	Area    string `json:"area,omitempty"`
	Err     string `json:"err,omitempty"`
}

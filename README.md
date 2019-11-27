# qqwry/cz88 IP local lib with golang

- Document of qqwry.data see [QQ纯真数据库文件格式详解.pdf](doc/QQ纯真数据库文件格式详解.pdf)
- Download `qqwry.data` by URL, then install to get `qqwry.data` file

```sh
curl -s -O 'http://update.cz88.net/soft/setup.zip'
```

- [x] lib of qqwry.dat file
- [ ] CLI tools of qqwry.data
- [ ] http server of IP local
- [ ] docker image of server

# use

```go
import (
	"fmt"
	"github.com/sinlov/qqwry-golang/qqwry"
)
	var datPath = "./dat/qqwry_2018-11-15.dat"
	qqwry.DatData.FilePath = datPath
	init := qqwry.DatData.InitDatFile()
	if v, ok := init.(error); ok {
		if v != nil {
			fmt.Printf("init InitDatFile error %s", v)
		}
	}

	res := qqwry.NewQQwry().SearchByIPv4("searchIP")
```

# build

- because `qqwry.dat` use GBK char, so use lib [github.com/axgle/mahonia](https://github.com/axgle/mahonia)

```bash
# init project depends
make init
# run main.go
make dev
# run test case
make runTest
```

---------

tks [纯真IP](http://www.cz88.net/) support qqwry.dat file
tks [yinheli/qqwry](https://github.com/yinheli/qqwry) support analytic file of qqwry.dat
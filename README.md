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


# build

- because `qqwry.dat` use GBK char, so use lib [github.com/axgle/mahonia](https://github.com/axgle/mahonia)

---------

tks [纯真IP](http://www.cz88.net/) support qqwry.dat file
tks [yinheli/qqwry](https://github.com/yinheli/qqwry) support analytic file of qqwry.dat
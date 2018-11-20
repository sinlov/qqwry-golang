# 纯真IP库 golang 版本

- 有关 纯真IP 库的文档见 [QQ纯真数据库文件格式详解.pdf](doc/QQ纯真数据库文件格式详解.pdf)
- 当前的纯真IP库下载，安装后获取文件 `qqwry.dat`

```sh
curl -s -O 'http://update.cz88.net/soft/setup.zip'
```

- [x] 本工具提供本地解析库函数，用于跨平台开发
- [ ] 提供命令行工具
- [ ] 提供 http 服务
- [ ] 提供 docker 容器

# build

构建注意
- 因为qqwry.dat 文件使用了 RBK

------------

感谢 [纯真IP](http://www.cz88.net/) 提供的开源IP地址库
感谢 [yinheli/qqwry](https://github.com/yinheli/qqwry) 提供的 qqwry.dat 解析方案
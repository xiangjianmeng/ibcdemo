# 本地搭建跨链转账

> 前提配置好go环境和 nodejs、npm 环境
>
> chrome安装好keplr钱包插件

## 启动测试链

```
git clone https://github.com/okex/tools
cd ibc
./demo.sh
```

## 添加测试链gaia测试链到keplr钱包

浏览器访问 https://localhost:8082 , 然后点击授权即可

## 添加测试链okc测试链到keplr钱包

浏览器访问 https://localhost:8081 , 然后点击授权即可

## 给测试账户转账
通过上面授权后将网络切到okc-test复制地址执行如下命令完成转账, 刷新后可以看到账户中有10000okt
```shell
cd ibc
exchaincli tx send admin16 ex1jm2jf9pzwpjwdvt95l22dra7lu6h646x49yzdf  10000okt --chain-id exchain-101 --fees 0.001okt -y --node tcp://127.0.0.1:36657 --home data/exchain-101 -b block
```

通过上面授权后将网络切到gaia-test复制地址执行如下命令完成转账，舒心后可以看到账户中有100atom
```shell
cd ibc
gaiad tx bank send user cosmos1jm2jf9pzwpjwdvt95l22dra7lu6h646xavj8y7 100000000uatom --chain-id ibc-1 --fees 0.1uatom -y --node tcp://127.0.0.1:16657 --home data/ibc-1/ --keyring-backend="test" -b block
```

## okc跨链转账

1. 钱包切换到okc测试网络, 打开设置界面, 开启IBC转账功能

![image-20220419100220283](http://typora.img.codingfine.com/imgimage-20220419100220283.png)

2. 点击IBC Transfer, 选择对应的channel, 和目标链地址 即可

![image-20220419103255397](http://typora.img.codingfine.com/imgimage-20220419103255397.png)
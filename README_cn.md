# transmission-peer-blocker

[English](README.md) | 中文

## 描述

识别并使用`iptables`和`ipset`屏蔽transmission吸血BT客户端的Bash脚本。

## 要求

- `transmission`已安装并且正常运行
- `transmission-remote`命令可用
- `iptables`可用
- `ipset`已安装
- `cronie`已安装（可选）

## 使用方法

可以手动执行此脚本或者使用`cronie`等工具创建定时任务来实现自动屏蔽。

### 1. 下载脚本

1. 可以单独下载[transmission-peer-blocker.sh](https://github.com/askar882/transmission-peer-blocker/raw/master/transmission-peer-blocker.sh)脚本文件或者执行`git clone https://github.com/askar882/transmission-peer-blocker`命令克隆本项目。
2. 执行`chmod +x transmission-peer-blocker.sh`给脚本文件授予可执行权限。

### 2. 创建定时任务（可选）

执行`sudo crontab -e`命令并粘贴以下内容为root用户创建定时任务：

```crontab
*/5 * * * * /home/user/transmission-peer-blocker/transmission-peer-blocker.sh
```

> :memo: `cronie`会每五分钟执行一次`/home/user/transmission-peer-blocker/transmission-peer-blocker.sh`，可以根据自己的需求访问[Crontab.guru](https://crontab.guru/)生成`cronie`任务表达式。注意需要将上方的脚本路径替换为实际的脚本路径。

## 参考

[Transmission 屏蔽迅雷反吸血脚本](https://zhuanlan.zhihu.com/p/158711236)

[session.cpp](https://github.com/c0re100/qBittorrent-Enhanced-Edition/blob/v4_2_x/src/base/bittorrent/session.cpp#L2212)

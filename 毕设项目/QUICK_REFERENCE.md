# 快速参考卡片 🚀

## 一键启动本地测试环境

```bash
cd /Users/sifotd/Desktop/毕设项目
./quick-start.sh
```

## 常用命令

### 🎯 节点管理

```bash
# 启动本地节点
cd Monallo-Bridge-Contract
./scripts/start-local-nodes.sh

# 检查节点状态
./scripts/check-nodes.sh

# 停止节点
./scripts/stop-local-nodes.sh
```

### 📝 合约部署

```bash
# 部署到本地节点
cd Monallo-Bridge-Contract
./scripts/deploy-local.sh
```

### 🎨 前端启动

```bash
# 开发模式
cd Monallo-Bridge-Frontend
npm run dev

# 构建生产版本
npm run build
```

### 📊 查看日志

```bash
cd Monallo-Bridge-Contract

# 查看所有日志
tail -f logs/*.log

# 只看主节点
tail -f logs/localhost-8545.log

# 只看 Sepolia 节点
tail -f logs/sepolia-8546.log

# 只看 Imua 节点
tail -f logs/imua-8547.log
```

## 📡 本地网络配置

### MetaMask 配置

| 网络名称 | RPC URL | Chain ID | 货币符号 |
|---------|---------|----------|---------|
| Localhost 8545 | http://127.0.0.1:8545 | 31337 | ETH |
| Local Sepolia | http://127.0.0.1:8546 | 11155111 | ETH |
| Local Imua | http://127.0.0.1:8547 | 233 | IMUA |

### 测试账户

默认测试账户私钥:
```
0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

余额: 10000 ETH

## 🔧 故障排除

### 端口被占用
```bash
# 查看端口占用
lsof -i :8545
lsof -i :8546
lsof -i :8547

# 杀死进程
kill -9 <PID>
```

### 重置环境
```bash
# 停止所有节点
cd Monallo-Bridge-Contract
./scripts/stop-local-nodes.sh

# 清理日志
rm -rf logs

# 重新启动
./scripts/start-local-nodes.sh
```

### MetaMask 问题
```
Settings -> Advanced -> Reset Account
```

## 💡 优势对比

| 特性 | 本地节点 | 公共RPC |
|-----|---------|---------|
| 响应时间 | < 10ms | 1-5s |
| 稳定性 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| 速率限制 | 无 | 有 |
| 成本 | 免费 | 免费 |
| 需要网络 | 否 | 是 |

## 📚 文档

- 完整指南: [LOCAL_TESTING_GUIDE.md](LOCAL_TESTING_GUIDE.md)
- 合约配置: [Monallo-Bridge-Contract/hardhat.config.js](Monallo-Bridge-Contract/hardhat.config.js)
- 前端配置: [Monallo-Bridge-Frontend/services/web3Service.ts](Monallo-Bridge-Frontend/services/web3Service.ts)

## 🎯 项目结构

```
毕设项目/
├── Monallo-Bridge-Contract/     # 智能合约
│   ├── scripts/
│   │   ├── start-local-nodes.sh
│   │   ├── stop-local-nodes.sh
│   │   ├── deploy-local.sh
│   │   └── check-nodes.sh
│   └── hardhat.config.js
├── Monallo-Bridge-Frontend/     # 前端界面
│   └── services/web3Service.ts
├── Monallo-Bridge-Middleware/   # 中间件
├── Monallo-Bridge-Backend/      # 后端
├── quick-start.sh               # 一键启动
├── LOCAL_TESTING_GUIDE.md       # 详细指南
└── QUICK_REFERENCE.md          # 本文件
```

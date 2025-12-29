# SwiftBridge - 项目信息

## 📌 项目名称
**SwiftBridge** - 快速跨链桥

## 🎯 项目简介
SwiftBridge 是一个去中心化的跨链桥平台，支持在多个区块链网络之间快速、安全地转移资产。

## 🌐 支持的网络
- Ethereum Sepolia (测试网)
- Imua Testnet (测试网)
- ZetaChain Testnet (测试网)
- PlatON Mainnet (主网)

## 💻 技术栈

### 前端
- Next.js 15 + React 19
- TypeScript 5
- Web3.js 4.x
- Material-UI + Tailwind CSS

### 后端
- Express 5
- MongoDB + Mongoose
- Ethers.js 6
- WebSocket (实时通信)

### 智能合约
- Solidity
- Hardhat
- ERC20 标准

## 📂 项目结构
```
SwiftBridge/
├── SwiftBridge-Frontend/      # 前端 (Next.js)
├── SwiftBridge-Backend/        # 后端 API (Express)
├── SwiftBridge-Middleware/     # 中间件 (事件监听 + WebSocket)
└── SwiftBridge-Contract/       # 智能合约 (Solidity)
```

## 🚀 启动服务

### 方式一：分别启动（推荐）

**终端 1 - 前端:**
```bash
cd SwiftBridge-Frontend
npm run dev
# 访问: http://localhost:3000
```

**终端 2 - 后端 API:**
```bash
cd SwiftBridge-Backend
npm run dev
# 运行在: http://localhost:5001
```

**终端 3 - 中间件:**
```bash
cd SwiftBridge-Middleware
npm run dev
# HTTP: 3001, WebSocket: 8888
```

**终端 4 - MongoDB:**
```bash
mongod
# 端口: 27017
```

### 方式二：使用启动脚本
```bash
./quick-start.sh
```

## 🔗 服务端口

| 服务 | 端口 | 地址 |
|------|------|------|
| 前端 | 3000 | http://localhost:3000 |
| 后端 API | 5001 | http://localhost:5001 |
| 中间件 HTTP | 3001 | http://localhost:3001 |
| WebSocket | 8888 | ws://localhost:8888 |
| MongoDB | 27017 | mongodb://localhost:27017 |

## ✨ 核心功能
1. ⚡ 快速跨链转账
2. 🔒 安全的智能合约
3. 💱 支持多种代币
4. 🔄 实时交易状态
5. 📱 响应式界面设计

## 🔐 安全特性
- ✅ 智能合约访问控制
- ✅ 交易签名验证
- ✅ 防重放攻击
- ✅ 环境变量加密

## 📊 数据库
- **类型**: MongoDB
- **数据库名**: swiftbridge
- **集合**:
  - crossBridgeRecords (跨链记录)
  - users (用户信息)
  - contracts (合约信息)

## 🎨 品牌标识
- **名称**: SwiftBridge
- **标语**: "Bridging chains, connecting futures"
- **理念**: 快速、安全、简单

## 📝 命名含义
- **Swift**: 快速、迅捷
- **Bridge**: 桥梁、连接

寓意：快速连接不同的区块链世界，为用户提供极致的跨链体验。

## 📅 版本信息
- **当前版本**: 1.0.0
- **最后更新**: 2024-12-28

## 👨‍💻 开发团队
毕业设计项目

---

**SwiftBridge** ⚡ - 让跨链转账像闪电一样快！

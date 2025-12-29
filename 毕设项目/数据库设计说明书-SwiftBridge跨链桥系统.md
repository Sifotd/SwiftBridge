# 本科毕业论文（设计）
# 数据库设计说明书

**题目**: 基于门限签名与分布式消息传递的全链跨链桥系统设计与实现

**学生姓名**: [您的姓名]
**学号**: [您的学号]
**专业**: 区块链工程
**年级班级**: [年级班级]
**指导教师**: [导师姓名]
**所在学院**: 人工智能学院（区块链产业学院）
**提交日期**: 2025年3月

---

## 目录

1. [引言](#1-引言)
   - 1.1 [编写目的](#11-编写目的)
   - 1.2 [背景](#12-背景)
   - 1.3 [术语](#13-术语)
   - 1.4 [参考资料](#14-参考资料)

2. [需求分析](#2-需求分析)
   - 2.1 [数据存储和处理模式分析](#21-数据存储和处理模式分析)

3. [E-R 模型设计](#3-er-模型设计)
   - 3.1 [实体及属性](#31-实体及属性)
   - 3.2 [E-R 图](#32-er-图)

4. [数据库实现](#4-数据库实现)
   - 4.1 [数据库命名约定和环境](#41-数据库命名约定和环境)
     - 4.1.1 [命名约定](#411-命名约定)
     - 4.1.2 [数据库环境](#412-数据库环境)
   - 4.2 [数据库关系图](#42-数据库关系图)
   - 4.3 [数据表信息](#43-数据表信息)
     - 4.3.1 [表列表](#431-表列表)
     - 4.3.2 [具体表结构](#432-具体表结构)
   - 4.4 [存储过程信息](#44-存储过程信息)

5. [数据库安全设计](#5-数据库安全设计)
   - 5.1 [访问控制](#51-访问控制)
   - 5.2 [数据安全](#52-数据安全)

---

## 1 引言

### 1.1 编写目的

在"基于门限签名与分布式消息传递的全链跨链桥系统（SwiftBridge）"项目的前两个阶段，即需求分析和概要设计阶段，已详细阐述系统用户对本系统的需求。本阶段将按照概要设计，对项目的链下数据存储进行详细规划，为开发人员、测试人员和系统维护人员提供参考。

本文档的读者为系统用户、程序开发员、测试人员、中继器运维人员等。

### 1.2 背景

1. 本项目的名称为：基于门限签名与分布式消息传递的全链跨链桥系统（SwiftBridge）。

2. 项目背景：随着区块链技术的发展，多链生态系统日益繁荣，但不同区块链之间的资产流通存在障碍。传统跨链桥存在中心化风险和安全隐患。SwiftBridge通过Lock & Mint模型和ECDSA签名验证机制，实现了安全可靠的跨链资产转移。本项目采用混合存储架构：智能合约数据存储在链上，交易记录、用户信息和系统日志存储在链下MongoDB数据库中，以降低Gas成本并提升查询效率。

### 1.3 术语

**跨链桥（Cross-Chain Bridge）**: 连接多个区块链网络，实现资产和数据跨链转移的协议。

**Lock & Mint**: 跨链资产转移模型，在源链锁定资产，在目标链铸造等量映射代币。

**映射代币（Wrapped Token）**: 目标链上与源链资产1:1锚定的代币。

**ECDSA签名**: 椭圆曲线数字签名算法，用于中继器授权交易。

**中继器（Relayer）**: 监听链上事件并在目标链执行相应操作的链下服务。

**MongoDB**: 面向文档的NoSQL数据库，本项目用于存储交易记录和用户数据。

**Mongoose**: MongoDB的Node.js对象模型工具，提供Schema定义和数据验证。

**Schema**: 数据结构定义，规定集合中文档的字段类型和约束。

**Collection**: MongoDB中的数据集合，相当于关系型数据库的表。

### 1.4 参考资料

[1] MongoDB Documentation. (2024). MongoDB Manual. Retrieved from https://www.mongodb.com/docs/manual/

[2] Mongoose Documentation. (2024). Mongoose ODM v8.x. Retrieved from https://mongoosejs.com/docs/

[3] Ethereum Foundation. (n.d.). Ethereum Developer Documentation. Retrieved from https://ethereum.org/en/developers/docs/

[4] Express.js Documentation. (2024). Express 5.x API Reference. Retrieved from https://expressjs.com/en/5x/api.html

[5] Socket.IO Documentation. (2024). Socket.IO 4.x Documentation. Retrieved from https://socket.io/docs/v4/

---

## 2 需求分析

### 2.1 数据存储和处理模式分析

**设计目的**：

1）需要存储跨链交易记录、用户信息、合约部署信息和系统日志，方便查询和统计分析。

2）降低链上存储成本，提升数据查询效率和用户体验。

3）支持实时数据更新和WebSocket推送，为前端提供实时交易状态。

4）为中继器提供可靠的数据持久化存储，防止服务重启后数据丢失。

**设计数据存储模式**：

**混合架构（区块链链上存储 + MongoDB链下存储）**

- **链上存储**：智能合约状态（锁定资产、映射代币余额、签名验证状态）
  - 优点：去中心化、不可篡改、透明可审计
  - 缺点：Gas成本高、查询效率低

- **链下存储（MongoDB）**：交易记录、用户信息、合约元数据、系统日志
  - 优点：查询快速、成本低、支持复杂查询
  - 缺点：需要保证数据一致性和安全性

**数据同步机制**：

- 中继器监听链上事件（AssetLocked、TokensBurned等）
- 解析事件数据并写入MongoDB
- 通过WebSocket向前端实时推送状态更新

---

## 3 E-R 模型设计

### 3.1 实体及属性

系统包括以下主要实体：

#### 1. 跨链交易记录（CrossBridgeRecord）

**源链信息**：
- 源链ID（sourceChainId）：源链的Chain ID
- 源链名称（sourceChain）：源链名称（如"Sepolia"）
- 源链RPC（sourceRpc）：源链的RPC节点地址
- 发起地址（sourceFromAddress）：用户在源链的钱包地址
- 源代币名称（sourceFromTokenName）：锁定的代币名称
- 源代币合约地址（sourceFromTokenContractAddress）：源代币合约地址
- 锁定金额（sourceFromAmount）：用户发起的锁定总金额
- 手续费（sourceFromHandingFee）：从锁定金额中扣除的手续费
- 实际锁定金额（sourceFromRealAmount）：扣除手续费后的实际金额
- 源链交易哈希（sourceFromTxHash）：Lock交易的哈希
- 源链交易状态（sourceFromTxStatus）：pending/failed/success

**目标链信息**：
- 目标链ID（targetChainId）：目标链的Chain ID
- 目标链名称（targetChain）：目标链名称（如"Imua"）
- 目标链RPC（targetRpc）：目标链的RPC节点地址
- 接收地址（targetToAddress）：目标链的接收地址
- 目标代币名称（targetToTokenName）：铸造的映射代币名称
- 目标代币合约地址（targetToTokenContractAddress）：Target合约地址
- 预期接收金额（targetToReceiveAmount）：用户将接收的代币数量
- 调用合约地址（targetToCallContractAddress）：Target.mint()调用的合约地址
- Gas费用（targetToGas）：Mint交易消耗的Gas
- 目标链交易哈希（targetToTxHash）：Mint交易的哈希
- 目标链交易状态（targetToTxStatus）：pending/failed/success

**跨链状态**：
- 跨链状态（crossBridgeStatus）：pending/failed/minted

**时间戳**：
- 创建时间（createdAt）：记录创建时间
- 更新时间（updatedAt）：记录最后更新时间

#### 2. 用户（User）

- 用户地址（address）：主键，用户的区块链钱包地址
- 所属链（chain）：用户首次连接的链（Ethereum/Imua/Zetachain）

#### 3. 合约（Contract）

- 合约地址（contractAddress）：主键，合约的部署地址
- 部署链（deployChain）：合约部署的区块链名称
- 部署链ID（deployChainId）：部署链的Chain ID
- 合约类型（contractType）：0=Source（锁定合约）、1=Target（铸造合约）
- 部署者地址（deployAddress）：部署合约的地址

#### 4. 系统日志（Log）

- 用户地址（address）：触发日志的用户地址
- 事件类型（event）：connect（连接钱包）/bridge（发起跨链）
- IP地址（IP）：用户的IP地址
- 浏览器（Browser）：用户浏览器信息
- 操作系统（System）：用户操作系统信息
- 时间戳（timestamp）：日志记录时间

### 3.2 E-R 图

```
                     ┌──────────────────┐
                     │  CrossBridgeRecord│
                     ├──────────────────┤
                     │ _id              │ PK
                     │ sourceChainId    │
                     │ sourceChain      │
                     │ sourceRpc        │
                     │ sourceFromAddress│ FK ──┐
                     │ sourceFromTokenName│    │
                     │ sourceFromTokenContractAddress│
                     │ sourceFromAmount │       │
                     │ sourceFromHandingFee│    │
                     │ sourceFromRealAmount│    │
                     │ sourceFromTxHash │       │
                     │ sourceFromTxStatus│      │
                     │ targetChainId    │       │
                     │ targetChain      │       │
                     │ targetRpc        │       │
                     │ targetToAddress  │       │
                     │ targetToTokenName│       │
                     │ targetToTokenContractAddress│ FK ──┐
                     │ targetToReceiveAmount│   │         │
                     │ targetToCallContractAddress│      │
                     │ targetToGas      │       │         │
                     │ targetToTxHash   │       │         │
                     │ targetToTxStatus │       │         │
                     │ crossBridgeStatus│       │         │
                     │ createdAt        │       │         │
                     │ updatedAt        │       │         │
                     └──────────────────┘       │         │
                              │                 │         │
                              │                 │         │
                              │ 1:N             │         │
                              │                 │         │
                              ▼                 │         │
                     ┌──────────────────┐       │         │
                     │      User        │◄──────┘         │
                     ├──────────────────┤                 │
                     │ address          │ PK              │
                     │ chain            │                 │
                     └──────────────────┘                 │
                              │                           │
                              │ 1:N                       │
                              │                           │
                              ▼                           │
                     ┌──────────────────┐                 │
                     │       Log        │                 │
                     ├──────────────────┤                 │
                     │ _id              │ PK              │
                     │ address          │ FK              │
                     │ event            │                 │
                     │ IP               │                 │
                     │ Browser          │                 │
                     │ System           │                 │
                     │ timestamp        │                 │
                     └──────────────────┘                 │
                                                          │
                     ┌──────────────────┐                 │
                     │    Contract      │◄────────────────┘
                     ├──────────────────┤
                     │ contractAddress  │ PK
                     │ deployChain      │
                     │ deployChainId    │
                     │ contractType     │
                     │ deployAddress    │
                     └──────────────────┘
```

**实体关系说明**：

1. **User ─ 1:N ─ CrossBridgeRecord**
   - 一个用户可以发起多笔跨链交易
   - 通过 `sourceFromAddress` 关联

2. **User ─ 1:N ─ Log**
   - 一个用户可以产生多条日志记录
   - 通过 `address` 关联

3. **Contract ─ 1:N ─ CrossBridgeRecord**
   - 一个合约可以处理多笔跨链交易
   - 通过 `targetToTokenContractAddress` 关联

---

## 4 数据库实现

### 4.1 数据库命名约定和环境

#### 4.1.1 命名约定

为确保代码的可读性和一致性，本项目采用以下命名约定：

1. **集合（Collection）名称**：采用大驼峰命名法（PascalCase），复数形式
   - 如：`CrossBridgeRecords`、`Users`、`Contracts`、`Logs`

2. **字段（Field）名称**：采用小驼峰命名法（camelCase）
   - 如：`sourceChainId`、`targetToAddress`、`crossBridgeStatus`

3. **Schema名称**：采用大驼峰命名法，后缀`Schema`
   - 如：`CrossBridgeRecordSchema`、`UserSchema`

4. **Model名称**：采用大驼峰命名法
   - 如：`CrossBridgeRecord`、`User`、`Contract`

5. **接口（Interface）名称**：采用大驼峰命名法，前缀`I`
   - 如：`ICrossBridgeRecord`、`IUser`、`IContract`

6. **枚举值**：采用小写字符串
   - 如：`'pending'`、`'success'`、`'failed'`、`'minted'`

7. **API路由**：采用小写字母，单词间用短横线分隔
   - 如：`/api/cross-bridge-records`、`/api/users`

#### 4.1.2 数据库环境

本项目基于MongoDB数据库，具体环境配置如下：

| 配置项 | 说明 |
|--------|------|
| **数据库类型** | MongoDB 7.0.5（NoSQL文档数据库） |
| **ODM框架** | Mongoose 8.1.1 |
| **数据库名称** | `swiftbridge`（开发环境）、`swiftbridge_prod`（生产环境） |
| **连接URL** | `mongodb://localhost:27017/swiftbridge` |
| **字符编码** | UTF-8 |
| **时区** | UTC（协调世界时） |
| **数据持久化** | WiredTiger存储引擎 |
| **索引策略** | 地址字段、交易哈希字段创建索引 |

### 4.2 数据库关系图

系统的数据关系图具体内容如图 4-1 所示。

```
┌─────────────────────────────────────────────────────────────────┐
│                     SwiftBridge数据库架构                        │
└─────────────────────────────────────────────────────────────────┘
                               │
                ┌──────────────┼──────────────┐
                │              │              │
                ▼              ▼              ▼
    ┌───────────────┐  ┌───────────────┐  ┌───────────────┐
    │  Middleware   │  │   Backend     │  │   Frontend    │
    │   (中继器)    │  │  (API服务器)  │  │  (Web应用)    │
    └───────┬───────┘  └───────┬───────┘  └───────┬───────┘
            │                  │                  │
            │ Write/Read       │ Read            │ Read
            ▼                  ▼                  ▼
    ┌───────────────────────────────────────────────────────┐
    │              MongoDB Database (swiftbridge)           │
    ├───────────────────────────────────────────────────────┤
    │                                                       │
    │  ┌────────────────────────────────────────────────┐  │
    │  │  Collection: crossbridgerecords (主表)         │  │
    │  │  - _id: ObjectId (主键)                        │  │
    │  │  - sourceFromAddress → users.address (外键)   │  │
    │  │  - targetToTokenContractAddress → contracts   │  │
    │  │  - sourceFromTxHash: String (索引)            │  │
    │  │  - targetToTxHash: String (索引)              │  │
    │  │  - crossBridgeStatus: Enum                    │  │
    │  │  - createdAt: Date (索引)                     │  │
    │  └────────────────────────────────────────────────┘  │
    │                        │                             │
    │           ┌────────────┼────────────┐                │
    │           │            │            │                │
    │  ┌────────▼─────┐  ┌──▼──────┐  ┌─▼──────────┐     │
    │  │   users      │  │contracts│  │    logs    │     │
    │  │  - address   │  │ - addr  │  │ - address  │     │
    │  │  - chain     │  │ - type  │  │ - event    │     │
    │  └──────────────┘  └─────────┘  └────────────┘     │
    └───────────────────────────────────────────────────────┘
```

### 4.3 数据表信息

#### 4.3.1 表列表

| 集合名 | 说明 | 对应Mongoose Model |
|--------|------|-------------------|
| crossbridgerecords | 跨链交易记录表 | CrossBridgeRecord |
| users | 用户信息表 | User |
| contracts | 合约部署信息表 | Contract |
| logs | 系统日志表 | Log |

#### 4.3.2 具体表结构

##### 4.3.2.1 跨链交易记录表（crossbridgerecords）

**表 4-1 跨链交易记录表**

| 序号 | 中文名称 | 字段名 | 数据类型 | 描述 | 约束 |
|------|---------|--------|---------|------|------|
| 1 | 记录ID | _id | ObjectId | MongoDB自动生成的主键 | PK, Auto |
| 2 | 源链ID | sourceChainId | Number | 源链的Chain ID（如11155111） | Required |
| 3 | 源链名称 | sourceChain | String | 源链名称（如"Sepolia"） | Required |
| 4 | 源链RPC | sourceRpc | String | 源链RPC节点URL | Required |
| 5 | 发起地址 | sourceFromAddress | String | 用户在源链的钱包地址（0x...） | Required, Index |
| 6 | 源代币名称 | sourceFromTokenName | String | 锁定的代币名称（如"ETH"） | Required |
| 7 | 源代币合约 | sourceFromTokenContractAddress | String | 源代币合约地址，原生币为0x0 | Required |
| 8 | 锁定总金额 | sourceFromAmount | String | 用户发起的锁定总金额（wei） | Required |
| 9 | 手续费 | sourceFromHandingFee | String | 扣除的手续费金额（wei） | Required |
| 10 | 实际锁定金额 | sourceFromRealAmount | String | 扣除手续费后的金额（wei） | Required |
| 11 | 源链交易哈希 | sourceFromTxHash | String | Lock交易的哈希 | Required, Unique, Index |
| 12 | 源链交易状态 | sourceFromTxStatus | String | pending/failed/success | Enum, Default: 'pending' |
| 13 | 目标链ID | targetChainId | Number | 目标链的Chain ID | Required |
| 14 | 目标链名称 | targetChain | String | 目标链名称（如"Imua"） | Required |
| 15 | 目标链RPC | targetRpc | String | 目标链RPC节点URL | Required |
| 16 | 接收地址 | targetToAddress | String | 目标链的接收地址 | Required |
| 17 | 目标代币名称 | targetToTokenName | String | 映射代币名称（如"maoETH"） | Required |
| 18 | 目标代币合约 | targetToTokenContractAddress | String | Target合约地址 | Required, Index |
| 19 | 预期接收金额 | targetToReceiveAmount | String | 用户将接收的代币数量（wei） | Required |
| 20 | 调用合约地址 | targetToCallContractAddress | String | mint()调用的合约地址 | Required |
| 21 | Gas费用 | targetToGas | String | Mint交易消耗的Gas | Required |
| 22 | 目标链交易哈希 | targetToTxHash | String | Mint交易的哈希 | Required, Unique, Index |
| 23 | 目标链交易状态 | targetToTxStatus | String | pending/failed/success | Enum, Default: 'pending' |
| 24 | 跨链状态 | crossBridgeStatus | String | pending/failed/minted | Enum, Default: 'pending' |
| 25 | 创建时间 | createdAt | Date | 记录创建时间戳 | Auto, Index |
| 26 | 更新时间 | updatedAt | Date | 记录更新时间戳 | Auto |

**索引设计**：
```javascript
// 复合索引 - 按用户查询交易
{ sourceFromAddress: 1, createdAt: -1 }

// 单字段索引 - 快速查询交易哈希
{ sourceFromTxHash: 1 }
{ targetToTxHash: 1 }

// 单字段索引 - 按状态筛选
{ crossBridgeStatus: 1 }

// 时间索引 - 按创建时间排序
{ createdAt: -1 }
```

##### 4.3.2.2 用户信息表（users）

**表 4-2 用户信息表**

| 序号 | 中文名称 | 字段名 | 数据类型 | 描述 | 约束 |
|------|---------|--------|---------|------|------|
| 1 | 记录ID | _id | ObjectId | MongoDB自动生成的主键 | PK, Auto |
| 2 | 用户地址 | address | String | 用户的区块链钱包地址 | Required, Unique, Index |
| 3 | 所属链 | chain | String | Ethereum/Imua/Zetachain | Enum, Required |

**索引设计**：
```javascript
// 唯一索引 - 确保地址唯一
{ address: 1 }  // unique: true
```

##### 4.3.2.3 合约部署信息表（contracts）

**表 4-3 合约部署信息表**

| 序号 | 中文名称 | 字段名 | 数据类型 | 描述 | 约束 |
|------|---------|--------|---------|------|------|
| 1 | 记录ID | _id | ObjectId | MongoDB自动生成的主键 | PK, Auto |
| 2 | 合约地址 | contractAddress | String | 合约的部署地址 | Required, Unique, Index |
| 3 | 部署链 | deployChain | String | 合约部署的区块链名称 | Required |
| 4 | 部署链ID | deployChainId | Number | 部署链的Chain ID | Required |
| 5 | 合约类型 | contractType | Number | 0=Source（锁定）、1=Target（铸造） | Enum [0, 1], Required |
| 6 | 部署者地址 | deployAddress | String | 部署合约的地址 | Required |

**索引设计**：
```javascript
// 唯一索引 - 确保合约地址唯一
{ contractAddress: 1 }  // unique: true

// 复合索引 - 按链查询合约
{ deployChainId: 1, contractType: 1 }
```

##### 4.3.2.4 系统日志表（logs）

**表 4-4 系统日志表**

| 序号 | 中文名称 | 字段名 | 数据类型 | 描述 | 约束 |
|------|---------|--------|---------|------|------|
| 1 | 记录ID | _id | ObjectId | MongoDB自动生成的主键 | PK, Auto |
| 2 | 用户地址 | address | String | 触发日志的用户地址 | Required, Index |
| 3 | 事件类型 | event | String | connect/bridge | Enum, Required |
| 4 | IP地址 | IP | String | 用户的IP地址 | Required |
| 5 | 浏览器 | Browser | String | 用户浏览器信息（User-Agent解析） | Required |
| 6 | 操作系统 | System | String | 用户操作系统信息 | Required |
| 7 | 时间戳 | timestamp | Date | 日志记录时间 | Default: Date.now, Index |

**索引设计**：
```javascript
// 复合索引 - 按用户和时间查询日志
{ address: 1, timestamp: -1 }

// 单字段索引 - 按事件类型筛选
{ event: 1 }

// TTL索引 - 自动删除30天前的日志
{ timestamp: 1 }  // expireAfterSeconds: 2592000 (30天)
```

### 4.4 存储过程信息

由于MongoDB是NoSQL数据库，不支持传统关系型数据库的存储过程。本系统中的数据操作逻辑以RESTful API和中继器服务函数的形式实现。以下是主要的数据操作函数：

#### 1. 创建跨链记录

**API端点**: `POST /api/cross-bridge-records`

**功能**: 在用户发起Lock交易后，中继器监听AssetLocked事件并创建跨链记录。

**实现**（Express.js + Mongoose）：
```javascript
async function createCrossBridgeRecord(data: ICrossBridgeRecord) {
  const record = new CrossBridgeRecord({
    sourceChainId: data.sourceChainId,
    sourceChain: data.sourceChain,
    sourceRpc: data.sourceRpc,
    sourceFromAddress: data.sourceFromAddress,
    sourceFromTokenName: data.sourceFromTokenName,
    sourceFromTokenContractAddress: data.sourceFromTokenContractAddress,
    sourceFromAmount: data.sourceFromAmount,
    sourceFromHandingFee: data.sourceFromHandingFee,
    sourceFromRealAmount: data.sourceFromRealAmount,
    sourceFromTxHash: data.sourceFromTxHash,
    sourceFromTxStatus: 'success',

    targetChainId: data.targetChainId,
    targetChain: data.targetChain,
    targetRpc: data.targetRpc,
    targetToAddress: data.targetToAddress,
    targetToTokenName: data.targetToTokenName,
    targetToTokenContractAddress: data.targetToTokenContractAddress,
    targetToReceiveAmount: data.targetToReceiveAmount,
    targetToCallContractAddress: data.targetToCallContractAddress,
    targetToGas: '0',
    targetToTxHash: '',
    targetToTxStatus: 'pending',

    crossBridgeStatus: 'pending'
  });

  return await record.save();
}
```

#### 2. 更新跨链记录状态

**API端点**: `PUT /api/cross-bridge-records/:txHash`

**功能**: 中继器在Target链执行Mint交易后，更新跨链记录的目标链信息和状态。

**实现**：
```javascript
async function updateCrossBridgeRecord(
  sourceFromTxHash: string,
  updateData: {
    targetToTxHash: string;
    targetToGas: string;
    targetToTxStatus: 'success' | 'failed';
    crossBridgeStatus: 'minted' | 'failed';
  }
) {
  return await CrossBridgeRecord.findOneAndUpdate(
    { sourceFromTxHash },
    {
      $set: {
        targetToTxHash: updateData.targetToTxHash,
        targetToGas: updateData.targetToGas,
        targetToTxStatus: updateData.targetToTxStatus,
        crossBridgeStatus: updateData.crossBridgeStatus,
        updatedAt: new Date()
      }
    },
    { new: true }  // 返回更新后的文档
  );
}
```

#### 3. 查询用户跨链记录

**API端点**: `GET /api/cross-bridge-records/user/:address`

**功能**: 查询指定用户的所有跨链交易记录，支持分页和状态筛选。

**实现**：
```javascript
async function getUserCrossBridgeRecords(
  address: string,
  options: {
    page?: number;
    limit?: number;
    status?: string;
  }
) {
  const page = options.page || 1;
  const limit = options.limit || 10;
  const skip = (page - 1) * limit;

  const query: any = { sourceFromAddress: address };
  if (options.status) {
    query.crossBridgeStatus = options.status;
  }

  const [records, total] = await Promise.all([
    CrossBridgeRecord.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit),
    CrossBridgeRecord.countDocuments(query)
  ]);

  return {
    records,
    pagination: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit)
    }
  };
}
```

#### 4. 查询单条交易记录

**API端点**: `GET /api/cross-bridge-records/:txHash`

**功能**: 通过源链交易哈希查询跨链记录详情。

**实现**：
```javascript
async function getCrossBridgeRecordByTxHash(txHash: string) {
  return await CrossBridgeRecord.findOne({ sourceFromTxHash: txHash });
}
```

#### 5. 创建用户记录

**API端点**: `POST /api/users`

**功能**: 用户首次连接钱包时创建用户记录。

**实现**：
```javascript
async function createUser(address: string, chain: string) {
  const existingUser = await User.findOne({ address });
  if (existingUser) {
    return existingUser;
  }

  const user = new User({ address, chain });
  return await user.save();
}
```

#### 6. 记录系统日志

**API端点**: `POST /api/logs`

**功能**: 记录用户操作日志（连接钱包、发起跨链）。

**实现**：
```javascript
async function createLog(logData: {
  address: string;
  event: 'connect' | 'bridge';
  IP: string;
  Browser: string;
  System: string;
}) {
  const log = new Log({
    address: logData.address,
    event: logData.event,
    IP: logData.IP,
    Browser: logData.Browser,
    System: logData.System,
    timestamp: new Date()
  });

  return await log.save();
}
```

#### 7. 统计查询

**功能**: 获取系统统计数据（总交易量、成功率、TVL等）。

**实现**：
```javascript
async function getStatistics() {
  const [totalTx, successTx, failedTx, pendingTx] = await Promise.all([
    CrossBridgeRecord.countDocuments(),
    CrossBridgeRecord.countDocuments({ crossBridgeStatus: 'minted' }),
    CrossBridgeRecord.countDocuments({ crossBridgeStatus: 'failed' }),
    CrossBridgeRecord.countDocuments({ crossBridgeStatus: 'pending' })
  ]);

  // 计算总锁定价值（需要代币价格API）
  const records = await CrossBridgeRecord.find({ crossBridgeStatus: 'minted' });
  // ... TVL计算逻辑

  return {
    totalTransactions: totalTx,
    successfulTransactions: successTx,
    failedTransactions: failedTx,
    pendingTransactions: pendingTx,
    successRate: totalTx > 0 ? (successTx / totalTx * 100).toFixed(2) : 0,
    // totalValueLocked: tvl
  };
}
```

---

## 5 数据库安全设计

### 5.1 访问控制

#### 角色分配

**系统管理员**：
- 权限：创建数据库、创建集合、创建索引、备份恢复、监控性能
- 角色：MongoDB内置的`dbAdmin`、`backup`角色

**中继器服务**：
- 权限：读写`crossbridgerecords`、`users`、`contracts`集合
- 角色：自定义角色`relayerRole`

**API服务器**：
- 权限：读取所有集合，写入`logs`集合
- 角色：自定义角色`apiServerRole`

**只读用户**：
- 权限：仅读取所有集合（用于数据分析、监控）
- 角色：MongoDB内置的`read`角色

#### 权限控制实现

**MongoDB用户创建**：
```javascript
// 创建中继器用户
db.createUser({
  user: "relayer",
  pwd: "强密码",
  roles: [
    {
      role: "readWrite",
      db: "swiftbridge"
    }
  ]
});

// 创建API服务器用户
db.createUser({
  user: "apiserver",
  pwd: "强密码",
  roles: [
    {
      role: "read",
      db: "swiftbridge"
    }
  ]
});

// 为API服务器添加logs集合写入权限
db.grantRolesToUser("apiserver", [
  {
    role: "readWrite",
    db: "swiftbridge"
  }
]);
```

**连接字符串认证**：
```javascript
// 中继器连接（读写权限）
mongodb://relayer:password@localhost:27017/swiftbridge?authSource=swiftbridge

// API服务器连接（只读权限）
mongodb://apiserver:password@localhost:27017/swiftbridge?authSource=swiftbridge
```

#### IP白名单

**生产环境配置**：
```yaml
# MongoDB配置文件 mongod.conf
net:
  bindIp: 127.0.0.1,10.0.1.5  # 仅允许本地和中继器服务器IP
  port: 27017

security:
  authorization: enabled  # 启用认证
```

### 5.2 数据安全

#### 数据加密

**传输加密（TLS/SSL）**：
```yaml
# MongoDB配置文件
net:
  ssl:
    mode: requireSSL
    PEMKeyFile: /etc/ssl/mongodb.pem
    CAFile: /etc/ssl/ca.pem
```

**静态数据加密（WiredTiger加密）**：
```yaml
security:
  enableEncryption: true
  encryptionKeyFile: /etc/mongodb-keyfile
```

#### 数据备份

**定时备份策略**：
```bash
#!/bin/bash
# 每日凌晨2点备份数据库
mongodump --uri="mongodb://admin:password@localhost:27017/swiftbridge" \
  --out=/backup/$(date +%Y%m%d) \
  --gzip

# 保留最近7天的备份
find /backup -type d -mtime +7 -exec rm -rf {} \;
```

**备份验证**：
```bash
# 定期测试备份恢复
mongorestore --uri="mongodb://admin:password@localhost:27017/swiftbridge_test" \
  --gzip \
  /backup/20250315
```

#### 数据校验

**MongoDB Schema验证**：
```javascript
db.createCollection("crossbridgerecords", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: [
        "sourceChainId",
        "sourceChain",
        "sourceFromAddress",
        "sourceFromTxHash",
        "targetChainId",
        "crossBridgeStatus"
      ],
      properties: {
        sourceChainId: {
          bsonType: "number",
          description: "必填且必须为数字"
        },
        sourceFromAddress: {
          bsonType: "string",
          pattern: "^0x[a-fA-F0-9]{40}$",
          description: "必须为有效的以太坊地址"
        },
        crossBridgeStatus: {
          enum: ["pending", "failed", "minted"],
          description: "只能为枚举值之一"
        }
      }
    }
  }
});
```

#### 防止注入攻击

**Mongoose参数化查询**（自动防止NoSQL注入）：
```javascript
// ✅ 安全：使用Mongoose模型查询
const user = await User.findOne({ address: userInput });

// ❌ 不安全：直接拼接查询
db.collection('users').find({ address: { $regex: userInput } });
```

**输入验证**：
```javascript
import { body, param, validationResult } from 'express-validator';

// API参数验证
app.post('/api/cross-bridge-records',
  [
    body('sourceFromAddress').matches(/^0x[a-fA-F0-9]{40}$/),
    body('sourceChainId').isInt({ min: 1 }),
    body('sourceFromAmount').isNumeric()
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    // ... 处理逻辑
  }
);
```

#### 审计日志

**操作日志记录**：
```javascript
// 记录所有数据库写操作
const auditLogger = (operation: string, collection: string, data: any) => {
  console.log({
    timestamp: new Date().toISOString(),
    operation,
    collection,
    data: JSON.stringify(data),
    user: 'relayer'  // 或当前用户
  });
};

// 使用示例
CrossBridgeRecord.create(newRecord)
  .then(result => {
    auditLogger('CREATE', 'crossbridgerecords', result);
  });
```

**MongoDB审计日志**（企业版功能）：
```yaml
auditLog:
  destination: file
  format: JSON
  path: /var/log/mongodb/audit.json
  filter: '{ atype: { $in: [ "insert", "update", "delete" ] } }'
```

#### 数据完整性检查

**一致性验证**：
```javascript
// 定期检查跨链记录的状态一致性
async function validateCrossBridgeRecords() {
  const inconsistentRecords = await CrossBridgeRecord.find({
    $or: [
      // 目标链成功但跨链状态不是minted
      {
        targetToTxStatus: 'success',
        crossBridgeStatus: { $ne: 'minted' }
      },
      // 源链或目标链失败但跨链状态不是failed
      {
        $or: [
          { sourceFromTxStatus: 'failed' },
          { targetToTxStatus: 'failed' }
        ],
        crossBridgeStatus: { $ne: 'failed' }
      }
    ]
  });

  if (inconsistentRecords.length > 0) {
    console.warn(`发现${inconsistentRecords.length}条不一致记录`);
    // 发送告警或自动修复
  }
}
```

---

**文档结束**

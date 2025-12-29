# SwiftBridge 🚀

> A fast, secure, and user-friendly cross-chain bridge for seamless asset transfers across multiple blockchain networks.

## 🌟 Overview

**SwiftBridge** is a decentralized cross-chain bridge platform that enables users to transfer assets quickly and securely between different blockchain networks. Built with modern web technologies and smart contract security best practices.

## ✨ Key Features

- ⚡ **Lightning Fast**: Optimized for speed with efficient blockchain event listeners
- 🔒 **Secure**: Industry-standard security with smart contract auditing
- 🌐 **Multi-Chain Support**:
  - Ethereum Sepolia Testnet
  - Imua Testnet
  - ZetaChain Testnet
  - PlatON Mainnet
- 💱 **Multiple Tokens**: Support for native tokens and ERC20 tokens
- 🔄 **Real-time Updates**: WebSocket-based live transaction status
- 📱 **Responsive Design**: Beautiful UI that works on all devices

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                  SwiftBridge Frontend                        │
│              Next.js 15 + React 19 + Web3                   │
│                  http://localhost:3000                      │
└────────────────┬────────────────────┬──────────────────────┘
                 │                    │
        WebSocket│                    │HTTP REST API
         (8888)  │                    │(5001)
                 │                    │
      ┌──────────▼────────┐    ┌─────▼──────────────────┐
      │   Middleware      │    │    Backend API         │
      │  Event Listener   │    │  Express Server        │
      │  Port: 3001/8888  │    │  Port: 5001            │
      └──────────┬────────┘    └─────┬──────────────────┘
                 │                    │
                 └────────┬───────────┘
                          │
                   ┌──────▼──────┐
                   │   MongoDB    │
                   │  Port: 27017 │
                   └──────────────┘
```

## 📦 Project Structure

```
毕设项目/
├── SwiftBridge-Frontend/     # Frontend application (Next.js)
├── SwiftBridge-Backend/       # REST API service (Express)
├── SwiftBridge-Middleware/    # Event listener & WebSocket server
├── SwiftBridge-Contract/      # Smart contracts (Solidity)
├── README.md                  # This file
└── quick-start.sh            # One-click startup script
```

## 🚀 Quick Start

### Prerequisites

- Node.js >= 18.0.0
- MongoDB >= 5.0
- MetaMask or compatible Web3 wallet

### Installation

1. Clone the repository
```bash
cd /Users/sifotd/Desktop/毕设项目
```

2. Install dependencies for all services
```bash
# Frontend
cd SwiftBridge-Frontend
npm install

# Backend
cd ../SwiftBridge-Backend
npm install

# Middleware
cd ../SwiftBridge-Middleware
npm install
```

3. Configure environment variables
```bash
# Copy .env.example to .env in each service folder
# Update the values according to your setup
```

### Running the Application

#### Option 1: One-click Start (Recommended)
```bash
./quick-start.sh
```

#### Option 2: Manual Start

**Terminal 1 - Frontend:**
```bash
cd SwiftBridge-Frontend
npm run dev
```

**Terminal 2 - Backend API:**
```bash
cd SwiftBridge-Backend
npm run dev
```

**Terminal 3 - Middleware:**
```bash
cd SwiftBridge-Middleware
npm run dev
```

**Terminal 4 - MongoDB:**
```bash
mongod
```

### Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Middleware**: http://localhost:3001
- **WebSocket**: ws://localhost:8888

## 🔧 Tech Stack

### Frontend
- **Framework**: Next.js 15 with Turbopack
- **UI Library**: React 19, Material-UI, Tailwind CSS
- **Web3**: Web3.js 4.x
- **HTTP Client**: Axios
- **Language**: TypeScript 5

### Backend
- **Runtime**: Node.js
- **Framework**: Express 5
- **Database**: MongoDB with Mongoose
- **Blockchain**: Ethers.js 6
- **Language**: TypeScript 5

### Middleware
- **Event Listening**: Ethers.js WebSocket Provider
- **Real-time Communication**: WebSocket (ws library)
- **Database**: MongoDB
- **Language**: TypeScript 5

### Smart Contracts
- **Language**: Solidity
- **Development**: Hardhat
- **Standards**: ERC20, Access Control

## 📝 Usage

1. **Connect Wallet**: Click "Connect Wallet" and approve the connection
2. **Select Networks**: Choose source and destination chains
3. **Select Token**: Pick the token you want to bridge
4. **Enter Amount**: Input the amount to transfer
5. **Confirm**: Review and confirm the transaction
6. **Track**: Monitor real-time status updates

## 🌐 Supported Networks

| Network | Chain ID | Currency | RPC |
|---------|----------|----------|-----|
| Ethereum Sepolia | 11155111 | ETH | Public RPC |
| Imua Testnet | 233 | IMUA | api-eth.exocore-restaking.com |
| ZetaChain Testnet | 7001 | ZETA | Public RPC |
| PlatON Mainnet | 210425 | LAT | openapi2.platon.network |

## 🔐 Security

- ✅ Smart contract security audits
- ✅ Role-based access control
- ✅ Transaction signature verification
- ✅ Replay attack protection
- ✅ Secure environment variable handling

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the ISC License.

## 👥 Team

Developed as a graduation project.

## 📞 Support

For questions or support, please open an issue in the repository.

---

**SwiftBridge** - Bridging chains, connecting futures. ⚡

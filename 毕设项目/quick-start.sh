#!/bin/bash

# 快速启动本地测试环境

echo "🚀 SwiftBridge - Fast Cross-Chain Bridge"
echo "=========================================="
echo ""

# 进入合约目录
cd SwiftBridge-Contract

# 检查是否已安装依赖
if [ ! -d "node_modules" ]; then
    echo "📦 首次运行,正在安装合约依赖..."
    npm install
    echo ""
fi

# 启动本地节点
echo "📡 正在启动本地测试节点..."
./scripts/start-local-nodes.sh

echo ""
echo "⏳ 等待 5 秒让节点完全启动..."
sleep 5

# 部署合约
echo ""
echo "📝 正在部署合约..."
./scripts/deploy-local.sh

cd ..

# 检查并启动前端
echo ""
echo "=========================================="
echo "🎨 准备启动前端..."
echo ""

cd SwiftBridge-Frontend

if [ ! -d "node_modules" ]; then
    echo "📦 正在安装前端依赖..."
    npm install
    echo ""
fi

echo "✅ 本地测试环境已准备就绪!"
echo ""
echo "📋 接下来的步骤:"
echo "  1. 在 MetaMask 中添加本地网络 (查看 LOCAL_TESTING_GUIDE.md)"
echo "  2. 导入测试账户私钥"
echo "  3. 运行 'cd SwiftBridge-Frontend && npm run dev' 启动前端"
echo "  4. 运行 'cd SwiftBridge-Backend && npm run dev' 启动后端 API"
echo "  5. 运行 'cd SwiftBridge-Middleware && npm run dev' 启动中间件"
echo ""
echo "💡 查看完整文档: README.md"
echo ""
echo "🛑 停止本地节点: cd SwiftBridge-Contract && ./scripts/stop-local-nodes.sh"

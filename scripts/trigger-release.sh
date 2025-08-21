#!/bin/bash
# Manual Release Trigger Script for bebit-tech-ios-app-sdk
# 手動觸發發布流程的腳本

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Show usage
show_usage() {
    echo -e "${BLUE}使用方式:${NC}"
    echo "  $0 <version> <checksum> <xcframework_url> [release_notes]"
    echo ""
    echo -e "${BLUE}參數說明:${NC}"
    echo "  version          - 新版本號 (例如: 1.2.3)"
    echo "  checksum         - app-popup-ios-sdk 提供的 checksum"
    echo "  xcframework_url  - XCFramework 下載 URL"
    echo "  release_notes    - 發布說明 (可選)"
    echo ""
    echo -e "${BLUE}範例:${NC}"
    echo "  $0 1.2.3 'abc123def456' 'https://github.com/beBit-tech/app-popup-ios-sdk/releases/download/1.2.3/framework.zip'"
    echo ""
}

# Check parameters
if [ $# -lt 3 ]; then
    echo -e "${RED}❌ 參數不足${NC}"
    echo ""
    show_usage
    exit 1
fi

VERSION="$1"
CHECKSUM="$2"
XCFRAMEWORK_URL="$3"
RELEASE_NOTES="${4:-Updated to latest SDK version $VERSION}"

echo -e "${BLUE}🚀 準備觸發 bebit-tech-ios-app-sdk 發布流程${NC}"
echo ""
echo -e "${BLUE}📋 發布資訊:${NC}"
echo "   版本號: $VERSION"
echo "   Checksum: ${CHECKSUM:0:16}..."
echo "   XCFramework URL: $XCFRAMEWORK_URL"
echo "   發布說明: $RELEASE_NOTES"
echo ""

# Validate version format
if ! echo "$VERSION" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[0-9]+)?)?$' > /dev/null; then
    echo -e "${RED}❌ 版本號格式不正確${NC}"
    echo -e "${BLUE}   正確格式: 1.2.3 或 1.2.3-beta.1${NC}"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "OmniSegmentKit.podspec" ]; then
    echo -e "${RED}❌ 錯誤: 請在 bebit-tech-ios-app-sdk 專案根目錄執行此腳本${NC}"
    exit 1
fi

# Check if git is clean
if git status --porcelain | grep -q .; then
    echo -e "${YELLOW}⚠️ 警告: 有未提交的變更${NC}"
    read -p "是否繼續? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if GitHub CLI is available
if ! command -v gh > /dev/null 2>&1; then
    echo -e "${RED}❌ GitHub CLI (gh) 未安裝${NC}"
    echo -e "${BLUE}   安裝指令: brew install gh${NC}"
    exit 1
fi

# Check if authenticated with GitHub
if ! gh auth status > /dev/null 2>&1; then
    echo -e "${RED}❌ 未登入 GitHub CLI${NC}"
    echo -e "${BLUE}   登入指令: gh auth login${NC}"
    exit 1
fi

# Confirm before triggering
echo -e "${YELLOW}⚠️ 即將觸發自動化發布流程${NC}"
echo ""
echo -e "${BLUE}此操作將會:${NC}"
echo "   1. 下載並更新 XCFramework"
echo "   2. 更新 OmniSegmentKit.podspec 版本"
echo "   3. 更新 Package.swift 配置"
echo "   4. 建立 Git tag 和 GitHub release"
echo "   5. 發布到 CocoaPods"
echo "   6. 觸發 test-ios-app 更新"
echo ""
read -p "確定要繼續嗎? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "取消發布"
    exit 0
fi

# Trigger the workflow
echo -e "${BLUE}🔄 觸發 GitHub Actions workflow...${NC}"

gh workflow run sdk-update.yml \
    -f version="$VERSION" \
    -f checksum="$CHECKSUM" \
    -f xcframework_url="$XCFRAMEWORK_URL" \
    -f release_notes="$RELEASE_NOTES"

echo -e "${GREEN}✅ Workflow 已觸發！${NC}"
echo ""
echo -e "${BLUE}📱 監控進度:${NC}"
echo "   GitHub Actions: https://github.com/beBit-tech/bebit-tech-ios-app-sdk/actions"
echo ""
echo -e "${BLUE}🔍 檢查狀態:${NC}"
echo "   gh run list --workflow=sdk-update.yml"
echo ""
echo -e "${BLUE}📋 完成後檢查:${NC}"
echo "   • GitHub Release: https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases"
echo "   • CocoaPods: https://cocoapods.org/pods/OmniSegmentKit"
echo "   • Swift Package Manager: https://github.com/beBit-tech/bebit-tech-ios-app-sdk"
echo ""

# Show recent workflow runs
echo -e "${BLUE}📊 最近的 Workflow 執行:${NC}"
gh run list --workflow=sdk-update.yml --limit=3

echo ""
echo -e "${GREEN}🎉 發布流程已啟動！${NC}"
echo -e "${BLUE}請等待約 5-10 分鐘完成自動化流程${NC}"
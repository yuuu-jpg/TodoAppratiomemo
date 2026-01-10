# TODOアプリ

Javaで作成したシンプルなタスク管理アプリケーション

## 📖 概要

このアプリは、日常のタスク管理を効率化するために作成しました。タスクの追加・編集・削除・完了管理ができ、JSONファイルでデータを永続化しています。

## 🎯 使用技術

- **言語**: Java
- **フレームワーク**: JSP/Servlet
- **サーバー**: Apache Tomcat 10.1
- **データ保存**: JSON形式
- **デプロイ**: Render
- **その他**: HTML/CSS, JavaScript

## ✨ 機能

- ✅ タスクの追加・編集・削除
- ✅ タスクの完了/未完了管理
- ✅ タスクごとのメモ機能
- ✅ データの永続化（JSON）
- ✅ レスポンシブデザイン

## 🚀 デモ

[デモサイトを見る](https://todoappratiomemo-2.onrender.com)

## 📂 プロジェクト構成
```
TodoAppratiomemo/
├── src/main/java/com/example/
│   ├── controller/    # Servletクラス
│   ├── model/         # Taskモデル
│   └── util/          # JSON操作ユーティリティ
├── src/main/webapp/
│   ├── index.jsp      # タスク一覧画面
│   ├── tasklist.jsp   # メモ編集画面
│   └── css/           # スタイルシート
└── pom.xml            # Maven設定
```

## 💡 工夫した点

- **データ永続化**: JSONファイルを使用してタスクデータを保存
- **直感的なUI**: シンプルで使いやすいインターフェース
- **セッション管理**: ユーザーごとのタスクリストを管理
- **エラーハンドリング**: 適切なエラー処理を実装

## 🔧 セットアップ方法

### 前提条件
- Java 17以上
- Apache Tomcat 10.1以上
- Maven

### インストール手順

1. リポジトリをクローン
```bash
git clone https://github.com/yuuu-jpg/TodoAppratiomemo.git
cd TodoAppratiomemo
```

2. Mavenでビルド
```bash
mvn clean package
```

3. Tomcatにデプロイ
```bash
# target/TodoAppratiomemo.war をTomcatのwebappsにコピー
```

4. ブラウザでアクセス
```
http://localhost:8080/TodoAppratiomemo
```

## 📸 スクリーンショット

（※後でスクリーンショットを追加予定）

## 📝 今後の実装予定

- [ ] ユーザー認証機能
- [ ] タスクのカテゴリ分け
- [ ] 期限設定と通知機能
- [ ] タスクの検索機能
- [ ] データベース連携

## 👤 作成者

yuuu-jpg

## 📄 ライセンス

MIT License

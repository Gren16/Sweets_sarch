# スイーツサーチ
サービスURL：https://sweets-sarch.net/
![ogp](https://github.com/user-attachments/assets/1f4aadcc-1247-494d-b055-4ca031457dda)
# 開発背景
私は昔から甘いものが好きで良くスイーツ店やカフェに食べに行っていました。ただ新しいお店を探す時に面倒くさくなってしまい結局行くお店が固定化してしまいました。
そこでお店を探す手間を省くようなアプリを探したときにスイーツ店に特化したアプリはありませんでした。
なので簡単にスイーツ店が探せるWebサービスを作成しました。

# 主要な機能
・現在地周辺のお店をMap上にスイーツアイコンで表示

・ルート作成機能

■ 現在地周辺のお店をMap上にスイーツアイコンで表示

![00e81f3d44b51feda5cda4630f5718f0](https://github.com/user-attachments/assets/17f47514-dcf0-4d3d-8113-4ea3f57c32eb)

■ ルート作成機能


![1648afedf5dcc7e07194d3d32ee8961d](https://github.com/user-attachments/assets/096a1f24-b34b-4987-a0b8-76b509773477)

# その他機能

## 👦 ユーザー機能

 |  メールアドレス認証  | リアルタイムバリデーション |
 | ---------------  | ------------- |
 | ![127697fbb5b3516778db35e8712e515e](https://github.com/user-attachments/assets/0659fdde-b5c9-42c5-93e5-824733a4b4e2) | ![3267040e8b0237b527897103a40a37c1](https://github.com/user-attachments/assets/ad64ab74-6dc0-4cee-b5ab-fc9db12532ba) |
 | 新規会員登録には「メールアドレス認証」を採用しました。これにより不正なアカウントを作成することなどを防ぎ、セキュリティ面の向上を図りました | リアルタイムバリデーションを導入することでユーザーに入力ミスを伝えることができ、UXの向上を図りました。 |

## 🔍 お店検索機能
 | オートコンプリート |
 | :---------------: |
 | ![d993fef644c678b10be5bbb2f1750bb7](https://github.com/user-attachments/assets/5f206b74-fa97-4d64-b051-cb9f2951270b) |
 | ユーザー検索には、オートコンプリート機能を実装して、１文字ずつ候補を表示させることで、ユーザーの入力する手間を減らし、UXの向上を図りました。 |

## 🔖 ブックマーク機能
 | ブックマーク機能 |
 | :-------------: |
 | ![d6610883a66af834fc9c5190690d3902](https://github.com/user-attachments/assets/2c493d9e-5e16-4a99-9232-27bcca39fd7e) |
 | ユーザーがお気に入りのお店を管理しやすいようブックマーク機能を追加しました。これにより気になったお店、好きなお店を管理しやすくなりました。 |

## 使用技術
 | カテゴリ | 技術 |
 | :------- | :--- |
 | バックエンド | Ruby on Rails 7.2.2.1/Ruby 3.2.3 |
 | フロントエンド | Ruby on Rails/JavaScript |
 | WebAPI | Leaflet/Overpass API/Routes API |
 | データベース | PostgreSQL |
 | 環境構築 | Docker |
 | アプリケーションサーバー | Render |
 | その他 | letter_opener_web/sorcery/kaminari/bootstrap5-kaminari-views/dotenv-rails |

 # ER図

![image](https://github.com/user-attachments/assets/ecd5a97e-4485-4c1a-8548-44d95d8d8e8c)


 # 画面遷移図
 https://www.figma.com/design/213LFobOxjkzPkF8LvBC7R/Sweets_sarch?node-id=0-1&p=f&t=P0uIwh2AolGxNGOy-0

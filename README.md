---

# ■ サービス概要

自分の歌い方を記録・共有できるアプリです。

- 歌詞を検索し、特定のフレーズに自由にメモを残すことができます。
- メモ内容はプレビュー画面で確認可能です。
- 他人が公開したメモを閲覧し、お気に入り登録することもできます。

---

# ■ このサービスへの思い・作りたい理由

**このアプリを思いついた背景や理由**

歌うことが好きで、1人カラオケによく行きます。練習の際は曲を聴き込み、歌い方を考えますが、時間が経つと細かい部分を忘れてしまうことがありました。「高校時代に歌った曲の歌い方を思い出せない」 といった経験もあり、これを防ぐために歌詞に直接メモを残せるアプリを作ろうと思いました。

また、「歌詞にメモを残す」というアイデアは他のカラオケアプリにはなく、新規性があると考えています。このアプリを通じて、練習した曲でいつでも高得点が出せるように、自分なりの歌い方を意識してメモを活用してもらいたいです。

---

# ■ ユーザー層について

**ターゲットユーザーと理由**

- **歌い方を細かく考えることが好きな人**
    - 細かく歌い方を考えるユーザーにとって、メモを残せる機能は便利だと考えたため。
- **10代～20代**
    - 主に未成年や独身層を想定。趣味系アプリは自分の時間が確保できるユーザーが使用すると考えられるため。
- **性別・職業は問わない**
- **地域は日本**
    - 開発者が日本国内に焦点を当てやすいため。
- **歌唱力向上やボイストレーニングに興味がある人**
    - 歌唱指導や練習を行う場面で歌い方を考える習慣があるため。
- **平日・週末の日中に利用が増加**
    - 独身や学生の1人カラオケは安価な時間帯に行くと考えられるため。
- **使用頻度**
    - カラオケに行く際にアプリを使用することを想定。

---

# ■ サービスの利用イメージ

**スマホ・PC対応（スマホ優先）**

以下の画面構成を想定しています。

- **歌詞画面**：歌詞のみを表示。メモ箇所はマーク表示され、内容は非表示。
- **メモプレビュー画面**：歌詞とメモを同時に表示。1画面の歌詞文字数は少なめ。
- **メモ画面**：メモの追加・編集画面。

### **利用シーン**

### 1. **歌い方を考えてメモをする場合**

価値：歌い方を詳細に記録できる。

利用画面：歌詞画面、メモ画面、メモプレビュー画面。

1. 好きな曲を検索し、歌詞画面を開く。
2. メモしたい箇所をクリックしてメモ画面へ移動。
3. 日本語でメモしたり、カラオケの加点要素（ビブラートやこぶしなど）を配置できる。
4. メモを保存後、プレビュー画面で確認。

### 2. **メモを見ながら歌う場合**

価値：習熟度に応じて適切な画面を使い分け可能。

利用画面：歌詞画面、メモプレビュー画面。

1. メモを確認しながら練習する際はメモプレビュー画面を使用。
2. メモを覚えた後は歌詞画面で全体練習。

### 3. **メモを公開する場合**

価値：公開した歌い方はいいねをもらえるので、歌い方研究のモチベーションアップにつながる。

利用画面：メモプレビュー画面。

1. 公開/非公開を選択し公開する。
2. 任意でカラオケの採点結果を写真に撮り、データをアプリにアップロードできる。信頼性の高い点数付きのメモは他の人が参考にしやすい。

### 4. **他人の歌い方を参考にする場合**

価値：より上手に歌うために必要なポイントを知ることができる。

1. 曲名で検索し、他ユーザーのメモを閲覧。
2. 気に入ったメモはお気に入りリストに追加。
3. メモにいいねを押せる。

---

# ■ ユーザーの獲得について

- カラオケ好きのコミュニティ（X、mixi2など）での宣伝。

---

# ■ サービスの差別化ポイント・推しポイント

**他サービスとの差別化**

歌い方を記録するアプリは他に類似するものがありません。スマホのメモ帳に比べ、歌の練習に特化したUIで効率的な記録が可能です。

---

# ■ 機能候補

**MVPリリース**

- トップページ
- 曲検索・一覧表示機能
- 歌詞表示機能
- メモのCRUD
- 会員登録
- ログイン機能
- いいね機能

**本リリース**

- 曲・ユーザーのマルチ検索とオートコンプリート
- フォロー・いいね通知機能
- API問い合わせのキューとバックグラウンド処理
- 採点結果の写真・カラオケ音声・カラオケ動画のアップロード機能
- (未検証)写真から点数を取得する画像認識機能
    -> 検証失敗の場合は点数の直接入力を実施する

---

# ■ 機能の実装方針予定

- **メモのCRUD**
    - Reactを使って、ブレスやテクニック系のマーク（ビブラートなど）を歌詞上に配置出来るように実装する
- **曲検索機能**
    - Genius APIを利用し、検索ワードでデータ取得。
- **歌詞表示機能**
    - Genius APIで歌詞を取得後、DBに保存。
    - メモ作成時はDBからデータを参照。
- **画像認識機能**
    - amazon rekognitionを活用。必要に応じてrubyのライブラリであるminimagickで前処理を実施。
---

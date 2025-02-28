import React, { useState, useEffect } from "react";
import { Menu, Search } from "lucide-react";

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  // メニューの開閉状態に応じて `body` にクラスを追加
  useEffect(() => {
    if (isMenuOpen) {
      document.body.classList.add("overflow-hidden");
    } else {
      document.body.classList.remove("overflow-hidden");
    }
  }, [isMenuOpen]);

  return (
    <>
      {/* オーバーレイ */}
      <div
        className={`fixed inset-0 bg-black bg-opacity-50 transition-opacity duration-300 ${
          isMenuOpen ? "opacity-100" : "opacity-0 pointer-events-none"
        }`}
        onClick={() => setIsMenuOpen(false)} // クリックでメニューを閉じる
      ></div>

      {/* ヘッダーメニュー */}

      
        <div className="relative flex items-center space-x-4">
          {/* 虫眼鏡アイコン */}
          <button className="text-black text-2xl">
            <Search />
          </button>

          {/* メニューボタンアイコン */}
          <button
            className="btn bg-blue-500 text-white rounded-lg px-4 py-2 flex items-center justify-center"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
          >
            <Menu className="w-6 h-6"/>
          </button>
          {isMenuOpen && (
            <ul
              className={`menu absolute right-0 mt-2 bg-blue-500 p-2 shadow-md rounded-lg w-48 z-50 text-white
              transition-all duration-300 ease-in-out transform ${
                isMenuOpen ? "opacity-100 scale-100" : "opacity-0 scale-95 pointer-events-none"
              }`}
            >
              <li><a href="#">ログイン/ログアウト</a></li>
              <li><a href="#">新規会員登録</a></li>
              <li><a href="#">新着メモ</a></li>
              <li><a href="#">マイページ</a></li>
              <li><a href="#">お問い合わせ</a></li>
              <li><a href="#">利用規約</a></li>
              <li><a href="#">プライバシーポリシー</a></li>
            </ul>
          )}
        </div>
    </>
  );
};

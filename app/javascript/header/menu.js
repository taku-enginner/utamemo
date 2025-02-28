document.addEventListener("DOMContentLoaded", () => {
  const menu = document.getElementById("menu");
  const overlay = document.getElementById("overlay");

  if (menu && overlay) {
    menu.addEventListener("toggle", () => {
      if (menu.open) {
        overlay.classList.remove("hidden");
      }else{
        overlay.classList.add("hidden");
      }
    });
    // オーバーレイをクリックしたらメニューを閉じる
    overlay.addEventListener("click", () => {
      menu.open = false;
      overlay.classList.add("hidden");
    });
  }
});
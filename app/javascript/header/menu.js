// turbo:loadにするとturboで読み込まれた時にも実行されるようになる
document.addEventListener("turbo:load", () => {
  const menuButton = document.getElementById("menu-button");
  const menuContent = document.getElementById("menu-content");
  const menuOverlay = document.getElementById("menu-overlay");

  if (menuButton && menuContent && menuOverlay) {
    menuButton.addEventListener("click", () => {
      menuContent.classList.toggle("hidden");
      menuOverlay.classList.toggle("opacity-30");
      menuOverlay.classList.toggle("pointer-events-none");
    });

    //  メニューの外をクリックしたら閉じる
    menuOverlay.addEventListener("click", () => {
      menuContent.classList.add("hidden");
      menuOverlay.classList.remove("opacity-30");
      menuOverlay.classList.add("pointer-events-none");
   });
  };
});
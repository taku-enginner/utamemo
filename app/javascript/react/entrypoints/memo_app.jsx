import React from "react";
import { createRoot } from "react-dom/client";
import Memos from "../features/memos";

const renderReactApp = () => {
  const container = document.getElementById("utamemo");
  if (container) {
    const root = createRoot(container);
    root.render(<Memos/>);
  }
}

document.addEventListener("turbo:load", renderReactApp);
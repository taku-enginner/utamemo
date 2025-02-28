import React from "react";
import { createRoot } from "react-dom/client";
import Memos from "../features/memos";

const container = document.getElementById("utamemo");
if (container) {
  const root = createRoot(container);
  root.render(<Memos/>);
}
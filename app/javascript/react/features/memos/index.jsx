import React, { useState, useEfect } from "react";
import Draggable from "react-draggable";

export default function Memos(インスタンス変数) {
  const [components, setComponents] = useState([]);
  const [selectedComponent, setSelectedComponent] = useState(null);
  const [componentGroups, setComponentGroups] = useState([]);

  setComponentGroups(インスタンス変数)
  console.log("componentGroups", componentGroups);

  return (
    <>
      hello world react
    </>
  );
}
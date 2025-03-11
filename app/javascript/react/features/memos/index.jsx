import React, { useState, useEfect } from "react";
import Draggable from "react-draggable";

export default function Memos({ memo_components }) {
  const [components, setComponents] = useState([]);
  const [selectedComponent, setSelectedComponent] = useState(null);
  const [componentGroups, setComponentGroups] = useState([]);

  console.log("memo_components", memo_components);

  return (
    <>
      <div>
        {memo_components}
        components
      </div>
    </>
  );
}
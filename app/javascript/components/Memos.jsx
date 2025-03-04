import React, { useState, useEffect } from "react";
import Draggable from "react-draggable";

export default function Memos({ memo_components }) {
  const [components, setComponents] = useState([]);
  const [selectedComponent, setSelectedComponent] = useState(null);
  const [componentGroups, setComponentGroups] = useState([]);

  console.log("memo_components", memo_components);
  useEffect(() => {
    setComponents(memo_components);
  }, [memo_components]);
  
  return (
    <>
      <div className="bg-red-200">

        {components?.map((component) => (
          <Draggable
            key={component.id}
            position={{ x: component.x, y: component.y}}
            bounds="parent"
          >
            <div className="bg-white p-2 border border-gray-300 rounded-md shadow-md">
              {component.content}
            </div>
          </Draggable>
        ))}
      </div>
    </>
  );
}
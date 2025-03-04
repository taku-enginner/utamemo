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
  
  const addComponent = () => {
    const componentId = components.length + 1;
    setComponents([...components, { x: 100, y: 100, id: componentId, content: `New Component ${componentId}`}])
  }
  return (
    <>
      <div className="relative">
        <div className="absolute top-0 left-0 w-full">
          <button onClick={addComponent} className="btn">コンポーネントを追加</button>
          {components?.map((component) => (
            <Draggable
              key={component.id}
              position={{ x: component.x, y: component.y}}
              bouds="parent"
            >
              <div className="component bg-white border border-gray-300 rounded-md shadow-md p-2 
              max-w-xs w-fit whitespace-normal break-words flex items-center justify-center absolute">
                {component.content}
              </div>
            </Draggable>
            ))}
        </div>
      </div>
    </>
  );
}
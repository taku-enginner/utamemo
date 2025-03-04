import React, { useState, useEffect } from "react";
import Draggable from "react-draggable";
import axios from "axios";

export default function Memos({ memo }) {
  console.log("memo", memo);
  const [components, setComponents] = useState([]);
  const [selectedComponent, setSelectedComponent] = useState(null);
  const [componentGroups, setComponentGroups] = useState([]);

  
  useEffect(() => {
    setComponents(memo.memo_components);
  }, [memo]);

  useEffect(() => {
    console.log("components", components);
  }, [components]);
  
  const addComponent = () => {
    const componentId = components.length + 1;
    setComponents([...components, { x: 100, y: 100, id: componentId, type: "technique", content: `New Component ${componentId}`}])
  }

  const updatePosition = (id, data) => {
    const UpdateComponent = components.map((component)=>{
      if(component.id === id){
        return {
          ...component,
            id: component.id,
            x: data.x,
            y: data.y
        }
      }
      return component;
    });
    setComponents(UpdateComponent);
  }

  const saveComponents = async() => {
    try {
      const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

      const response = await axios.patch(`/memos/${memo.id}`, {
        memo_components: components,
      }, {
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
      });
      console.log("Success:", response.data);
    } catch (error) {
      console.error("Error:", error);
    }
  }

  return (
    <>
      <div className="relative">

        <div className="absolute top-0 left-0 w-full">
          <button onClick={addComponent} className="btn">コンポーネントを追加</button>
          <button onClick={saveComponents} className="btn">保存</button>
          {components?.map((component) => (
            <Draggable
              key={component.id}
              position={{ x: component.x, y: component.y}}
              onStop={(e, data) => updatePosition(component.id, data)}
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
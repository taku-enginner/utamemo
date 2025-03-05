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

  const deleteComponent = (id) => {
    setComponents(components.filter(component => component.id !== id))
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
      console.log("status:", response.status);

      // 保存成功時フラッシュメッセージ
      const flashmessage = document.getElementById("flash-message");
      flashmessage.innerHTML = "保存しました";
      flashmessage.classList.remove("hidden");
      flashmessage.classList.add("bg-green-600");
      setTimeout(() => {
        flashmessage.classList.add("hidden");
        flashmessage.classList.remove("bg-green-600");
      }, 3000);

    } catch (error) {
      console.error("Error:", error);
      console.log("status:", response.status);

      // 保存失敗時フラッシュメッセージ
      const flashmessage = document.getElementById("flash-message");
      flashmessage.innerHTML = "保存に失敗しました";
      flashmessage.classList.remove("hidden");
      flashmessage.classList.add("bg-red-600");
      setTimeout(() => {
        flashmessage.classList.add("hidden");
        flashmessage.classList.remove("bg-red-600");
      }, 3000);
    }
  }

  return (
    <>
      <div id="flash-message" className="hidden bg-white p-2 w-full">あいうえお</div>
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
              <div>
                <div className="component bg-white border border-gray-300 rounded-md shadow-md p-2 
                max-w-xs w-fit whitespace-normal break-words flex items-center justify-center absolute flex flex-col"
                     onClick={(e) => {
                      e.stopPropagation();
                      setSelectedComponent(component.id);
                     }}
                     onTouchStart={(e) => {
                      e.stopPropagation();
                      setSelectedComponent(component.id);
                     }}
                >
                  <div>
                    {selectedComponent === component.id && (
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          deleteComponent(component.id);
                        }}
                        onTouchStart={(e) => {
                          e.stopPropagation();
                          deleteComponent(component.id);
                        }}
                      >
                        ✕
                      </button>

                    )}
                  </div>
                  <div>
                    {component.content}                   
                  </div>
                </div>
              </div>
            </Draggable>
            ))}
        </div>
      </div>
    </>
  );
}
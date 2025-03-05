import React, { useState, useEffect } from "react";
import Draggable from "react-draggable";
import axios from "axios";

export default function Memos({ memo }) {
  console.log("memo", memo);
  const [components, setComponents] = useState(memo.memo_components);
  const [selectedComponent, setSelectedComponent] = useState(null);
  const [inputType, setInputType] = useState("technique");

  // 試しに消して、useStateの初期値に入れてみる。本番環境で問題なければそっちに変更。
  // useEffect(() => {
  //   setComponents(memo.memo_components);
  // }, [memo]);



  useEffect(() => {
    console.log("components", components);
  }, [components]);
  
  // 入力モード変更
  useEffect(() => {
    console.log("inputType", inputType);
    if (inputType === "technique"){
      // テクニックモードの場合
      const target = document.getElementById("technique")
      target.classList.remove("hidden")
      const no_target = document.getElementById("comment")
      no_target.classList.add("hidden")
    }else{
      // コメントモードの場合
      const target = document.getElementById("comment")
      target.classList.remove("hidden")
      const no_target = document.getElementById("technique")
      no_target.classList.add("hidden")
    }
  },[inputType]);

  // テクニックコンポーネント追加
  const addTechniqueComponent = () => {
    const componentId = components.length + 1;
    setComponents([...components, { x: 100, y: 100, id: componentId, type: "technique", content: `New Component ${componentId}`}])
  }

  // コメントコンポーネント追加
  const addCommentComponent = () => {
    const componentId = components.length + 1;
    const comment = document.getElementById("comment_input").value
    setComponents([...components, { x: 100, y: 100, id: componentId, type: "comment", content: comment}])
  }

  // コンポーネント削除
  const deleteComponent = (id) => {
    setComponents(components.filter(component => component.id !== id))
  }

  // コンポーネントの位置更新
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

  // コンポーネント保存
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
      {/* ツールバー  */}
      <div className="p-5 flex flex-row between space-x-2">
        <button
          className="btn"
          onClick={() => setInputType("technique")
          }
        >テクニック</button>
        <button 
          className="btn"
          onClick={() => setInputType("comment")
          }
        >コメント</button>
        <button onClick={saveComponents} className="btn">保存</button>
      </div>

      {/* フラッシュメッセージ */}
      <div id="flash-message" className="hidden bg-white p-2 w-full"></div>

      {/* コンポーネント配置 */}
      <div className="relative">
        <div className="absolute top-0 left-0 w-full">

        {/* ツールバー（テクニック） */}
        <div className="p-5 flex flex-row between space-x-2" id="technique">
          <button onClick={addTechniqueComponent} className="btn">コンポ追加</button>
          <button onClick={addTechniqueComponent} className="btn">コンポ追加</button>
          <button onClick={addTechniqueComponent} className="btn">コンポ追加</button>
        </div>

        {/* ツールバー（コメント） */}
        <div className="p-5 flex flex-row between space-x-2 hidden" id="comment">
          <input className="" id="comment_input"></input>
          <button onClick={addCommentComponent} className="btn">コメント追加</button>

        </div>
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
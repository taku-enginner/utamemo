import React, { useState, useEffect, useRef } from "react";
import Draggable from "react-draggable";
import axios from "axios";

export default function MyMemos({ memo }) {
  console.log("memo", memo);
  const [components, setComponents] = useState([]);
  const [selectedComponent, setSelectedComponent] = useState(null);
  const [inputType, setInputType] = useState("technique");

  // テクニックボタンの参照を作成
  const techniqueButtonRef  = useRef(null);

  // コメントボタンの参照を作成
  const commentButtonRef  = useRef(null);


  useEffect(() => {
    setComponents(memo.memo_components);
  }, []);
  
  // 入力モード変更
  useEffect(() => {
    console.log("inputType", inputType);
    let technique_button = document.getElementById("technique_button");
    let technique = document.getElementById("technique");
    let comment_button =  document.getElementById("comment_button");
    let comment = document.getElementById("comment");
    let preview_button = document.getElementById("preview_button");

    switch (inputType) {
      case "technique":
        technique_button.classList.remove("bg-gray-300")
        technique_button.classList.add("bg-red-300")
        technique.classList.remove("hidden")
        comment_button.classList.remove("bg-red-300")
        comment_button.classList.add("bg-gray-300")
        comment.classList.add("hidden")
        preview_button.classList.remove("bg-red-300")
        preview_button.classList.add("bg-gray-300")
        break;
      case "comment":
        comment_button.classList.remove("bg-gray-300")
        comment_button.classList.add("bg-red-300")
        comment.classList.remove("hidden")
        technique_button.classList.remove("bg-red-300")
        technique_button.classList.add("bg-gray-300")
        technique.classList.add("hidden")
        preview_button.classList.remove("bg-red-300")
        preview_button.classList.add("bg-gray-300")
        break;
      case "preview":
        preview_button.classList.remove("bg-gray-300")
        preview_button.classList.add("bg-red-300")
        technique_button.classList.remove("bg-red-300")
        technique_button.classList.add("bg-gray-300")
        technique.classList.add("hidden")
        comment_button.classList.remove("bg-red-300")
        comment_button.classList.add("bg-gray-300")
        comment.classList.add("hidden")
        break;
      default:
        console.log("inputTypeが見つかりません")
    }
  },[inputType]);

  // テクニックコンポーネント追加
  const addTechniqueComponent = () => {
    if (techniqueButtonRef.current){
      const rect = techniqueButtonRef.current.getBoundingClientRect(); // ここで座標を取得
      const componentId = components.length + 1;
  
      setComponents([
        ...components, 
        { 
          x: rect.left + window.scrollX, 
          y: rect.top + window.scrollY - rect.height - 250, 
          id: componentId, 
          type: "technique", 
          content: `New Component ${componentId}`
        }
      ])
    }
  }

  // コメントコンポーネント追加
  const addCommentComponent = () => {
    const componentId = components.length + 1;
    const rect = commentButtonRef.current.getBoundingClientRect(); // ここで座標を取得

    const comment = document.getElementById("comment_input")
    setComponents([
      ...components,
       { 
          x: rect.left + window.scrollX, 
          y: rect.top + window.scrollY - rect.height - 180,
          id: componentId, 
          type: "comment", 
          content: comment.value
       }])
    comment.value = ""
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
      flashmessage.classList.add("bg-green-600");
      flashmessage.classList.remove("hidden");
      setTimeout(() => {
        flashmessage.classList.add("hidden");
        flashmessage.classList.remove("bg-green-600");
      }, 3000);

    } catch (error) {
      console.error("Error:", error);

      // 保存失敗時フラッシュメッセージ
      const flashmessage = document.getElementById("flash-message");
      flashmessage.innerHTML = "保存に失敗しました";
      flashmessage.classList.add("bg-red-600");
      flashmessage.classList.remove("hidden");
      setTimeout(() => {
        flashmessage.classList.add("hidden");
        flashmessage.classList.remove("bg-red-600");
      }, 3000);
    }
  }

  return (
    <div className="relative">
      {/* コンポーネント配置 */}
      <div className="relative">
        <div className="absolute top-0 left-0 w-full">

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
      <div className="fixed w-full bottom-0 right-0 shadow-lg">
        {/* フラッシュメッセージ */}
        <div id="flash-message" className="hidden p-2 w-full text-white"></div>

        <div>
          {/* ツールバー（テクニック） */}
          <div className="flex flex-row justify-center space-x-1 hidden" id="technique">
            <button onClick={addTechniqueComponent} className="btn">追加</button>
            <button onClick={addTechniqueComponent} className="btn">追加</button>
            <button onClick={addTechniqueComponent} className="btn">追加</button>
            <button onClick={addTechniqueComponent} className="btn">追加</button>
            <button onClick={addTechniqueComponent} className="btn">追加</button>
          </div>

          {/* ツールバー（コメント） */}
          <div className="flex flex-row justify-center space-x-2 hidden" id="comment">
            <input 
              className="w-[85%] border border-gray-400 rounded-lg p-1"
              ref={commentButtonRef} 
              id="comment_input"
              placeholder="   コメントを入力"/>
            <button onClick={addCommentComponent} className="btn">コメント<br/>追加</button>
          </div>
        </div>
        {/* ツールバー  */}
        <div className="pt-1 flex flex-row justify-center space-x-2" >
          <button
            className="btn bg-gray-300"
            ref={techniqueButtonRef} 
            onClick={() => setInputType("technique")}
            id = "technique_button"
          >テクニック</button>
          <button 
            className="btn bg-gray-300"
            onClick={() => setInputType("comment")
            }
            id = "comment_button"
          >コメント</button>
          <button 
            className="btn bg-gray-300"
            onClick={() => setInputType("preview")
            }
            id = "preview_button"
          >プレビュー</button>
          <button onClick={saveComponents} className="btn">保存</button>
        </div>
      </div>
    </div>
  );
}
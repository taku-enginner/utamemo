import React, { useState, useEffect } from "react";
import axios from "axios";

export default function ToolBar({ memo }) {
  const [components, setComponents] = useState(memo.memo_components);
  const [inputType, setInputType] = useState("technique");
  
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
    const componentId = components.length + 1;
    setComponents([...components, { x: 100, y: 100, id: componentId, type: "technique", content: `New Component ${componentId}`}])
  }

  // コメントコンポーネント追加
  const addCommentComponent = () => {
    const componentId = components.length + 1;
    const comment = document.getElementById("comment_input")
    setComponents([...components, { x: 100, y: 100, id: componentId, type: "comment", content: comment.value}])
    comment.value = ""
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
      <div className="fixed w-full bottom-0 right-0">
        <div>
          {/* ツールバー（テクニック） */}
          <div className="p-3 flex flex-row between space-x-2 hidden" id="technique">
            <button onClick={addTechniqueComponent} className="btn">コンポ追加</button>
            <button onClick={addTechniqueComponent} className="btn">コンポ追加</button>
            <button onClick={addTechniqueComponent} className="btn">コンポ追加</button>
          </div>

          {/* ツールバー（コメント） */}
          <div className="p-3 flex flex-row between space-x-2 hidden" id="comment">
            <input className="" id="comment_input"></input>
            <button onClick={addCommentComponent} className="btn">コメント追加</button>
          </div>
        </div>
        {/* ツールバー  */}
        <div className="p-3 flex flex-row between space-x-2">
          <button
            className="btn bg-gray-300"
            onClick={() => setInputType("technique")
            }
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
   </>
  );
}
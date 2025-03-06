import React from "react";

export default function OtherMemos({ memo }) {

  return (
    <>
      {/* コンポーネント配置 */}
      <div className="relative">
        <div className="absolute top-0 left-0 w-full">
          {memo.memo_components?.map((component) => (
            <div
            key={component.id}
            className="absolute bg-white border border-gray-300 rounded-md shadow-md p-2"
            style={{
              left: `${component.x}px`,  // x座標
              top: `${component.y}px`,   // y座標
            }}
            >
              {component.content}
            </div>
          ))}
        </div>
      </div>
    </>
  );
}
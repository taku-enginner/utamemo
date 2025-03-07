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
            className="absolute bg-white rounded-md shadow-md"
            style={{
              left: `${component.x}px`,  // x座標
              top: `${component.y}px`,   // y座標
            }}
            >
              <div className="text-black text-2xl bg-white rounded-lg">
                    {
                      // コンポーネントの数字によって画像を変更。三項演算子を使用
                      component.type==="technique" ? (() => {
                        let techniqueImage;
                        switch (component.content) {
                          case "1":
                            techniqueImage = <img src="/technique/ビブラート.png" alt="ビブラート" style={{ width: "50px", height: "50px"}}/>
                            break;
                          case "2":
                            techniqueImage = <img src="/technique/しゃくり.png" alt="しゃくり" style={{ width: "50px", height: "50px"}}/>
                            break;
                          case "3":
                            techniqueImage = <img src="/technique/こぶし.png" alt="こぶし" style={{ width: "50px", height: "50px"}}/>
                            break;
                          case "4":
                            techniqueImage = <img src="/technique/フォール.png" alt="フォール" style={{ width: "50px", height: "50px"}}/>
                            break;
                          case "5":
                            techniqueImage = <img src="/technique/ブレス.png" alt="ブレス" style={{ width: "50px", height: "50px"}}/>
                            break;
                          default:
                            techniqueImage =  <div className="bg-red-500 text-white">表示エラーが起きました。</div>
                          }
                        return techniqueImage;
                        })() : component.content}
                  </div>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}
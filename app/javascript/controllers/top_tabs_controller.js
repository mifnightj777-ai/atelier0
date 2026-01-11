import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background", "worldLink", "teammatesLink"]

  connect() {
    // 読み込み時に何かする必要があればここに書きます
  }

  switchToWorld() {
    // 1. 背景ピルを左（インディゴ）へ
    this.backgroundTarget.className = "absolute top-1 bottom-1 rounded-full transition-all duration-300 ease-[cubic-bezier(0.23,1,0.32,1)] left-1 w-[calc(50%-4px)] bg-indigo-600 shadow-md shadow-indigo-500/30 border border-indigo-500"
    
    // 2. Worldの文字を白く
    this.worldLinkTarget.classList.remove("text-slate-500", "hover:text-indigo-600")
    this.worldLinkTarget.classList.add("text-white")
    
    // 3. Teammatesの文字をグレーに
    // (存在する場合のみ実行)
    if (this.hasTeammatesLinkTarget) {
      this.teammatesLinkTarget.classList.remove("text-white")
      this.teammatesLinkTarget.classList.add("text-slate-500", "hover:text-amber-600")
    }
  }

  switchToTeammates() {
    // 1. 背景ピルを右（アンバー）へ
    this.backgroundTarget.className = "absolute top-1 bottom-1 rounded-full transition-all duration-300 ease-[cubic-bezier(0.23,1,0.32,1)] left-[calc(50%+2px)] w-[calc(50%-4px)] bg-amber-500 shadow-md shadow-amber-500/30 border border-amber-400"
    
    // 2. Teammatesの文字を白く
    this.teammatesLinkTarget.classList.remove("text-slate-500", "hover:text-amber-600")
    this.teammatesLinkTarget.classList.add("text-white")

    // 3. Worldの文字をグレーに
    this.worldLinkTarget.classList.remove("text-white")
    this.worldLinkTarget.classList.add("text-slate-500", "hover:text-indigo-600")
  }
}
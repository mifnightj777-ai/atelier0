import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background", "creationsLink", "savedLink"]

  switchToCreations() {
    this.backgroundTarget.className = "absolute top-1 bottom-1 rounded-full transition-all duration-500 ease-[cubic-bezier(0.23,1,0.32,1)] left-1 w-[calc(50%-4px)] bg-indigo-600 shadow-[0_4px_14px_0_rgba(79,70,229,0.39)]"
    
    // 文字色を変更
    this.creationsLinkTarget.classList.remove("text-slate-400", "hover:text-slate-600")
    this.creationsLinkTarget.classList.add("text-white")
    
    this.savedLinkTarget.classList.remove("text-white")
    this.savedLinkTarget.classList.add("text-slate-400", "hover:text-slate-600")
  }

  switchToSaved() {
    this.backgroundTarget.className = "absolute top-1 bottom-1 rounded-full transition-all duration-500 ease-[cubic-bezier(0.23,1,0.32,1)] left-[calc(50%+4px)] w-[calc(50%-8px)] bg-pink-500 shadow-[0_4px_14px_0_rgba(236,72,153,0.39)]"

    this.creationsLinkTarget.classList.remove("text-white")
    this.creationsLinkTarget.classList.add("text-slate-400", "hover:text-slate-600")
    
    this.savedLinkTarget.classList.remove("text-slate-400", "hover:text-slate-600")
    this.savedLinkTarget.classList.add("text-white")
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["creationsLink", "savedLink"]

  switchToCreations() {
    // Creationsをアクティブに（黒文字・下線あり）
    this.creationsLinkTarget.classList.add("text-slate-900", "border-indigo-600")
    this.creationsLinkTarget.classList.remove("text-slate-400", "border-transparent")
    
    // Savedを非アクティブに（グレー文字・下線なし）
    this.savedLinkTarget.classList.remove("text-slate-900", "border-pink-500")
    this.savedLinkTarget.classList.add("text-slate-400", "border-transparent")
  }

  switchToSaved() {
    // Savedをアクティブに（黒文字・下線あり）
    this.savedLinkTarget.classList.add("text-slate-900", "border-pink-500")
    this.savedLinkTarget.classList.remove("text-slate-400", "border-transparent")

    // Creationsを非アクティブに（グレー文字・下線なし）
    this.creationsLinkTarget.classList.remove("text-slate-900", "border-indigo-600")
    this.creationsLinkTarget.classList.add("text-slate-400", "border-transparent")
  }
}
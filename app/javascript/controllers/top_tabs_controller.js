import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background", "worldLink", "teammatesLink"]

  switchToWorld() {

    this.backgroundTarget.className = "absolute top-1.5 bottom-1.5 rounded-full transition-all duration-500 ease-[cubic-bezier(0.23,1,0.32,1)] left-1 w-[calc(50%-4px)] bg-indigo-600 shadow-[0_4px_14px_0_rgba(79,70,229,0.39)]"
    
    this.worldLinkTarget.classList.remove("text-slate-400", "hover:text-indigo-600")
    this.worldLinkTarget.classList.add("text-white")
    
    this.teammatesLinkTarget.classList.remove("text-white")
    this.teammatesLinkTarget.classList.add("text-slate-400", "hover:text-amber-600")
  }

  switchToTeammates() {
    this.backgroundTarget.className = "absolute top-1.5 bottom-1.5 rounded-full transition-all duration-500 ease-[cubic-bezier(0.23,1,0.32,1)] left-[calc(50%+4px)] w-[calc(50%-8px)] bg-amber-500 shadow-[0_4px_14px_0_rgba(245,158,11,0.39)]"
    
    this.worldLinkTarget.classList.remove("text-white")
    this.worldLinkTarget.classList.add("text-slate-400", "hover:text-indigo-600")
    
    this.teammatesLinkTarget.classList.remove("text-slate-400", "hover:text-amber-600")
    this.teammatesLinkTarget.classList.add("text-white")
  }
}
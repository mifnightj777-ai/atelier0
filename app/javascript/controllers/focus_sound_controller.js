import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  SOUND_SOURCES = {
    rain:     "https://actions.google.com/sounds/v1/weather/rain_on_rooftop.ogg",
    fire:     "https://actions.google.com/sounds/v1/ambiences/fire.ogg",
    coffee:   "https://actions.google.com/sounds/v1/ambiences/coffee_shop.ogg",
    airplane: "https://actions.google.com/sounds/v1/transportation/airplane_in_flight.ogg",
    engine:   "https://actions.google.com/sounds/v1/transportation/car_engine_idling_accelerating.ogg"
  }

  connect() {
    this.audios = {}
    this.currentAudio = null
    this.currentButton = null
    
    const unlock = () => {
      Object.values(this.SOUND_SOURCES).forEach(url => {
        const a = new Audio(url); a.muted = true; a.play().then(() => a.pause());
      });
      window.removeEventListener('click', unlock);
    };
    window.addEventListener('click', unlock);
  }

  toggle(event) {
    const button = event.currentTarget
    const type = button.dataset.soundType
    const url = this.SOUND_SOURCES[type]

    // 1. 同じボタンを再度押した場合は停止する
    if (this.currentAudio && this.currentButton === button) {
      this.stopCurrent();
      return;
    }

    // 2. Aを止めてBを鳴らす：現在鳴っている音をすべてリセット
    this.stopAll();

    // 3. 新しい音を再生
    const audio = new Audio(url)
    audio.loop = true
    this.currentAudio = audio
    this.currentButton = button

    this.currentAudio.play()
      .then(() => this.setActive(button))
      .catch(() => {});
  }

  stopAll() {
    if (this.currentAudio) {
      this.currentAudio.pause();
      this.currentAudio = null;
    }
    this.buttonTargets.forEach(btn => this.setInactive(btn));
  }

  stopCurrent() {
    if (this.currentAudio) {
      this.currentAudio.pause();
      this.currentAudio = null;
    }
    if (this.currentButton) {
      this.setInactive(this.currentButton);
      this.currentButton = null;
    }
  }

  setActive(button) {
    button.classList.add("text-indigo-600", "bg-indigo-50", "shadow-inner")
    button.classList.remove("text-slate-400")
  }

  setInactive(button) {
    button.classList.remove("text-indigo-600", "bg-indigo-50", "shadow-inner")
    button.classList.add("text-slate-400")
  }
}
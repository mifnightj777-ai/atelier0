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
    this.currentButton = null
    
    // 現在、裏側で音が流れているかチェックし、流れていれば該当ボタンを青くする
    const globalAudio = this.globalAudioElement
    if (globalAudio && !globalAudio.paused && globalAudio.src) {
      // どの音が流れているかURLから逆引きする
      const playingType = Object.keys(this.SOUND_SOURCES).find(key => 
        globalAudio.src === this.SOUND_SOURCES[key]
      )
      
      if (playingType) {
        // 該当するボタンを探してアクティブにする
        const activeBtn = this.buttonTargets.find(btn => btn.dataset.soundType === playingType)
        if (activeBtn) {
          this.currentButton = activeBtn
          this.setActive(activeBtn)
        }
      }
    }
  }

  // 裏側に仕込んだオーディオ要素を取得する便利メソッド
  get globalAudioElement() {
    return document.getElementById("morphe-global-player")
  }

  toggle(event) {
    const button = event.currentTarget
    const type = button.dataset.soundType
    const url = this.SOUND_SOURCES[type]
    
    const globalAudio = this.globalAudioElement
    if (!globalAudio) return

    // 1. 同じボタンを再度押した場合は停止する
    // (URLが一致し、かつ再生中の場合)
    if (!globalAudio.paused && globalAudio.src === url) {
      this.stopCurrent(globalAudio);
      return;
    }

    // 2. Aを止めてBを鳴らす：見た目のリセット
    this.resetAllButtons();

    // 3. 裏側のプレイヤーに新しい曲をセットして再生
    globalAudio.src = url
    globalAudio.volume = 0.5 // 音量はお好みで
    globalAudio.play()
      .then(() => {
        this.currentButton = button
        this.setActive(button)
      })
      .catch((e) => {
        console.error("Playback failed:", e)
      });
  }

  stopCurrent(audio) {
    audio.pause();
    // srcを空にしないと、再開時にバグることがあるのでリセットしても良いが
    // ここではpauseのみにしておく（再開が早い）
    if (this.currentButton) {
      this.setInactive(this.currentButton);
      this.currentButton = null;
    }
  }

  resetAllButtons() {
    this.buttonTargets.forEach(btn => this.setInactive(btn));
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
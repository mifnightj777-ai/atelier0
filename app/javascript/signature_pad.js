export default class SignaturePad {
  constructor(canvas, options = {}) {
    this.canvas = canvas;
    this.options = options;
    this._ctx = canvas.getContext("2d");
    this._isDown = false;
    this._points = [];
    
    this.lineWidth = options.minWidth || 3;
    this.penColor = options.penColor || "black";
    this.backgroundColor = options.backgroundColor || "rgba(0,0,0,0)";
    
    this._handleDown = this._handleDown.bind(this);
    this._handleMove = this._handleMove.bind(this);
    this._handleUp = this._handleUp.bind(this);
    
    this.on();
  }

  setLineWidth(width) {
    this.lineWidth = width;
  }

  // ★追加: 保存された画像をキャンバスに復元する機能
  fromDataURL(dataUrl) {
    return new Promise((resolve) => {
      const image = new Image();
      image.onload = () => {
        // 画像を描画
        this._ctx.drawImage(image, 0, 0, this.canvas.width, this.canvas.height);
        resolve();
      };
      image.src = dataUrl;
    });
  }

  clear() {
    this._ctx.fillStyle = this.backgroundColor;
    this._ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this._ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
    this._points = [];
  }

  toDataURL(type = "image/png", quality) {
    return this.canvas.toDataURL(type, quality);
  }

  isEmpty() {
    return this._points.length === 0;
  }

  activePen() {
    this._ctx.globalCompositeOperation = 'source-over';
  }

  activeEraser() {
    this._ctx.globalCompositeOperation = 'destination-out';
  }

  on() {
    this.canvas.style.touchAction = "none";
    this.canvas.addEventListener("mousedown", this._handleDown);
    this.canvas.addEventListener("mousemove", this._handleMove);
    document.addEventListener("mouseup", this._handleUp);
    
    this.canvas.addEventListener("touchstart", (e) => {
      e.preventDefault();
      if (e.targetTouches.length === 1) {
        this._handleDown(this._getTouchPoint(e.changedTouches[0]));
      }
    }, { passive: false });

    this.canvas.addEventListener("touchmove", (e) => {
      e.preventDefault();
      this._handleMove(this._getTouchPoint(e.targetTouches[0]));
    }, { passive: false });

    this.canvas.addEventListener("touchend", (e) => {
      this._handleUp();
    });
  }

  _getTouchPoint(touch) {
    return { clientX: touch.clientX, clientY: touch.clientY };
  }

  _handleDown(event) {
    this._isDown = true;
    this._points = [];
    const point = this._createPoint(event);
    this._points.push(point);
    
    this._ctx.beginPath();
    this._ctx.moveTo(point.x, point.y);
    this._ctx.lineTo(point.x, point.y);
    this._ctx.lineWidth = this.lineWidth;
    this._ctx.lineCap = "round";
    this._ctx.lineJoin = "round";
    this._ctx.strokeStyle = this.penColor;
    this._ctx.stroke();
  }

  _handleMove(event) {
    if (!this._isDown) return;
    const point = this._createPoint(event);
    this._points.push(point);
    this._ctx.lineWidth = this.lineWidth;
    this._ctx.lineCap = "round";
    this._ctx.lineJoin = "round";
    this._ctx.strokeStyle = this.penColor;
    const prevPoint = this._points[this._points.length - 2];
    this._ctx.beginPath();
    this._ctx.moveTo(prevPoint.x, prevPoint.y);
    this._ctx.lineTo(point.x, point.y);
    this._ctx.stroke();
  }

  _handleUp() {
    this._isDown = false;
  }

  _createPoint(event) {
    const rect = this.canvas.getBoundingClientRect();
    return {
      x: event.clientX - rect.left,
      y: event.clientY - rect.top
    };
  }
}
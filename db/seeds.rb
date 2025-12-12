# db/seeds.rb

puts "🌱 Generating Atelier0 Daily Prompts for 1 Year..."

# 既存のお題をクリア（過去の投稿データは残りますが、お題の紐付けが消える可能性があるので注意。
# 開発中ならリセットでOKですが、運用中なら future prompts だけ消す処理にします）
# 今回は開発用として全消し＆再生成します
Prompt.destroy_all

# ==========================================
# 💎 Word Banks (Atelier0 Esthetic)
# ==========================================

colors = %w[
  Azure Crimson Indigo Pale\ Grey Neon\ Pink
  Vantablack Transparency Rust Amber Turquoise
  Midnight\ Blue Off-White Silver Gold Veridian
  Peach Lavender Charcoal Beige Ultramarine
]

natures = %w[
  Moss Fog Thunder Morning\ Dew Petal
  Roots Horizon Waves Storm Sunlight
  Cloud Moonlight Mud Forest Desert
  Ice Steam Stone Galaxy Breeze
]

abstracts = %w[
  Silence Echo Void Gravity Time
  Memory Dream Chaos Balance Rhythm
  Border Eternity Illusion Secret Truth
  Noise Harmony Solitude Hope Regret
]

objects = %w[
  Empty\ Chair Old\ Key Broken\ Mirror Window Door
  Ladder Candle Book Glass Knife
  Clock Phone Fabric Needle Ink
  Bridge Staircase Wall Roof Lamp
]

emotions = %w[
  Nostalgia Melancholy Euphoria Rage Calm
  Fear Envy Love Grief Anxiety
  Curiosity Pride Loneliness Comfort Desire
  Hesitation Relief Tension Apathy Zeal
]

actions = %w[
  Falling Floating Melting Waiting Whispering
  Running Hidden Blooming Burning Freezing
  Searching Dancing Breaking Flying Sleeping
  Touching Watching Breathing Screaming Smiling
]

# ==========================================
# 🗓️ Generation Logic
# ==========================================

start_date = Date.today
end_date = start_date + 1.year

(start_date..end_date).each do |date|
  content = ""
  
  # 曜日ごとのテーマ決定
  case date.wday
  when 1 # Monday: Color
    content = colors.sample
  when 2 # Tuesday: Nature
    content = natures.sample
  when 3 # Wednesday: Abstract
    content = abstracts.sample
  when 4 # Thursday: Object
    content = objects.sample
  when 5 # Friday: Emotion
    content = emotions.sample
  when 6 # Saturday: Action
    content = actions.sample
  when 0 # Sunday: Special Mix (2単語の組み合わせなど)
    dice = rand(1..3)
    if dice == 1
      content = "#{colors.sample} & #{natures.sample}" # 色と自然
    elsif dice == 2
      content = "The #{abstracts.sample}" # 定冠詞付きの概念
    else
      content = [colors, natures, abstracts, objects, emotions].flatten.sample # 完全ランダム
    end
  end

  # お題を作成
  Prompt.create!(
    date: date,
    content: content
  )
end

puts "✨ Done! Created #{Prompt.count} prompts from #{start_date} to #{end_date}."
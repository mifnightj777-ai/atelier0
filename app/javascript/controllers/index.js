import { application } from "controllers/application"

// ↓ 自動読み込みをやめて、1つずつ確実に登録します
// これにより「読み込みエラー」や「パスの間違い」が物理的に起きなくなります

import AudioPlayerController from "controllers/audio_player_controller"
application.register("audio-player", AudioPlayerController)

import AutosaveController from "controllers/autosave_controller"
application.register("autosave", AutosaveController)

import BookshelfController from "controllers/bookshelf_controller"
application.register("bookshelf", BookshelfController)

import ChatController from "controllers/chat_controller"
application.register("chat", ChatController)

import ClipboardController from "controllers/clipboard_controller"
application.register("clipboard", ClipboardController)

import ColorPickerController from "controllers/color_picker_controller"
application.register("color-picker", ColorPickerController)

import DrawerController from "controllers/drawer_controller"
application.register("drawer", DrawerController)

import FocusSoundController from "controllers/focus_sound_controller"
application.register("focus-sound", FocusSoundController)

import FocusTimerController from "controllers/focus_timer_controller"
application.register("focus-timer", FocusTimerController)

import FragmentUploadController from "controllers/fragment_upload_controller"
application.register("fragment-upload", FragmentUploadController)

import HandwritingController from "controllers/handwriting_controller"
application.register("handwriting", HandwritingController)

import HelloController from "controllers/hello_controller"
application.register("hello", HelloController)

import ImagePreviewController from "controllers/image_preview_controller"
application.register("image-preview", ImagePreviewController)

import InstallGuideController from "controllers/install_guide_controller"
application.register("install-guide", InstallGuideController)

import MailboxTabsController from "controllers/mailbox_tabs_controller"
application.register("mailbox-tabs", MailboxTabsController)

import MemoController from "controllers/memo_controller"
application.register("memo", MemoController)

import PaletteController from "controllers/palette_controller"
application.register("palette", PaletteController)

import ProfileTabsController from "controllers/profile_tabs_controller"
application.register("profile-tabs", ProfileTabsController)

import ReadMoreController from "controllers/read_more_controller"
application.register("read-more", ReadMoreController)

import TopTabsController from "controllers/top_tabs_controller"
application.register("top-tabs", TopTabsController)

import TutorialController from "controllers/tutorial_controller"
application.register("tutorial", TutorialController)
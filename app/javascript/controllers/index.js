import { application } from "./application"

// Import and register all your controllers from here
import FlashController from "./flash_controller"
application.register("flash", FlashController)

import { application } from "./application"

// Import and register all your controllers from here
import HelloController from "./hello_controller"
application.register("hello", HelloController)

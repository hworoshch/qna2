// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "../../assets/stylesheets/application"
import "@fortawesome/fontawesome-free/js/all"
import "bootstrap"
import "cocoon-js"
import { Octokit } from "@octokit/rest"
import "handlebars-loader"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("packs/answers")
require("packs/questions")
require("packs/votes")
require("packs/comments")

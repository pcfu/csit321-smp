// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import 'channels'
import 'bootstrap'
import 'common/navbar'

Rails.start()
// Turbolinks.start()
ActiveStorage.start()

const jQuery = require('jquery');
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

require('datatables.net');
require('datatables.net-bs5');
require('styles/application');

//= require jquery_ujs
//= reuire jquery3
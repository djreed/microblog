// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

let handlebars = require("handlebars");

$(function() {

  if (!$("#likes-template").length > 0) {
    // Wrong page.
    return;
  }

  let tt = $($("#likes-template")[0]);
  let code = tt.html();
  let tmpl = handlebars.compile(code);

  let likes = $(".post-likes");
  let path = likes.data('path');

  function fetch_likes() {
    let p_id = $(this).data('post-id')

    function got_likes(data) {
      console.log(data);
      let html = tmpl(data);
      likes.html(html);
    }

    $.ajax({
      url: path,  // "/api/v1/likes"
      data: {post_id: p_id},
      contentType: "application/json",
      dataType: "json",
      method: "GET",
      success: got_likes,
    });
  }

  function add_like() {
    let butt = $(this)

    let p_id = butt.data('post-id');
    let u_id = butt.data('user-id');

    let data = {
      like: {
        post_id: p_id,
        user_id: u_id
      }
    };

    $.ajax({
      url: path,
      data: JSON.stringify(data),
      contentType: "application/json",
      dataType: "json",
      method: "POST",
      success: fetch_likes,
    });
  };

  $(".like-add-button").each(function() {
    $(this).click(add_like);
  });

  $(".post-likes").each(function() {
    fetch_likes();
  });
});
